import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../models/core_models.dart';
import 'farmer_home_dashboard.dart';

class BookingConfirmedScreen extends StatelessWidget {
  final dynamic booking;

  const BookingConfirmedScreen({super.key, this.booking});

  @override
  Widget build(BuildContext context) {
    String token = '#42';
    String crop = 'Wheat';
    String qty = '20 Quintal';
    String center = 'Shivpuri Procurement Center';
    String time = '11:00 AM - 12:00 PM';

    if (booking != null) {
      if (booking is SlotBooking) {
        final b = booking as SlotBooking;
        token = b.tokenNumber;
        crop = b.cropName;
        qty = '${b.estimatedQuantityQuintal} Quintal';
        center = b.centerName;
        time = b.timeSlot;
      } else if (booking is BookingModel) {
        final b = booking as BookingModel;
        token = b.token;
        crop = b.crop;
        qty = '${b.quantityQuintal} Quintal';
        center = b.centreName;
        time = b.slotTime;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: AppColors.mintGreen,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 16),
              const Text(
                'Your slot has been\nsuccessfully booked!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.background,
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _itemRow('Token Number', token, isHighlight: true),
                    _itemRow('Crop', crop),
                    _itemRow('Quantity', qty),
                    _itemRow('Center', center),
                    _itemRow('Time', time),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const FarmerHomeDashboard()),
                    (route) => false,
                  );
                },
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemRow(String label, String val, {bool isHighlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isHighlight ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}