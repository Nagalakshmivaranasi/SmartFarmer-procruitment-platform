import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../models/notification.dart';
class FarmerInspectionApprovalScreen extends StatefulWidget {
  final BookingModel booking;

  const FarmerInspectionApprovalScreen({super.key, required this.booking});

  @override
  State<FarmerInspectionApprovalScreen> createState() =>
      _FarmerInspectionApprovalScreenState();
}

class _FarmerInspectionApprovalScreenState
    extends State<FarmerInspectionApprovalScreen> {
  final _database = IsarDatabaseService();
  bool _isProcessing = false;
Future<void> _handleDecision(bool accepted) async {
    setState(() => _isProcessing = true);
    final b = widget.booking;

    if (accepted) {
      // 1. Resolve rate & quantity
      final double baseRate =
          (b.baseMspRate != null && b.baseMspRate! > 0) ? b.baseMspRate! : 2275.0;
      final double deductionPct = b.deductionPercentage ?? 0.0;
      final double finalRate = (b.finalRatePerQuintal != null && b.finalRatePerQuintal! > 0)
          ? b.finalRatePerQuintal!
          : (baseRate * (1.0 - (deductionPct / 100.0)));
      final double qty = b.quantityQuintal > 0 ? b.quantityQuintal : 20.0;

      // 2. Compute definitive net payout
      final double netTotal = (b.netPayableAmount != null && b.netPayableAmount! > 0)
          ? b.netPayableAmount!
          : (qty * finalRate);

      // 3. Persist exact financial values
      b.baseMspRate = baseRate;
      b.finalRatePerQuintal = finalRate;
      b.quantityQuintal = qty;
      b.netPayableAmount = netTotal;
      b.status = 'Procurement Completed';
      b.paymentStatus = 'Payment Successful (DBT Paid)';

      // 4. Save to Isar database
      await _database.saveBooking(b);

      // 5. Send notification matching NotificationModel constructor
      try {
        final notification = NotificationModel(
          userId: b.farmerId,
          title: 'DBT Payment Dispatched! ₹${netTotal.toStringAsFixed(2)}',
          body:
              'Payment of ₹${netTotal.toStringAsFixed(2)} for Token ${b.token} has been successfully settled via DBT to your bank account.',
          type: 'payment_success',
          createdAt: DateTime.now(),
        );

        await _database.saveNotification(notification);
      } catch (e) {
        debugPrint('Notification save warning: $e');
      }
    } else {
      b.status = 'Deal Declined by Farmer';
      b.paymentStatus = 'Cancelled by Farmer';
      await _database.saveBooking(b);
    }

    setState(() => _isProcessing = false);

    if (!mounted) return;

    if (accepted) {
      _showPaymentSuccessDialog(context, b);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Offer declined. Produce lot marked for gate return.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pop(context);
    }
  }

  void _showPaymentSuccessDialog(BuildContext context, BookingModel b) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 54),
            SizedBox(height: 12),
            Text('Payment Initiated & Successful',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Direct Benefit Transfer (DBT) has been credited for Token ${b.token}.'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Amount Paid:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '₹ ${(b.netPayableAmount ?? 0).toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // dismiss dialog
              Navigator.pop(context); // back to dashboard
            },
            child: const Text('Back to Home'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;

    final double baseRate = b.baseMspRate ?? 2425.0;
    final double deductionPct = b.deductionPercentage ?? 0.0;
    final double finalRate = b.finalRatePerQuintal ?? (baseRate * (1 - deductionPct / 100));
    final double totalDeductionPerQtl = baseRate - finalRate;
    final double netTotal = b.netPayableAmount ?? (b.quantityQuintal * finalRate);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Review Procurement Offer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notice Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.orange.shade900),
                      const SizedBox(width: 8),
                      Text(
                        'Conditional Acceptance Offer',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange.shade900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    b.rejectionReason ??
                        'Parameters exceeded standard FAQ limits. Review the value deductions below before deciding.',
                    style: const TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Measured Parameters Card
            const Text(
              'Lab Quality Readings',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    _metricRow('Moisture Content', '${b.moistureLevel?.toStringAsFixed(1) ?? "--"}%', 'Max FAQ: 12.0%'),
                    const Divider(),
                    _metricRow('Foreign Matter', '${b.foreignMatterLevel?.toStringAsFixed(1) ?? "--"}%', 'Max FAQ: 0.75%'),
                    const Divider(),
                    _metricRow('Damaged / Discolored', '${b.damagedGrainsLevel?.toStringAsFixed(1) ?? "--"}%', 'Max FAQ: 2.0%'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Detailed Price Breakdown
            const Text(
              'Price & Payment Breakdown',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _costRow('Base MSP Rate', '₹ ${baseRate.toStringAsFixed(2)} / Qtl'),
                    _costRow(
                      'Quality Cut (${deductionPct.toStringAsFixed(1)}%)',
                      '- ₹ ${totalDeductionPerQtl.toStringAsFixed(2)} / Qtl',
                      textColor: Colors.red.shade700,
                    ),
                    const Divider(),
                    _costRow(
                      'Adjusted Rate',
                      '₹ ${finalRate.toStringAsFixed(2)} / Qtl',
                      isBold: true,
                    ),
                    _costRow('Accepted Net Quantity', '${b.quantityQuintal.toStringAsFixed(2)} Quintal'),
                    const Divider(thickness: 1.2),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Net Payable',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹ ${netTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Decision Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isProcessing ? null : () => _handleDecision(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red.shade700,
                      side: BorderSide(color: Colors.red.shade400),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Decline (Return Produce)'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isProcessing ? null : () => _handleDecision(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Accept Offer'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _costRow(String label, String value, {bool isBold = false, Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.textSecondary, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: textColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricRow(String parameter, String measured, String limit) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(parameter, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(limit, style: const TextStyle(fontSize: 11, color: AppColors.textMuted)),
            ],
          ),
          Text(
            measured,
            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.brown),
          ),
        ],
      ),
    );
  }
}