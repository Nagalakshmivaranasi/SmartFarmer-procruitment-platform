import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../../core/utils/quality_evaluator.dart';

class SlotStatusScreen extends StatefulWidget {
  final String? initialToken;

  const SlotStatusScreen({super.key, this.initialToken});

  @override
  State<SlotStatusScreen> createState() => _SlotStatusScreenState();
}

class _SlotStatusScreenState extends State<SlotStatusScreen> {
  final _database = IsarDatabaseService();
  final _searchController = TextEditingController();

  BookingModel? _booking;
  Map<String, dynamic>? _queueData;
  bool _isLoading = false;
  bool _isActionProcessing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    final token = widget.initialToken?.trim() ?? '';
    if (token.isNotEmpty) {
      _searchController.text = token;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_searchController.text.isNotEmpty) {
        _fetchByToken(_searchController.text);
      } else {
        _fetchFarmerLatestSlot();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchFarmerLatestSlot() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = SessionService.instance.currentUser;
      final farmerId = user?.farmerId ?? user?.uid ?? '';

      if (farmerId.isNotEmpty) {
        final bookings = await _database.farmerBookings(farmerId);
        if (bookings.isNotEmpty && mounted) {
          final latest = bookings.last;
          _searchController.text = latest.token;
          await _loadSlotDetails(latest);
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading farmer slot: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchByToken(String input) async {
    final clean = input.trim().toUpperCase();
    if (clean.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final tokenQuery = clean.startsWith('KST-') ? clean : 'KST-$clean';
      final match = await _database.bookingByToken(tokenQuery);

      if (match == null) {
        if (mounted) {
          setState(() {
            _booking = null;
            _queueData = null;
            _errorMessage = 'No booking found for token "$tokenQuery".';
            _isLoading = false;
          });
        }
        return;
      }

      await _loadSlotDetails(match);
    } catch (e) {
      if (mounted) {
        setState(() {
          _booking = null;
          _queueData = null;
          _errorMessage = 'Failed to load booking: $e';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadSlotDetails(BookingModel booking) async {
    Map<String, dynamic>? queue;

    if (_isWaitingInQueue(booking.status)) {
      try {
        final allBookings = await _database.bookingsForCentre(booking.centreId);
        final waitingQueue = allBookings
            .where((b) => b.status.toLowerCase().trim() == 'slot booked')
            .toList();

        final currentServing = waitingQueue.isNotEmpty
            ? waitingQueue.first.token
            : booking.token;
        final userIndex = waitingQueue.indexWhere(
          (b) => b.token.toUpperCase() == booking.token.toUpperCase(),
        );

        final ahead = userIndex > 0 ? userIndex : 0;
        final minutes = ahead == 0 ? 5 : ahead * 45;

        queue = {
          'serving': currentServing,
          'ahead': ahead,
          'waitMinutes': minutes,
        };
      } catch (_) {
        queue = {
          'serving': booking.token,
          'ahead': 0,
          'waitMinutes': 5,
        };
      }
    }

    if (mounted) {
      setState(() {
        _booking = booking;
        _queueData = queue;
        _isLoading = false;
        _errorMessage = null;
      });
    }
  }

  bool _isOwner(BookingModel b) {
    final user = SessionService.instance.currentUser;
    final currentId = user?.farmerId ?? user?.uid ?? '';
    if (currentId.isEmpty) return false;
    return b.farmerId.trim().toLowerCase() == currentId.trim().toLowerCase();
  }

  bool _isWaitingInQueue(String status) {
    final s = status.toLowerCase().trim();
    return s == 'slot booked';
  }

  bool _isRejected(String status) {
    final s = status.toLowerCase();
    return s.contains('decline') || s.contains('reject') || s.contains('cancel');
  }

  int _currentMilestoneIndex(String status) {
    final s = status.toLowerCase();
    if (_isRejected(s)) return 3; // Stopped at Farmer Approval stage
    if (s.contains('completed') || s.contains('paid')) return 4;
    if (s.contains('approval') ||
        s.contains('settlement') ||
        s.contains('rate') ||
        s.contains('accepted')) {
      return 3;
    }
    if (s.contains('inspection') || s.contains('testing') || s.contains('lab')) {
      return 2;
    }
    if (s.contains('arrived') || s.contains('gate') || s.contains('weigh')) {
      return 1;
    }
    return 0;
  }

  Future<void> _handleFarmerDecision(bool accept) async {
    if (_booking == null) return;
    setState(() => _isActionProcessing = true);

    try {
      final b = _booking!;
      if (accept) {
        b.status = 'Partial Acceptance - Farmer Accepted';
        b.paymentStatus = 'Pending Officer DBT Disbursement';
      } else {
        b.status = 'Farmer Declined Partial Deduction';
        b.paymentStatus = 'Rejected by Farmer';
      }

      await _database.saveBooking(b);
      await _loadSlotDetails(b);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(accept
              ? 'Offer accepted! Forwarded to Officer for payment release.'
              : 'Offer declined. Lot marked as rejected.'),
          backgroundColor: accept ? AppColors.primary : Colors.red.shade700,
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error recording decision: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isActionProcessing = false);
    }
  }

  bool _isPendingFarmerApproval(BookingModel b) {
    if (!_isOwner(b)) return false;
    final s = b.status.toLowerCase();
    return s.contains('partial') &&
        (s.contains('approval needed') || s.contains('action required'));
  }

  bool _hasQualityOrFinancialData(BookingModel b) {
    if (!_isOwner(b)) return false;
    final s = b.status.toLowerCase().trim();
    final hasInspectionStage = s.contains('inspection') ||
        s.contains('partial') ||
        s.contains('approved') ||
        s.contains('completed') ||
        s.contains('paid') ||
        _isRejected(s);

    final hasRecordedData = (b.netPayableAmount ?? 0.0) > 0 ||
        (b.finalRatePerQuintal ?? 0.0) > 0 ||
        (b.moistureLevel ?? 0.0) > 0;
    return hasInspectionStage || hasRecordedData;
  }

  String _determineQualityGrade(
      double deductionPct, double moisture, double foreign) {
    if (deductionPct <= 0.0 && moisture <= 12.0 && foreign <= 1.0) {
      return 'FAQ Grade I (Superior / Full MSP)';
    } else if (deductionPct <= 3.0) {
      return 'FAQ Grade II (Standard Fair Average Quality)';
    } else if (deductionPct <= 7.0) {
      return 'Grade III (Conditional / Parameter Variance)';
    } else {
      return 'Substandard (High Parameter Deviation)';
    }
  }

  @override
  Widget build(BuildContext context) {
    final booking = _booking;
    final queue = _queueData;
    final bool isDeclined = booking != null && _isRejected(booking.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Slot Live Status',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search input
              TextField(
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted: _fetchByToken,
                decoration: InputDecoration(
                  hintText: 'Enter Token (e.g. KST-1001)',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                      const Icon(Icons.search, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.arrow_forward_rounded,
                        color: AppColors.primary),
                    onPressed: () => _fetchByToken(_searchController.text),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFF87171)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          color: Colors.red, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style:
                              const TextStyle(color: Colors.red, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                )
              else if (booking != null) ...[
                // REJECTION / DECLINED BANNER
                if (isDeclined) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.red.shade400, width: 1.2),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.cancel_outlined,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Consignment Rejected / Returned',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.red.shade900,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                booking.status,
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // LIVE QUEUE BANNER
                if (_isWaitingInQueue(booking.status) && queue != null) ...[
                  _buildLiveQueueCard(booking, queue),
                  const SizedBox(height: 16),
                ],

                // ACTION REQUIRED CARD
                if (_isPendingFarmerApproval(booking)) ...[
                  _buildApprovalActionCard(booking),
                  const SizedBox(height: 16),
                ],

                // SETTLEMENT / LAB CARD
                if (_hasQualityOrFinancialData(booking)) ...[
                  _buildSettlementCard(booking, isDeclined: isDeclined),
                  const SizedBox(height: 16),
                ] else if (!_isOwner(booking)) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lock_outline,
                            size: 18, color: AppColors.textSecondary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Financial settlements and lab inspection reports are confidential to the token owner.',
                            style: TextStyle(
                                fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // BOOKING DETAILS CARD
                _buildDetailsCard(booking),
                const SizedBox(height: 20),

                // MILESTONES
                const Text(
                  'Procurement Milestones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildMilestonesCard(booking, isDeclined: isDeclined),
              ] else
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.qr_code_2_rounded,
                          size: 56, color: AppColors.textMuted),
                      SizedBox(height: 12),
                      Text(
                        'Search your token number to view live slot status and mandi queue.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApprovalActionCard(BookingModel b) {
    final double baseRate =
        (b.baseMspRate ?? 0.0) > 0 ? b.baseMspRate! : 2275.0;
    final double deductionPct = b.deductionPercentage ?? 0.0;
    final double deductionCutPerQtl = baseRate * (deductionPct / 100.0);
    final double finalRate = (b.finalRatePerQuintal ?? 0.0) > 0
        ? b.finalRatePerQuintal!
        : (baseRate - deductionCutPerQtl);
    final double netPayable = (b.netPayableAmount ?? 0.0) > 0
        ? b.netPayableAmount!
        : (finalRate * b.quantityQuintal);
    final double totalDeductionCut = deductionCutPerQtl * b.quantityQuintal;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade400, width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.assignment_late_outlined,
                  color: Colors.orange.shade800, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Action Required: Review Quality Offer',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Your lot of ${b.quantityQuintal.toStringAsFixed(1)} Qtl (${b.crop}) was evaluated with a ${deductionPct.toStringAsFixed(1)}% quality deduction (-₹${deductionCutPerQtl.toStringAsFixed(2)}/Qtl, total cut: -₹${totalDeductionCut.toStringAsFixed(2)}).',
            style: const TextStyle(
                fontSize: 13, color: AppColors.textPrimary, height: 1.4),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Offered Rate: ₹${finalRate.toStringAsFixed(2)}/Qtl',
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              Text('Total: ₹${netPayable.toStringAsFixed(2)}',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.orange.shade900)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isActionProcessing
                      ? null
                      : () => _handleFarmerDecision(false),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red.shade700,
                    side: BorderSide(color: Colors.red.shade400),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Decline Lot',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isActionProcessing
                      ? null
                      : () => _handleFarmerDecision(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: _isActionProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text('Accept Offer',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

Widget _buildSettlementCard(BookingModel b, {bool isDeclined = false}) {
    // 1. Base Benchmark
    final double baseRate =
        (b.baseMspRate != null && b.baseMspRate! > 0) ? b.baseMspRate! : QualityEvaluator.baseMsp;

    // 2. Read the EXACT deduction percentage recorded by the officer
    final double deductionPct = b.deductionPercentage ?? 0.0;
    final bool hasDeduction = deductionPct > 0.0;

    // 3. Read the EXACT final rate saved by the officer, fallback only if null
    final double finalRate = (b.finalRatePerQuintal != null && b.finalRatePerQuintal! > 0)
        ? b.finalRatePerQuintal!
        : (baseRate * (1.0 - (deductionPct / 100.0)));

    // 4. Exact rate deduction per Quintal (Base - Final)
    final double deductionCostPerQtl = hasDeduction
        ? (baseRate - finalRate).clamp(0.0, baseRate)
        : 0.0;

    // 5. Total Net Produce Weight
    final double totalWeight = b.quantityQuintal > 0 ? b.quantityQuintal : 1.0;

    // 6. Read the EXACT net payout calculated by the officer
    final double netPayable = (b.netPayableAmount != null && b.netPayableAmount! > 0)
        ? b.netPayableAmount!
        : (finalRate * totalWeight);

    // 7. Gross lot value & total cut
    final double grossValue = baseRate * totalWeight;
    final double totalDeductionAmount = (grossValue - netPayable).clamp(0.0, grossValue);

    // 8. Quality Parameters directly from database
    final double moisture = b.moistureLevel ?? 0.0;
    final double foreign = b.foreignMatterLevel ?? 0.0;
    final double damaged = b.damagedGrainsLevel ?? 0.0;

    // Grade directly derived
    final String qualityGrade = _determineQualityGrade(deductionPct, moisture, foreign);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Lab Inspection & Payout Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                isDeclined ? '₹ 0.00 (Declined)' : '₹ ${netPayable.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDeclined ? Colors.red : AppColors.primary,
                ),
              ),
            ],
          ),
          const Divider(height: 18),
          _settleRow(
            'Assigned Quality Grade',
            qualityGrade,
            color: hasDeduction ? Colors.orange.shade900 : const Color(0xFF15803D),
            isBold: true,
          ),
          _settleRow('Base MSP Benchmark', '₹ ${baseRate.toStringAsFixed(2)} / Qtl'),
          _settleRow('Net Measured Weight', '${totalWeight.toStringAsFixed(2)} Qtl'),
          _settleRow('Gross Lot Value', '₹ ${grossValue.toStringAsFixed(2)}'),
          _settleRow('Lab Moisture Level', '${moisture.toStringAsFixed(1)}% (FAQ ≤ 12.0%)'),
          _settleRow('Foreign Matter', '${foreign.toStringAsFixed(1)}% (FAQ ≤ 1.0%)'),
          if (damaged > 0)
            _settleRow('Damaged / Discolored', '${damaged.toStringAsFixed(1)}% (Limit ≤ 2.0%)'),

          if (hasDeduction) ...[
            _settleRow(
              'Quality Deduction (${deductionPct.toStringAsFixed(1)}%)',
              '- ₹ ${deductionCostPerQtl.toStringAsFixed(2)} / Qtl',
              color: Colors.orange.shade900,
            ),
            _settleRow(
              'Total Value Deduction',
              '- ₹ ${totalDeductionAmount.toStringAsFixed(2)}',
              color: Colors.red.shade900,
              isBold: true,
            ),
          ] else ...[
            _settleRow('Deduction Rate', '0.0% (Zero Penalties)', color: const Color(0xFF15803D)),
          ],

          const Divider(height: 14),
          _settleRow(
            'Final Approved Rate',
            isDeclined ? 'Offer Rejected by Farmer' : '₹ ${finalRate.toStringAsFixed(2)} / Qtl',
            color: isDeclined ? Colors.red : AppColors.textPrimary,
            isBold: true,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDeclined
                  ? const Color(0xFFFEE2E2)
                  : AppColors.mintGreen.withAlpha(60),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isDeclined ? 'Status' : 'Net DBT Payout',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: isDeclined ? Colors.red.shade900 : AppColors.textPrimary,
                  ),
                ),
                Text(
                  isDeclined ? 'Lot Marked for Return' : '₹ ${netPayable.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDeclined ? Colors.red.shade900 : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settleRow(String title, String val,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            val,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveQueueCard(BookingModel b, Map<String, dynamic> q) {
    final servingToken = q['serving']?.toString() ?? b.token;
    final int ahead = q['ahead'] is int ? q['ahead'] : 0;
    final int waitMinutes = q['waitMinutes'] is int ? q['waitMinutes'] : 5;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.sensors, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'LIVE QUEUE TRACKER',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    b.status,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(35),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Now Serving',
                          style:
                              TextStyle(color: Colors.white70, fontSize: 10)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          servingToken,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Token',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 10)),
                      const SizedBox(height: 2),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          b.token,
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    ahead == 0
                        ? 'You are next in queue!'
                        : '$ahead vehicles ahead',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  ahead == 0 ? '~5 mins' : 'Est. ~$waitMinutes mins',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(BookingModel b) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${b.crop} • ${b.quantityQuintal.toStringAsFixed(1)} Qtl',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.mintGreen,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  b.token,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            b.centreName,
            style:
                const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Date: ${b.bookingDate.day}/${b.bookingDate.month}/${b.bookingDate.year}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Window: ${b.slotTime}',
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMilestonesCard(BookingModel b, {bool isDeclined = false}) {
    final activeIndex = _currentMilestoneIndex(b.status);

    final milestones = [
      {'title': 'Slot Booked', 'desc': 'Token verified & allocated in system'},
      {'title': 'Gate Arrival & Weighment', 'desc': 'Vehicle gross weighment recorded'},
      {'title': 'Quality Testing & Inspection', 'desc': 'Moisture & grain purity test completed'},
      {
        'title': isDeclined
            ? 'Offer Declined by Farmer'
            : 'Farmer Settlement & Approval',
        'desc': isDeclined
            ? 'Consignment rejected and marked for return'
            : 'Rate verification and acceptance'
      },
      {'title': 'Completed', 'desc': 'Lot stored and DBT payout released'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: List.generate(milestones.length, (index) {
          final isDone = index < activeIndex;
          final isCurrent = index == activeIndex;
          final item = milestones[index];

          Color avatarColor;
          IconData avatarIcon;

          if (isDeclined && index == 3) {
            avatarColor = Colors.red;
            avatarIcon = Icons.close;
          } else if (isDone) {
            avatarColor = AppColors.primary;
            avatarIcon = Icons.check;
          } else if (isCurrent) {
            avatarColor = Colors.orange;
            avatarIcon = Icons.circle;
          } else {
            avatarColor = const Color(0xFFE2E8F0);
            avatarIcon = Icons.circle;
          }

          return Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isCurrent
                  ? (isDeclined
                      ? const Color(0xFFFEF2F2)
                      : AppColors.mintGreen.withAlpha(35))
                  : Colors.transparent,
              border: index != milestones.length - 1
                  ? const Border(
                      bottom: BorderSide(
                          color: AppColors.border, width: 0.6))
                  : null,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: avatarColor,
                  child: Icon(avatarIcon, size: 12, color: Colors.white),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']!,
                        style: TextStyle(
                          fontWeight: isCurrent || isDone
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isDeclined && index == 3
                              ? Colors.red.shade900
                              : (isCurrent
                                  ? AppColors.primary
                                  : (isDone
                                      ? AppColors.textPrimary
                                      : AppColors.textMuted)),
                          fontSize: 13,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['desc']!,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondary),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isDeclined && index == 3)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'DECLINED',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                else if (isDone)
                  const Icon(Icons.check_circle,
                      color: AppColors.primary, size: 16)
                else if (isCurrent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'COMPLETED',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
