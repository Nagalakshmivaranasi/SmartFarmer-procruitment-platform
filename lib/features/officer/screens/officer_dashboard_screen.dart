import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../auth/screens/splash_welcome_screen.dart';
import 'gate_verification_screen.dart';
import 'officer_payment_screen.dart';
import 'payment_success_screen.dart';
import 'quality_inspection_form_screen.dart';
import 'slot_verification_screen.dart';

class OfficerDashboardScreen extends StatefulWidget {
  const OfficerDashboardScreen({super.key});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  final _database = IsarDatabaseService();
  List<BookingModel> _bookings = [];
  bool _isLoading = true;
  int _activeSegment = 0; // 0 = Pending, 1 = Action Needed, 2 = Completed
  DateTime _selectedPendingDate = DateTime.now(); // Date filter for pending slots

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final user = SessionService.instance.currentUser;
      final rawCentreId = user?.centreId?.trim();
      final centreId = (rawCentreId != null && rawCentreId.isNotEmpty)
          ? rawCentreId
          : 'CTR-01';

      final list = await _database.bookingsForCentre(centreId);

      if (!mounted) return;
      setState(() {
        _bookings = list;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('OfficerDashboard: error loading bookings: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _cleanStatus(BookingModel? b) {
    if (b == null) return 'Slot Booked';
    final s = b.status;
    return s.trim().isEmpty ? 'Slot Booked' : s.trim();
  }

  bool _isDeclinedOrRejected(String status) {
    final s = status.toLowerCase();
    return s.contains('decline') ||
        s.contains('reject') ||
        s.contains('cancel') ||
        s.contains('return');
  }

int _parseTimeToMinutes(String timeStr) {
    if (timeStr.isEmpty) return 0;
    final lower = timeStr.toLowerCase();
    try {
      final regExp = RegExp(r'(\d+)(?::(\d+))?\s*(am|pm)?');
      final match = regExp.firstMatch(lower);
      if (match != null) {
        int hour = int.parse(match.group(1)!);
        int minute = match.group(2) != null ? int.parse(match.group(2)!) : 0;
        String? period = match.group(3);

        if (period == 'pm' && hour < 12) hour += 12;
        if (period == 'am' && hour == 12) hour = 0;

        return hour * 60 + minute;
      }
    } catch (_) {}
    return 0;
  }

  // 2. Updated _pendingList with chronological time sorting
List<BookingModel> get _pendingList {
    final list = _bookings.where((b) {
      final s = _cleanStatus(b).toLowerCase();
      if (_isDeclinedOrRejected(s)) return false;
      
      final isPendingStatus = s == 'slot booked' ||
          s == 'arrived at center' ||
          s == 'under inspection';
      
      if (!isPendingStatus) return false;

      // Filter by the actual scheduled booking date
      final bookingDate = b.bookingDate;
      
      return bookingDate.year == _selectedPendingDate.year &&
             bookingDate.month == _selectedPendingDate.month &&
             bookingDate.day == _selectedPendingDate.day;
    }).toList();

    // Sort chronologically by slot time (10 AM, 11 AM, etc.)
    list.sort((a, b) => _parseTimeToMinutes(a.slotTime).compareTo(_parseTimeToMinutes(b.slotTime)));
    
    return list;
  }

  List<BookingModel> get _actionList {
    return _bookings.where((b) {
      final s = _cleanStatus(b).toLowerCase();
      if (_isDeclinedOrRejected(s)) return false;

      return s.contains('farmer accepted') ||
          s.contains('ready') ||
          s == 'partial acceptance - farmer approval needed';
    }).toList();
  }

  List<BookingModel> get _doneList {
    return _bookings.where((b) {
      final s = _cleanStatus(b).toLowerCase();
      return s == 'procurement completed' ||
          s.contains('paid') ||
          _isDeclinedOrRejected(s);
    }).toList();
  }

  List<BookingModel> get _currentList {
    if (_activeSegment == 1) return _actionList;
    if (_activeSegment == 2) return _doneList;
    return _pendingList;
  }

  void _routeBooking(BookingModel b) {
    final s = _cleanStatus(b).toLowerCase();

    if (_isDeclinedOrRejected(s)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.cancel_outlined, color: Colors.red),
              SizedBox(width: 8),
              Text('Lot Return / Exit Gatepass'),
            ],
          ),
          content: Text(
            'Token: ${b.token}\nFarmer: ${b.farmerName}\nStatus: ${b.status}\n\nProduce (${b.crop} • ${b.quantityQuintal.toStringAsFixed(1)} Qtl) is marked for return and cleared for gate exit.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return;
    }

    if (s == 'slot booked') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => GateVerificationScreen(booking: b)),
      ).then((_) => _loadBookings());
    } else if (s == 'arrived at center' || s == 'under inspection') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => QualityInspectionFormScreen(booking: b)),
      ).then((_) => _loadBookings());
    } else if (s.contains('approved') ||
        s.contains('ready') ||
        s.contains('farmer accepted')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OfficerPaymentScreen(booking: b)),
      ).then((_) => _loadBookings());
    } else if (s == 'procurement completed' || s.contains('paid')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PaymentSuccessScreen(booking: b)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Status: ${_cleanStatus(b)}'),
          backgroundColor: Colors.orange.shade800,
        ),
      );
    }
  }

  void _showProfileModal() {
    final user = SessionService.instance.currentUser;
    final name = (user?.name != null && user!.name.trim().isNotEmpty)
        ? user.name.trim()
        : 'Procurement Officer';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'O';

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 34,
                backgroundColor: AppColors.mintGreen,
                child: Text(
                  initial,
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 12),
              Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(
                'Officer ID: ${user?.officerId ?? "OFF-DEMO"}',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 18),
              _infoTile('Phone', user?.phoneNumber ?? 'N/A'),
              _infoTile('Centre ID', user?.centreId ?? 'CTR-01'),
              _infoTile('District',
                  '${user?.district ?? "Shivpuri"}, ${user?.state ?? "MP"}'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    final navigator = Navigator.of(context);
                    await SessionService.instance.clear();
                    if (!mounted) return;
                    navigator.pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (_) => const SplashWelcomeScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoTile(String label, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          Text(val,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }

  Color _badgeBg(String status) {
    final s = status.toLowerCase();
    if (s.contains('decline') || s.contains('reject')) return const Color(0xFFFEE2E2);
    if (s.contains('completed') || s.contains('paid')) return const Color(0xFFDCFCE7);
    if (s.contains('arrived')) return const Color(0xFFE0F2FE);
    if (s.contains('approved') || s.contains('ready')) return const Color(0xFFECFDF5);
    if (s.contains('partial') || s.contains('approval')) return const Color(0xFFFEF3C7);
    return AppColors.mintGreen;
  }

  Color _badgeText(String status) {
    final s = status.toLowerCase();
    if (s.contains('decline') || s.contains('reject')) return const Color(0xFFB91C1C);
    if (s.contains('completed') || s.contains('paid')) return const Color(0xFF166534);
    if (s.contains('arrived')) return const Color(0xFF0369A1);
    if (s.contains('approved') || s.contains('ready')) return const Color(0xFF047857);
    if (s.contains('partial') || s.contains('approval')) return const Color(0xFFB45309);
    return AppColors.primary;
  }

  String _badgeDisplayLabel(String status) {
    final s = status.toLowerCase();
    if (s.contains('decline')) return 'Declined';
    if (s.contains('reject')) return 'Rejected';
    if (s.contains('farmer accepted')) return 'Accepted';
    if (s.contains('partial')) return 'Partial';
    if (s.contains('approved') || s.contains('ready')) return 'Approved';
    if (s.contains('completed') || s.contains('paid')) return 'Completed';
    if (s.contains('arrived')) return 'Arrived';
    return 'Booked';
  }

  String _actionText(String status) {
    final s = status.toLowerCase();
    if (s.contains('decline') || s.contains('reject')) return 'Return Gatepass';
    if (s == 'slot booked') return 'Check-In';
    if (s == 'arrived at center' || s == 'under inspection') return 'Inspect';
    if (s.contains('approved') ||
        s.contains('ready') ||
        s.contains('farmer accepted')) {
      return 'Pay DBT';
    }
    if (s.contains('completed') || s.contains('paid')) return 'Receipt';
    return 'View';
  }

  Widget _buildDateFilterBar() {
    if (_activeSegment != 0) return const SizedBox.shrink();

    final formattedDate = '${_selectedPendingDate.day}/${_selectedPendingDate.month}/${_selectedPendingDate.year}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                'Date: $formattedDate',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ],
          ),
          TextButton.icon(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _selectedPendingDate,
                firstDate: DateTime(2025),
                lastDate: DateTime(2030),
              );
              if (picked != null) {
                setState(() {
                  _selectedPendingDate = picked;
                });
              }
            },
            icon: const Icon(Icons.edit_calendar, size: 16),
            label: const Text('Change Date', style: TextStyle(fontSize: 12)),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionService.instance.currentUser;
    final officerName = (user?.name != null && user!.name.trim().isNotEmpty)
        ? user.name.trim()
        : 'Officer';
    final centreId = user?.centreId ?? 'CTR-01';
    final currentList = _currentList;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Officer Portal',
            style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: _loadBookings,
          ),
          IconButton(
            icon: const CircleAvatar(
              radius: 14,
              backgroundColor: AppColors.mintGreen,
              child: Icon(Icons.person, size: 18, color: AppColors.primary),
            ),
            tooltip: 'Officer Profile',
            onPressed: _showProfileModal,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadBookings,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 22,
                          backgroundColor: AppColors.mintGreen,
                          child: Icon(Icons.badge,
                              color: AppColors.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                officerName,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Centre: $centreId • ${user?.district ?? "Shivpuri"}',
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const SlotVerificationScreen()),
                          ).then((_) => _loadBookings());
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.qr_code_scanner,
                                    color: Colors.white, size: 22),
                              ),
                              SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Verify Gate Token / QR',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      'Record arrival & gross weighment',
                                      style: TextStyle(
                                          color: Colors.white70, fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios,
                                  color: Colors.white, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 3-Segment Tab Row
                  Row(
                    children: [
                      _actionCard(
                        index: 0,
                        title: 'Pending',
                        subtitle: 'At Gate',
                        count: _pendingList.length,
                        icon: Icons.hourglass_top_rounded,
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(width: 8),
                      _actionCard(
                        index: 1,
                        title: 'Action',
                        subtitle: 'Needs Pay',
                        count: _actionList.length,
                        icon: Icons.assignment_late_outlined,
                        color: Colors.orange.shade800,
                      ),
                      const SizedBox(width: 8),
                      _actionCard(
                        index: 2,
                        title: 'Done',
                        subtitle: 'Settled',
                        count: _doneList.length,
                        icon: Icons.check_circle_outline,
                        color: Colors.green.shade800,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Date Filter Bar (Only visible in Pending tab)
                  _buildDateFilterBar(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          _getFilterTitle(),
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          '${currentList.length} total',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (currentList.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 46, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            _getEmptyTitle(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getEmptyMessage(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: AppColors.textSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  else
                    ...List.generate(currentList.length, (i) {
                      final b = currentList[i];
                      final status = _cleanStatus(b);
                      final displayStatus = _badgeDisplayLabel(status);
                      final farmer =
                          b.farmerName.isNotEmpty ? b.farmerName : 'Farmer';
                      final crop = b.crop.isNotEmpty ? b.crop : 'Wheat';
                      final qty = b.quantityQuintal.toStringAsFixed(1);
                      final slotTime = b.slotTime.isNotEmpty
                          ? b.slotTime
                          : 'Standard Window';

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () => _routeBooking(b),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          b.token,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primary,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: _badgeBg(status),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          displayStatus,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: _badgeText(status),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    farmer,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '$crop • $qty Quintal',
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const Divider(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          slotTime,
                                          style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _actionText(status),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          const Icon(Icons.arrow_forward_ios,
                                              size: 10,
                                              color: AppColors.primary),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _actionCard({
    required int index,
    required String title,
    required String subtitle,
    required int count,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = _activeSegment == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => setState(() => _activeSegment = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color:
                isSelected ? AppColors.mintGreen.withAlpha(50) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon,
                  size: 20, color: isSelected ? AppColors.primary : color),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFilterTitle() {
    if (_activeSegment == 1) return 'Awaiting Payment Approval';
    if (_activeSegment == 2) return 'Settled & Returned Lots';
    return 'Pending Gate Arrivals';
  }

  String _getEmptyTitle() {
    if (_activeSegment == 1) return 'No Action Pending';
    if (_activeSegment == 2) return 'No Settled Slots';
    return 'No Pending Arrivals';
  }

  String _getEmptyMessage() {
    if (_activeSegment == 1) {
      return 'No farmer acceptances or payment authorizations currently pending.';
    }
    if (_activeSegment == 2) {
      return 'Completed payouts and declined/returned lots will appear here.';
    }
    return 'Scheduled slots for this specific date will appear here.';
  }
}