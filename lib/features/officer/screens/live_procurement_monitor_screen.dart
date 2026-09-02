import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LiveProcurementMonitorScreen extends StatelessWidget {
  const LiveProcurementMonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Live Procurement Queue'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildQueueCard(
              token: '#42',
              farmerName: 'Farmer',
              crop: 'Wheat (20 Qtl)',
              status: 'Inspected',
              statusColor: AppColors.statusGreen,
              time: '11:00 AM Slot',
            ),
            const SizedBox(height: 10),
            _buildQueueCard(
              token: '#43',
              farmerName: 'Suresh Patel',
              crop: 'Wheat (35 Qtl)',
              status: 'Under Weighment',
              statusColor: Colors.orange.shade800,
              time: '11:15 AM Slot',
            ),
            const SizedBox(height: 10),
            _buildQueueCard(
              token: '#44',
              farmerName: 'Mahendra Singh',
              crop: 'Mustard (15 Qtl)',
              status: 'In Gate Entry',
              statusColor: Colors.blue.shade700,
              time: '11:30 AM Slot',
            ),
            const SizedBox(height: 10),
            _buildQueueCard(
              token: '#45',
              farmerName: 'Vikram Sharma',
              crop: 'Wheat (50 Qtl)',
              status: 'Waiting',
              statusColor: AppColors.textSecondary,
              time: '11:45 AM Slot',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQueueCard({
    required String token,
    required String farmerName,
    required String crop,
    required String status,
    required Color statusColor,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              token,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  farmerName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$crop • $time',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}