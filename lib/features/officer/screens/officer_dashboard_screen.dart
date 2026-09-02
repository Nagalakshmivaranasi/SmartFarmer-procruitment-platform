import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';
import '../../../services/local_notification_service.dart';
import '../../profile/screens/profile_screen.dart';
import 'slot_verification_screen.dart';

class OfficerDashboardScreen extends StatefulWidget {
  const OfficerDashboardScreen({super.key});

  @override
  State<OfficerDashboardScreen> createState() => _OfficerDashboardScreenState();
}

class _OfficerDashboardScreenState extends State<OfficerDashboardScreen> {
  final _database = IsarDatabaseService();
  int _tabIndex = 0;
  late Future<List<BookingModel>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    final centreId = SessionService.instance.currentUser?.centreId;
    _bookingsFuture = centreId == null
      ? _database.allBookings()
      : _database.bookingsForCentre(centreId);
  }

  List<BookingModel> _filtered(List<BookingModel> bookings, {int? tab}) {
    switch (tab ?? _tabIndex) {
      case 0:
        final now = DateTime.now();
        return bookings.where((booking) => booking.bookingDate.year == now.year && booking.bookingDate.month == now.month && booking.bookingDate.day == now.day).toList();
      case 1:
        return bookings.where((booking) => booking.status == 'Pending').toList();
      case 2:
        return bookings.where((booking) => booking.status == 'Completed').toList();
      case 3:
        return bookings.where((booking) => booking.status == 'Rescheduled').toList();
      default:
        return bookings;
    }
  }

  @override
  Widget build(BuildContext context) {
    final officer = SessionService.instance.currentUser;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Center Officer Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.person_outline), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen(isFarmer: false)))),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<BookingModel>>(
          future: _bookingsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
            if (snapshot.hasError) return Center(child: Text('Unable to load bookings: ${snapshot.error}'));
            final bookings = snapshot.data ?? [];
            final visible = _filtered(bookings);
            return RefreshIndicator(
              onRefresh: () async => setState(_reload),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      officer?.centreId == null ? 'All Procurement Centres' : 'Centre ${officer!.centreId}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(children: [
                    Expanded(child: _metric('Today', _filteredForTab(bookings, 0).length.toString(), Icons.today)),
                    const SizedBox(width: 10),
                    Expanded(child: _metric('Pending', _filteredForTab(bookings, 1).length.toString(), Icons.pending_actions)),
                    const SizedBox(width: 10),
                    Expanded(child: _metric('Done', _filteredForTab(bookings, 2).length.toString(), Icons.task_alt)),
                  ]),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SlotVerificationScreen())),
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan Token'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: ['Today\'s Slots', 'Pending', 'Completed', 'Rescheduled'].asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(label: Text(entry.value), selected: _tabIndex == entry.key, onSelected: (_) => setState(() => _tabIndex = entry.key)),
                    )).toList()),
                  ),
                  const SizedBox(height: 12),
                  if (visible.isEmpty) const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('No bookings in this view.'))),
                  ...visible.map(_bookingTile),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<BookingModel> _filteredForTab(List<BookingModel> bookings, int tab) {
    return _filtered(bookings, tab: tab);
  }

  Widget _metric(String label, String value, IconData icon) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
    child: Column(children: [Icon(icon, color: AppColors.primary), const SizedBox(height: 6), Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))]),
  );

  Widget _bookingTile(BookingModel booking) => Card(
    child: Column(children: [
      ListTile(
        leading: CircleAvatar(child: Text(booking.token.isEmpty ? '-' : booking.token.substring(0, 1))),
        title: Text('${booking.farmerName} • ${booking.crop}'),
        subtitle: Text('${booking.slotTime}\nPayment: ${booking.paymentStatus}'),
        isThreeLine: true,
        trailing: Text(booking.status),
      ),
      if (booking.status != 'Completed')
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () async {
              await LocalNotificationService().notifyDelay(booking);
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delay notification created.')));
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Delay Queue'),
          ),
        ),
    ]),
  );
}
