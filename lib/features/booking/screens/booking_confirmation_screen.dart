
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../models/centre_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/local_notification_service.dart';
import '../../../services/session_service.dart';
import '../../farmer_home/screens/booking_confirmed_screen.dart';
class BookingConfirmationScreen extends StatefulWidget {
  final String crop;
  final double quantityQuintal;
  final String state;
  final String district;
  final CentreModel centre;
  final DateTime date;
  final String slotTime;

  const BookingConfirmationScreen({
    super.key,
    required this.crop,
    required this.quantityQuintal,
    required this.state,
    required this.district,
    required this.centre,
    required this.date,
    required this.slotTime,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  final _database = IsarDatabaseService();
  bool _isSaving = false;

  Future<void> _sendBookingSms(BookingModel booking, String phone) async {
    final message = 'Dear ${booking.farmerName}, your slot for ${booking.crop} (${booking.quantityQuintal} Qtl) on ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} at ${booking.slotTime} at ${booking.centreName} is CONFIRMED. Token #${booking.token}. - KisanSetu Platform';
    
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
      // Fallback handled gracefully
    }
  }

  Future<void> _confirmBooking() async {
    setState(() => _isSaving = true);

    final currentUser = SessionService.instance.currentUser;
    final farmerId = currentUser?.farmerId ?? currentUser?.uid ?? 'FMR_GUEST';
    final farmerName = currentUser?.name ?? 'Farmer';
    final farmerPhone = currentUser?.phoneNumber ?? await _database.findPhoneNumber(farmerId) ?? '9876543210';

    final token = await _database.generateNextSequentialToken(
      centreId: widget.centre.centreId,
      date: widget.date,
    );

    final booking = BookingModel(
      bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      farmerId: farmerId,
      farmerName: farmerName,
      centreId: widget.centre.centreId,
      centreName: widget.centre.centreName,
      crop: widget.crop,
      quantityQuintal: widget.quantityQuintal,
      bookingDate: DateTime(widget.date.year, widget.date.month, widget.date.day),
      slotTime: widget.slotTime,
      token: token,
      status: 'Booked',
      paymentStatus: 'Pending',
      createdAt: DateTime.now(),
    );

    await _database.saveBooking(booking);
    await LocalNotificationService().notifyBookingSuccess(booking);
    await _sendBookingSms(booking, farmerPhone);

    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmedScreen(booking: booking),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Confirm Booking (Step 6 of 6)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTracker(currentStep: 6),
              const SizedBox(height: 24),

              const Text(
                'Review Booking Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Crop', widget.crop),
                    const Divider(height: 20),
                    _buildSummaryRow('Quantity', '${widget.quantityQuintal} Quintal'),
                    const Divider(height: 20),
                    _buildSummaryRow('State', widget.state),
                    const Divider(height: 20),
                    _buildSummaryRow('District', widget.district),
                    const Divider(height: 20),
                    _buildSummaryRow('Procurement Center', widget.centre.centreName),
                    const Divider(height: 20),
                    _buildSummaryRow('Date', '${widget.date.day}/${widget.date.month}/${widget.date.year}'),
                    const Divider(height: 20),
                    _buildSummaryRow('Time Slot', widget.slotTime),
                  ],
                ),
              ),
              const Spacer(),

              ElevatedButton(
                onPressed: _isSaving ? null : _confirmBooking,
                child: _isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Confirm & Book Slot'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepTracker({required int currentStep}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final stepNum = index + 1;
        final isActive = stepNum == currentStep;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$stepNum',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}
