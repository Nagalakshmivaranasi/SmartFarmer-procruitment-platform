import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../models/core_models.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../notifications/screens/notifications_screen.dart';
import '../../profile/screens/profile_screen.dart';
import 'my_bookings_screen.dart';
import 'procurement_status_stepper_screen.dart';
import 'slot_booking_wizard.dart';
import 'slot_status_screen.dart';
import '../../payment/screens/payment_status_screen.dart';
import 'package:smart_farmer_procurement/core/locale/locale_provider.dart';
import 'package:smart_farmer_procurement/l10n/generated/app_localizations.dart';

class FarmerHomeDashboard extends StatefulWidget {
  const FarmerHomeDashboard({super.key});

  @override
  State<FarmerHomeDashboard> createState() => _FarmerHomeDashboardState();
}

class _FarmerHomeDashboardState extends State<FarmerHomeDashboard> {
  final _database = IsarDatabaseService();
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFarmerData();
  }

  Future<void> _loadFarmerData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = SessionService.instance.currentUser;
      final farmerId = user?.farmerId ?? user?.uid ?? '';

      if (farmerId.isNotEmpty) {
        final list = await _database.farmerBookings(farmerId);
        if (mounted) {
          setState(() {
            _bookings = list;
            _isLoading = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('Error loading farmer bookings: $e');
    }

    if (mounted) setState(() => _isLoading = false);
  }

  bool _isCompleted(BookingModel b) {
    final s = b.status.toLowerCase().trim();
    return s == 'procurement completed' ||
        s.contains('paid') ||
        s.contains('rejected') ||
        s.contains('decline') ||
        b.paymentStatus == 'Payment Successful (DBT Paid)';
  }

  bool get _areAllSlotsCompleted {
    if (_bookings.isEmpty) return false;
    return _bookings.every(_isCompleted);
  }

  BookingModel? get _actionRequiredBooking {
    try {
      return _bookings.firstWhere(
        (b) =>
            b.status.toLowerCase().contains('partial') &&
            (b.status.toLowerCase().contains('approval needed') ||
                b.status.toLowerCase().contains('action required')),
      );
    } catch (_) {
      return null;
    }
  }

  BookingModel? get _activeTrackingBooking {
    try {
      return _bookings.lastWhere(
        (b) => !_isCompleted(b),
      );
    } catch (_) {
      return _bookings.isNotEmpty ? _bookings.last : null;
    }
  }

  SlotBooking _mapToSlotBooking(BookingModel model) {
    final user = SessionService.instance.currentUser;

    BookingStatus mappedStatus;
    final normalized =
        model.status.toLowerCase().replaceAll(RegExp(r'[\s\-_]'), '');

    try {
      mappedStatus = BookingStatus.values.firstWhere(
        (e) => e.name.toLowerCase() == normalized,
      );
    } catch (_) {
      mappedStatus = BookingStatus.slotBooked;
    }

    return SlotBooking(
      id: model.bookingId,
      farmerId: model.farmerId,
      farmerName: model.farmerName,
      farmerPhone: user?.phoneNumber ?? '',
      cropName: model.crop,
      season: 'Rabi 2026',
      estimatedQuantityQuintal: model.quantityQuintal,
      state: 'Madhya Pradesh',
      district: 'Shivpuri',
      centerId: model.centreId,
      centerName: model.centreName,
      bookingDate: model.bookingDate,
      timeSlot: model.slotTime,
      tokenNumber: model.token,
      status: mappedStatus,
      createdAt: model.createdAt ?? DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionUser = SessionService.instance.currentUser;
    final String farmerName =
        (sessionUser != null && sessionUser.name.trim().isNotEmpty)
            ? sessionUser.name
            : 'Kisan';

    final BookingModel? actionBooking = _actionRequiredBooking;
    final BookingModel? currentSlot = _activeTrackingBooking;
    final bool allDone = _areAllSlotsCompleted;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.appTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          // High-visibility, reactive language switcher
          Consumer<LocaleProvider>(
            builder: (context, localeProv, child) {
              final isTelugu = localeProv.isTelugu;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => localeProv.toggleLocale(),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white, width: 1.2),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.language, size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          isTelugu ? 'ENG' : 'తెలుగు',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none),
            tooltip: l10n.alerts,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadFarmerData,
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.mintGreen,
              child: Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
            tooltip: 'My Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadFarmerData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaste, $farmerName 🌾',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // 1. ACTION REQUIRED BANNER
                    if (actionBooking != null)
                      _buildActionOfferCard(context, actionBooking, l10n),

                    // 2. STATUS CARD (All Completed vs Active Tracking vs Empty)
                    if (allDone)
                      _buildAllCompletedCard(context)
                    else if (currentSlot != null)
                      _buildActiveSlotCard(context, currentSlot, l10n)
                    else
                      _buildNoBookingsCard(),

                    const SizedBox(height: 24),
                    const Text(
                      'Quick Access',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // 3. QUICK ACCESS GRID WITH LOCALIZED LABELS
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: [
                        _QuickCard(
                          icon: Icons.calendar_month_outlined,
                          label: l10n.bookSlot,
                          color: AppColors.mintGreen,
                          iconColor: AppColors.primary,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SlotBookingWizard(),
                              ),
                            ).then((_) => _loadFarmerData());
                          },
                        ),
                        _QuickCard(
                          icon: Icons.account_balance_wallet_outlined,
                          label: l10n.payments,
                          color: const Color(0xFFE8F5E9),
                          iconColor: AppColors.statusSuccess,
                          onTap: () {
                            final user = SessionService.instance.currentUser;
                            final farmerId = user?.farmerId ?? user?.uid ?? '';
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentStatusScreen(farmerId: farmerId),
                              ),
                            ).then((_) => _loadFarmerData());
                          },
                        ),
                        _QuickCard(
                          icon: Icons.receipt_long_outlined,
                          label: l10n.myBookings,
                          color: const Color(0xFFE0F2FE),
                          iconColor: const Color(0xFF0284C7),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyBookingsScreen(),
                              ),
                            ).then((_) => _loadFarmerData());
                          },
                        ),
                        _QuickCard(
                          icon: Icons.timelapse_outlined,
                          label: l10n.slotStatus,
                          color: const Color(0xFFFEF3C7),
                          iconColor: const Color(0xFFD97706),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SlotStatusScreen(
                                  initialToken: currentSlot?.token,
                                ),
                              ),
                            ).then((_) => _loadFarmerData());
                          },
                        ),
                        _QuickCard(
                          icon: Icons.edit_calendar_outlined,
                          label: l10n.reschedule,
                          color: const Color(0xFFF1F5F9),
                          iconColor: const Color(0xFF475569),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(l10n.selectActiveBookingReschedule),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                        _QuickCard(
                          icon: Icons.notifications_active_outlined,
                          label: l10n.alerts,
                          color: const Color(0xFFF3E8FF),
                          iconColor: const Color(0xFF9333EA),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const NotificationsScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildActionOfferCard(
      BuildContext context, BookingModel b, AppLocalizations l10n) {
    final double baseMsp =
        (b.baseMspRate ?? 0.0) > 0 ? b.baseMspRate! : 2275.0;
    final double deductionPct = b.deductionPercentage ?? 0.0;
    final double rateCut = baseMsp * (deductionPct / 100.0);
    final double finalRate = (b.finalRatePerQuintal ?? 0.0) > 0
        ? b.finalRatePerQuintal!
        : (baseMsp - rateCut);
    final double totalPayable = (b.netPayableAmount ?? 0.0) > 0
        ? b.netPayableAmount!
        : (finalRate * b.quantityQuintal);
    final double totalDeduction = rateCut * b.quantityQuintal;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.orange.shade600, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded,
                  color: Colors.orange, size: 26),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Action Needed: Review Offer (${b.token})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.brown,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Lot: ${b.crop} • ${b.quantityQuintal.toStringAsFixed(1)} Qtl at ${b.centreName}',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 4),
          Text(
            'Quality evaluation applied a ${deductionPct.toStringAsFixed(1)}% deduction (-₹${rateCut.toStringAsFixed(2)}/Qtl, total cut: -₹${totalDeduction.toStringAsFixed(2)}). Final proposed rate: ₹${finalRate.toStringAsFixed(2)}/Qtl.',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textPrimary, height: 1.35),
          ),
          const SizedBox(height: 6),
          Text(
            '${l10n.totalNetPayable}: ₹ ${totalPayable.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.orange.shade900,
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(40),
            ),
            icon: const Icon(Icons.rate_review_outlined, size: 18),
            label: Text(l10n.reviewProcurementOffer),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SlotStatusScreen(initialToken: b.token),
                ),
              ).then((_) => _loadFarmerData());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAllCompletedCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Color(0xFF166534),
            child:
                Icon(Icons.check_circle_outline, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Slots Completed',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF166534),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'All your scheduled consignments are procured and settled.',
                  style: TextStyle(fontSize: 12, color: Color(0xFF14532D)),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyBookingsScreen()),
              );
            },
            child: const Text('History',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSlotCard(
      BuildContext context, BookingModel b, AppLocalizations l10n) {
    final bool isPaid = b.paymentStatus == 'Payment Successful (DBT Paid)' ||
        b.status.toLowerCase().contains('paid');
    final double netAmount = b.netPayableAmount ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${l10n.token}: ${b.token}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                children: [
                  if (isPaid)
                    Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '₹ ${l10n.paid}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade900,
                        ),
                      ),
                    ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.mintGreen,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      b.status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${b.crop} • ${b.quantityQuintal.toStringAsFixed(1)} ${l10n.quintal}\n${b.centreName}',
            style:
                const TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          if (netAmount > 0.0) ...[
            const SizedBox(height: 8),
            Text(
              '${l10n.totalNetPayable}: ₹ ${netAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
          const SizedBox(height: 14),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProcurementStatusStepperScreen(
                    booking: _mapToSlotBooking(b),
                  ),
                ),
              );
            },
            child:
                const Text('Track Live Status', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoBookingsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: const Text(
        'No active procurements.\nBook your slot to get started.',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textSecondary, height: 1.4),
      ),
    );
  }
}

class _QuickCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color,
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}