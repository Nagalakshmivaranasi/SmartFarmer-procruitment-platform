import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../queue/screens/live_queue_screen.dart';
import 'book_slot_step1_crop_screen.dart';

class ProcurementStatusScreen extends StatelessWidget {
  const ProcurementStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final farmerId = SessionService.instance.currentUser?.farmerId ?? SessionService.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Procurement Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: farmerId == null
            ? const Center(child: Text('Sign in to view status.'))
            : FutureBuilder<List<BookingModel>>(
                future: IsarDatabaseService().farmerBookings(farmerId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final activeBookings = (snapshot.data ?? [])
                      .where((b) => b.status != 'Completed')
                      .toList();

                  if (activeBookings.isEmpty) {
                    return _buildEmptyState(context);
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: activeBookings.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 24),
                    itemBuilder: (context, index) {
                      return _buildStatusContent(context, activeBookings[index]);
                    },
                  );
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
              child: const Icon(Icons.track_changes, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Procurement Booking Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Book a slot to track live procurement progress from gate entry to payment completion.',
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
              label: const Text('Book Procurement Slot'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusContent(BuildContext context, BookingModel booking) {
    final status = booking.status;
    final paymentStatus = booking.paymentStatus;

    final isBooked = true;
    final isArrived = status == 'Arrived' || status == 'Under Inspection' || status == 'Deal Offered' || status == 'Completed';
    final isInspected = status == 'Under Inspection' || status == 'Deal Offered' || status == 'Completed';
    final isReportGenerated = status == 'Deal Offered' || status == 'Completed';
    final isDealOffered = status == 'Deal Offered' || status == 'Completed';
    final isPaymentProcessing = paymentStatus == 'Paid' || status == 'Completed';
    final isPaymentCompleted = paymentStatus == 'Paid' && status == 'Completed';

    return Column(
      children: [
          // Header Token Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Token #${booking.token}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${booking.crop} • ${booking.quantityQuintal} Quintal',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LiveQueueScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(0, 36),
                  ),
                  icon: const Icon(Icons.line_style, size: 16),
                  label: const Text(
                    'Live Queue',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Timeline Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _buildTimelineStep(
                  title: 'Slot Booked',
                  subtitle: '${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}, ${booking.slotTime}',
                  isDone: isBooked,
                  isCurrent: !isArrived,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Arrived at Center',
                  subtitle: isArrived ? 'Arrived at gate' : 'Pending arrival',
                  isDone: isArrived,
                  isCurrent: isArrived && !isInspected,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Under Inspection',
                  subtitle: isInspected ? 'Inspection completed' : (isArrived ? 'In Progress' : 'Pending'),
                  isDone: isInspected,
                  isCurrent: isArrived && !isInspected,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Quality Check & Sampling',
                  subtitle: isInspected ? 'Lab parameters verified' : 'Pending',
                  isDone: isInspected,
                  isCurrent: isInspected && !isReportGenerated,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Report Generated',
                  subtitle: isReportGenerated ? 'Grade & MSP calculated' : 'Pending',
                  isDone: isReportGenerated,
                  isCurrent: isReportGenerated && !isDealOffered,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Deal Offered',
                  subtitle: isDealOffered ? 'Final MSP offer ready' : 'Pending',
                  isDone: isDealOffered,
                  isCurrent: isDealOffered && !isPaymentProcessing,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Payment Processing',
                  subtitle: isPaymentProcessing ? 'Transaction initiated' : 'Pending',
                  isDone: isPaymentProcessing,
                  isCurrent: isPaymentProcessing && !isPaymentCompleted,
                  isLast: false,
                ),
                _buildTimelineStep(
                  title: 'Payment Completed',
                  subtitle: isPaymentCompleted ? 'Settled to Bank' : 'Pending',
                  isDone: isPaymentCompleted,
                  isCurrent: isPaymentCompleted,
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isDone,
    required bool isCurrent,
    required bool isLast,
  }) {
    Color stepColor = isDone
        ? AppColors.primary
        : (isCurrent ? AppColors.statusOrange : Colors.grey.shade300);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: stepColor,
                  shape: BoxShape.circle,
                  border: isCurrent
                      ? Border.all(color: AppColors.primary, width: 3)
                      : null,
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? AppColors.primary : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight:
                          isCurrent || isDone ? FontWeight.bold : FontWeight.w500,
                      color: isDone || isCurrent
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isCurrent
                          ? AppColors.statusOrange
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}