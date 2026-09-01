import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'todays_slots_screen.dart';

class ProcurementStatusScreen extends StatelessWidget {
  const ProcurementStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Procurement Status'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                    children: const [
                      Text(
                        'Token #42',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Wheat • 20 Quintal',
                        style: TextStyle(
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
                          builder: (context) => const TodaysSlotsScreen(),
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
                    subtitle: '25 May 2025, 10:15 AM',
                    isDone: true,
                    isCurrent: false,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Arrived at Center',
                    subtitle: '25 May 2025, 11:05 AM',
                    isDone: true,
                    isCurrent: false,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Under Inspection',
                    subtitle: 'In Progress',
                    isDone: false,
                    isCurrent: true,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Quality Check',
                    subtitle: 'Pending',
                    isDone: false,
                    isCurrent: false,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Report Generated',
                    subtitle: 'Pending',
                    isDone: false,
                    isCurrent: false,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Deal Offered',
                    subtitle: 'Pending',
                    isDone: false,
                    isCurrent: false,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Payment Processing',
                    subtitle: 'Pending',
                    isDone: false,
                    isCurrent: false,
                    isLast: false,
                  ),
                  _buildTimelineStep(
                    title: 'Payment Completed',
                    subtitle: 'Pending',
                    isDone: false,
                    isCurrent: false,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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