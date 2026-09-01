import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'reschedule_slot_screen.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('My Bookings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Active Booking Card
            _buildBookingCard(
              context,
              tokenNo: '#42',
              statusText: 'BOOKED',
              statusColor: AppColors.statusGreen,
              crop: 'Wheat',
              quantity: '20 Quintal (2000 Kg)',
              center: 'Shivpuri Procurement Center',
              dateTime: '25 May 2025, 11:00 AM',
              showReschedule: true,
            ),
            const SizedBox(height: 16),

            // Past Booking Card (Example)
            _buildBookingCard(
              context,
              tokenNo: '#18',
              statusText: 'COMPLETED',
              statusColor: AppColors.primary,
              crop: 'Paddy',
              quantity: '15 Quintal (1500 Kg)',
              center: 'Shivpuri Procurement Center',
              dateTime: '10 Nov 2024, 02:00 PM',
              showReschedule: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(
    BuildContext context, {
    required String tokenNo,
    required String statusText,
    required Color statusColor,
    required String crop,
    required String quantity,
    required String center,
    required String dateTime,
    required bool showReschedule,
  }) {
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
                'Token: $tokenNo',
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
                  statusText,
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
          _buildRow('Crop', crop),
          const SizedBox(height: 8),
          _buildRow('Quantity', quantity),
          const SizedBox(height: 8),
          _buildRow('Center', center),
          const SizedBox(height: 8),
          _buildRow('Date & Time', dateTime),
          if (showReschedule) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RescheduleSlotScreen(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Reschedule Slot',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
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