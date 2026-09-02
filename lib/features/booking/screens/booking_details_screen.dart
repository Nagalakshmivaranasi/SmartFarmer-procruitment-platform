import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import 'reschedule_booking_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  final BookingModel booking;

  const BookingDetailsScreen({super.key, required this.booking});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final canReschedule = _slotDateTime().difference(DateTime.now()).inHours >= 24;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Booking Details')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: QrImageView(data: widget.booking.token, size: 210, backgroundColor: Colors.white),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text('Token #${widget.booking.token}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ),
          const SizedBox(height: 24),
          _detail('Crop', widget.booking.crop),
          _detail('Quantity', '${widget.booking.quantityQuintal} Quintal'),
          _detail('Centre', widget.booking.centreName),
          _detail('Date', '${widget.booking.bookingDate.day}/${widget.booking.bookingDate.month}/${widget.booking.bookingDate.year}'),
          _detail('Time', widget.booking.slotTime),
          _detail('Status', widget.booking.status),
          _detail('Payment', widget.booking.paymentStatus),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: canReschedule
                ? () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RescheduleBookingScreen(booking: widget.booking)),
                    );
                    if (mounted) setState(() {});
                  }
                : null,
            child: Text(canReschedule ? 'Reschedule' : 'Rescheduling closes 24 hours before the slot'),
          ),
        ],
      ),
    );
  }

  DateTime _slotDateTime() {
    final time = widget.booking.slotTime.split(' - ').first;
    final parsed = RegExp(r'^(\d{2}):(\d{2}) (AM|PM)$').firstMatch(time);
    if (parsed == null) return widget.booking.bookingDate;
    var hour = int.parse(parsed.group(1)!);
    final minute = int.parse(parsed.group(2)!);
    if (parsed.group(3) == 'PM' && hour != 12) hour += 12;
    if (parsed.group(3) == 'AM' && hour == 12) hour = 0;
    return DateTime(widget.booking.bookingDate.year, widget.booking.bookingDate.month, widget.booking.bookingDate.day, hour, minute);
  }

  Widget _detail(String label, String value) => ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        subtitle: Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600)),
      );
}
