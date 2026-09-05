import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import 'deal_lock_screen.dart';

class QualityReportScreen extends StatelessWidget {
  final BookingModel? booking;

  const QualityReportScreen({super.key, this.booking});

  BookingModel _resolveBooking() {
    return booking ??
        BookingModel(
          bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
          farmerId: 'KS10245',
          farmerName: 'Ramesh Kumar',
          centreId: 'CTR-01',
          centreName: 'Shivpuri Procurement Center',
          crop: 'Wheat',
          quantityQuintal: 20.0,
          bookingDate: DateTime.now(),
          slotTime: '11:00 AM - 11:30 AM',
          token: '#42',
          status: 'Inspected',
          createdAt: DateTime.now(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final activeBooking = _resolveBooking();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quality Report'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quality Summary Card
            Container(
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
                        'Token ${activeBooking.token}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Grade: Good (A)',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${activeBooking.crop} • ${activeBooking.quantityQuintal} Quintal',
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Measured Parameters Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Inspection Parameters (3/3)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Divider(height: 24, color: AppColors.border),
                  _parameterRow('Moisture Content', '11.2 %', true),
                  _parameterRow('Foreign Matter %', '1.5 %', true),
                  _parameterRow('Other Food Grains %', '1.0 %', true),
                  _parameterRow('Damaged / Discolored Grains %', '2.5 %', true),
                  _parameterRow('Immature Grains %', '1.2 %', true),
                  _parameterRow('Weevilled Grains %', '0.8 %', true),
                  _parameterRow('Mixture of Low Quality Varieties %', '0.5 %', true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Generate Deal Action Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DealLockScreen(booking: activeBooking),
                  ),
                );
              },
              child: const Text('Generate Deal Offer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _parameterRow(String label, String value, bool isPassed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                isPassed ? Icons.check_circle : Icons.error,
                size: 16,
                color: isPassed ? AppColors.primary : Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}