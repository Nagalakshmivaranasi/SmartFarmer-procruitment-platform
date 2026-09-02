import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import 'farmer_bookings_screen.dart';
import '../../farmer_home/screens/farmer_home_screen.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final BookingModel? booking;

  const BookingConfirmedScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon Circle
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Your slot has been\nsuccessfully booked!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 32),

              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow('Token Number', '#${booking?.token ?? 'N/A'}', isBold: true),
                    const Divider(height: 20),
                    _buildSummaryRow('Crop', booking?.crop ?? 'N/A'),
                    const SizedBox(height: 10),
                    _buildSummaryRow('Quantity', '${booking?.quantityQuintal ?? 0} Quintal'),
                    const SizedBox(height: 10),
                    _buildSummaryRow('Center', booking?.centreName ?? 'N/A'),
                    const SizedBox(height: 10),
                    _buildSummaryRow(
                      'Date & Time',
                      booking == null
                          ? 'N/A'
                          : '${booking!.bookingDate.day}/${booking!.bookingDate.month}/${booking!.bookingDate.year}, ${booking!.slotTime}',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FarmerBookingsScreen(
                        uid: booking?.farmerId ?? '',
                      ),
                    ),
                  );
                },
                child: const Text('View My Booking'),
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const FarmerHomeScreen()),
                    (route) => false,
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Go to Home',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}