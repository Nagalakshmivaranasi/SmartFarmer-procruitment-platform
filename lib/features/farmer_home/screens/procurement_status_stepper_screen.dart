import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/core_models.dart';

class ProcurementStatusStepperScreen extends StatelessWidget {
  final SlotBooking booking;
  const ProcurementStatusStepperScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final stages = [
      {'title': 'Slot Booked', 'status': BookingStatus.slotBooked},
      {'title': 'Arrived at Center', 'status': BookingStatus.arrivedAtCenter},
      {'title': 'Under Inspection', 'status': BookingStatus.underInspection},
      {'title': 'Quality Check & Weighing', 'status': BookingStatus.qualityCheckDone},
      {'title': 'Report Generated', 'status': BookingStatus.reportGenerated},
      {'title': 'Deal Offered', 'status': BookingStatus.dealOffered},
      {'title': 'Payment Processing', 'status': BookingStatus.paymentProcessing},
      {'title': 'Payment Completed', 'status': BookingStatus.paymentCompleted},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Status: Token ${booking.tokenNumber}')),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: stages.length,
        itemBuilder: (ctx, i) {
          final stage = stages[i];
          final stageStatus = stage['status'] as BookingStatus;
          final isCompleted = booking.status.index >= stageStatus.index;
          final isCurrent = booking.status == stageStatus;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isCompleted ? AppColors.primary : AppColors.divider,
                    child: Icon(
                      isCompleted ? Icons.check : Icons.circle,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                  if (i < stages.length - 1)
                    Container(
                      width: 2,
                      height: 40,
                      color: isCompleted ? AppColors.primary : AppColors.divider,
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage['title'] as String,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isCurrent || isCompleted ? FontWeight.bold : FontWeight.normal,
                      color: isCurrent
                          ? AppColors.primary
                          : (isCompleted ? AppColors.textPrimary : AppColors.textMuted),
                    ),
                  ),
                  Text(
                    isCompleted ? 'Completed' : 'Pending',
                    style: TextStyle(
                      fontSize: 12,
                      color: isCompleted ? AppColors.statusSuccess : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}