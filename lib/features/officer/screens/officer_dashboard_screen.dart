import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
        return bookings.where((booking) => booking.status == 'Pending' || booking.status == 'Booked').toList();
      case 2:
        return bookings.where((booking) => booking.status == 'Completed').toList();
      case 3:
        return bookings.where((booking) => booking.status == 'Rescheduled').toList();
      default:
        return bookings;
    }
  }

  Future<void> _sendSmsNotification(BookingModel booking) async {
    final phone = await _database.findPhoneNumber(booking.farmerId) ?? '9876543210';
    final message = 'Dear ${booking.farmerName}, your slot #${booking.token} at ${booking.centreName} has been updated. Please check KisanSetu app for queue updates.';
    
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phone,
      queryParameters: <String, String>{'body': message},
    );

    try {
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      } else {
        final fallbackUri = Uri.parse('sms:$phone?body=${Uri.encodeComponent(message)}');
        await launchUrl(fallbackUri);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification pre-filled for $phone: $message')),
      );
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, Officer ${officer?.name ?? 'Rajesh'}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          officer?.centreId == null ? 'All Procurement Centres' : 'Centre: ${officer!.centreId}',
                          style: const TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                      ],
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
                      label: const Text('Scan Token QR Code'),
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
    margin: const EdgeInsets.only(bottom: 12),
    child: Column(children: [
      ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          child: Text('#${booking.token}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
        title: Text('${booking.farmerName} • ${booking.crop} (${booking.quantityQuintal} Qtl)'),
        subtitle: Text('Date: ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} • ${booking.slotTime}\nPayment: ${booking.paymentStatus}'),
        isThreeLine: true,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
          child: Text(booking.status, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary)),
        ),
      ),
      if (booking.status != 'Completed')
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () async {
                  await LocalNotificationService().notifyDelay(booking);
                  await _sendSmsNotification(booking);
                },
                icon: const Icon(Icons.sms_outlined, size: 18),
                label: const Text('Send SMS Delay Alert'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => SlotVerificationScreen()));
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 36), padding: const EdgeInsets.symmetric(horizontal: 12)),
                icon: const Icon(Icons.verified, size: 16),
                label: const Text('Process', style: TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ),
    ]),
  );
}

