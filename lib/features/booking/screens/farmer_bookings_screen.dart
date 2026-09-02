import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';
import 'booking_details_screen.dart';

class FarmerBookingsScreen extends StatelessWidget {
  final String uid;

  const FarmerBookingsScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    final farmerId = SessionService.instance.currentUser?.farmerId ?? uid;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('My Procurement Bookings'), centerTitle: true),
      body: FutureBuilder<List<BookingModel>>(
        future: IsarDatabaseService().farmerBookings(farmerId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Unable to load bookings: ${snapshot.error}'));
          final bookings = snapshot.data ?? [];
          if (bookings.isEmpty) {
            return const Center(child: Text('No Procurement Bookings Found'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) => _bookingCard(context, bookings[index]),
          );
        },
      ),
    );
  }

  Widget _bookingCard(BuildContext context, BookingModel booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingDetailsScreen(booking: booking))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Token #${booking.token}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(booking.status.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ]),
            const Divider(),
            Text(booking.crop, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            Text(booking.centreName),
            Text('${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} • ${booking.slotTime}'),
            Text('Payment: ${booking.paymentStatus}', style: const TextStyle(color: AppColors.textSecondary)),
          ]),
        ),
      ),
    );
  }
}
