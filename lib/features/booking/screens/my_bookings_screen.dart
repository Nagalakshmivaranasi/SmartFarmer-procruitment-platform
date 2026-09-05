import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import 'booking_details_screen.dart';
import 'reschedule_booking_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final _database = IsarDatabaseService();

  @override
  Widget build(BuildContext context) {
    final farmerId = SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: farmerId == null
          ? const Center(child: Text('Sign in to view bookings.'))
          : FutureBuilder<List<BookingModel>>(
              future: _database.farmerBookings(farmerId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final bookings = snapshot.data ?? [];
                if (bookings.isEmpty) {
                  return const Center(
                    child: Text('No Procurement Bookings Found'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: bookings.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return _buildBookingCard(context, booking);
                  },
                );
              },
            ),
    );
  }

  Widget _buildBookingCard(BuildContext context, BookingModel booking) {
    final canReschedule = _slotDateTime(booking).difference(DateTime.now()).inHours >= 24 && booking.status != 'Completed';
    Color statusColor = AppColors.statusGreen;
    if (booking.status == 'Completed') {
      statusColor = AppColors.primary;
    } else if (booking.status == 'Rescheduled') {
      statusColor = AppColors.statusOrange;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Token: #${booking.token}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  booking.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          _buildRow('Crop', booking.crop),
          const SizedBox(height: 8),
          _buildRow('Quantity', '${booking.quantityQuintal} Quintal'),
          const SizedBox(height: 8),
          _buildRow('Center', booking.centreName),
          const SizedBox(height: 8),
          _buildRow('Date & Time', '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}, ${booking.slotTime}'),
          const SizedBox(height: 8),
          _buildRow('Payment Status', booking.paymentStatus),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailsScreen(booking: booking),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: const Text('View Details / QR Code'),
                ),
              ),
              if (booking.status != 'Completed') ...[
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: canReschedule
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RescheduleBookingScreen(booking: booking),
                              ),
                            ).then((_) => setState(() {}));
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canReschedule ? AppColors.primary : Colors.grey,
                    ),
                    child: Text(canReschedule ? 'Reschedule' : 'Non-Reschedulable'),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  DateTime _slotDateTime(BookingModel booking) {
    final time = booking.slotTime.split(' - ').first;
    final parsed = RegExp(r'^(\d{2}):(\d{2}) (AM|PM)$').firstMatch(time);
    if (parsed == null) return booking.bookingDate;
    var hour = int.parse(parsed.group(1)!);
    final minute = int.parse(parsed.group(2)!);
    if (parsed.group(3) == 'PM' && hour != 12) hour += 12;
    if (parsed.group(3) == 'AM' && hour == 12) hour = 0;
    return DateTime(booking.bookingDate.year, booking.bookingDate.month, booking.bookingDate.day, hour, minute);
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
