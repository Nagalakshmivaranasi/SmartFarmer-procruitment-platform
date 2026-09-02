import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../../models/booking_model.dart';
import '../../booking/screens/book_slot_step1_crop_screen.dart';
import '../../booking/screens/quality_report_screen.dart';

class LiveQueueScreen extends StatelessWidget {
  const LiveQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmerId = SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Queue Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: farmerId == null
            ? const Center(child: Text('Sign in to view your queue.'))
            : FutureBuilder<List<BookingModel>>(
                future: IsarDatabaseService().farmerBookings(farmerId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final bookings = snapshot.data ?? [];
                  if (bookings.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  final activeBooking = bookings.firstWhere(
                    (b) => b.status != 'Completed',
                    orElse: () => bookings.first,
                  );
                  return _buildQueue(context, activeBooking);
                },
              ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.event_busy, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Active Booking Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'You do not have any active procurement slot bookings. Book a slot first to track live queue status and arrival timelines.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookSlotStep1CropScreen()),
                );
              },
              icon: const Icon(Icons.calendar_month),
              label: const Text('Book Procurement Slot Now'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueue(BuildContext context, BookingModel booking) {
    return FutureBuilder<int>(
      future: IsarDatabaseService().queuePosition(booking),
      builder: (context, posSnapshot) {
        final pos = posSnapshot.data ?? 1;
        final vehiclesAhead = pos > 1 ? pos - 1 : 0;

        final isArrived = booking.status == 'Arrived' || booking.status == 'Under Inspection' || booking.status == 'Deal Offered' || booking.status == 'Completed';
        final isInspected = booking.status == 'Under Inspection' || booking.status == 'Deal Offered' || booking.status == 'Completed';
        final isCompleted = booking.status == 'Completed';

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Active Token Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'YOUR TOKEN NUMBER',
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1.2,
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '#${booking.token}',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking.centreName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Queue Dynamics Summary
              Row(
                children: [
                  Expanded(
                    child: _buildQueueStatTile(
                      label: 'Vehicles Ahead',
                      value: '$vehiclesAhead',
                      icon: Icons.directions_bus_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildQueueStatTile(
                      label: 'Slot Time',
                      value: booking.slotTime,
                      icon: Icons.timer_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Process Stepper Status
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
                      'Center Progress Flow',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStepRow('Gate Verification', isArrived ? 'Completed' : 'Pending', isArrived, false),
                    _buildStepRow('Moisture & Quality Sampling', isInspected ? 'Completed' : (isArrived ? 'In Progress' : 'Pending'), isInspected, false),
                    _buildStepRow('Weighbridge Entry & Deal Lock', booking.status == 'Deal Offered' ? 'Deal Offered' : (isCompleted ? 'Completed' : 'Pending'), booking.status == 'Deal Offered' || isCompleted, false),
                    _buildStepRow('Unloading & Receipt', isCompleted ? 'Completed' : 'Pending', isCompleted, true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QualityReportScreen(),
                    ),
                  );
                },
                child: const Text('View Quality Report'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQueueStatTile({
    required String label,
    required String value,
    required IconData icon,
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
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepRow(String title, String subtitle, bool isDone, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              isDone ? Icons.check_circle : Icons.radio_button_unchecked,
              size: 20,
              color: isDone ? AppColors.primary : AppColors.textSecondary,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 30,
                color: isDone ? AppColors.primary : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDone ? AppColors.textPrimary : AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ],
    );
  }
}