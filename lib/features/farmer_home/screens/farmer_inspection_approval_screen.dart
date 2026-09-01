import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../booking/screens/deal_lock_screen.dart';
import '../../officer/models/inspection_result.dart';

class FarmerInspectionApprovalScreen extends StatelessWidget {
  final InspectionResult result;

  const FarmerInspectionApprovalScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Review Quality Report')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Decision Banner
              _buildHeaderBanner(),
              const SizedBox(height: 16),

              // Lab Analysis Summary
              const Text(
                'Lab Analysis Results',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Card(
                child: Column(
                  children: [
                    _buildMetricRow('Moisture Level', '${result.moisturePercentage}%', result.moisturePercentage <= 12.0),
                    const Divider(height: 1),
                    _buildMetricRow('Foreign Matter', '${result.foreignMatterPercentage}%', result.foreignMatterPercentage <= 2.0),
                    const Divider(height: 1),
                    _buildMetricRow('Damaged Grains', '${result.damagedPercentage}%', result.damagedPercentage <= 3.0),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Payout Breakdown
              if (result.status != InspectionStatus.rejected) ...[
                const Text(
                  'Pricing & Payout Offer',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Offered Quantity:'),
                            Text('${result.totalQuantityQuintals} Quintals'),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Final Rate Per Quintal:'),
                            Text('₹${result.finalPricePerQuintal.toStringAsFixed(2)}'),
                          ],
                        ),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Estimated Payout:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(
                              '₹${result.totalPayout.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Acceptance & Dispute Action Controls
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBanner() {
    String title;
    String desc;
    Color color;

    switch (result.status) {
      case InspectionStatus.fullyAccepted:
        title = 'Quality Approved (Full MSP)';
        desc = 'Your crop batch meets all MSP procurement standards.';
        color = Colors.green;
        break;
      case InspectionStatus.partiallyAccepted:
        title = 'Partially Accepted (Deduction Applied)';
        desc = 'Moisture or foreign matter exceeds optimal levels. A quality deduction has been applied.';
        color = Colors.orange.shade800;
        break;
      case InspectionStatus.rejected:
        title = 'Batch Rejected';
        desc = 'Quality parameters exceed acceptable safety limits for government procurement.';
        color = Colors.red;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, bool isGood) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Row(
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(width: 6),
              Icon(
                isGood ? Icons.check_circle : Icons.warning,
                size: 16,
                color: isGood ? Colors.green : Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    if (result.status == InspectionStatus.rejected) {
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Re-testing request sent to Center Supervisor.')),
                );
              },
              child: const Text('Request Re-Testing / Appeal Decision'),
            ),
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Dispute logged. A senior inspector will re-check.')),
              );
            },
            child: const Text('Dispute Grade'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DealLockScreen(),
                ),
              );
            },
            child: const Text('Accept & Lock Deal'),
          ),
        ),
      ],
    );
  }
}