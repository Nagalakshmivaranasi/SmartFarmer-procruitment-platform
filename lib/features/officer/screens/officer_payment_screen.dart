import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/notification_service.dart';
import 'payment_success_screen.dart';

class OfficerPaymentScreen extends StatefulWidget {
  final BookingModel booking;

  const OfficerPaymentScreen({super.key, required this.booking});

  @override
  State<OfficerPaymentScreen> createState() => _OfficerPaymentScreenState();
}

class _OfficerPaymentScreenState extends State<OfficerPaymentScreen> {
  final _database = IsarDatabaseService();
  bool _isProcessing = false;

double _computePayableAmount(BookingModel b) {
    // 1. If an explicit netPayableAmount > 0 is already stored, use it
    if ((b.netPayableAmount ?? 0.0) > 0.0) {
      return b.netPayableAmount!;
    }

    // 2. Resolve rate per quintal (eval rate -> base rate -> MSP baseline 2275.0)
    double rate = 2275.0;
    if ((b.finalRatePerQuintal ?? 0.0) > 0.0) {
      rate = b.finalRatePerQuintal!;
    } else if ((b.baseMspRate ?? 0.0) > 0.0) {
      rate = b.baseMspRate!;
    }

    // 3. Resolve quantity (must be strictly > 0)
    double qty = b.quantityQuintal;
    if (qty <= 0.0) {
      // Fallback if quantity wasn't persisted or was zeroed out
      qty = 20.0; // Default lot size
    }

    return rate * qty;
  }

  Future<void> _executePayment() async {
    setState(() => _isProcessing = true);

    try {
      final b = widget.booking;

      final double rate = (b.finalRatePerQuintal != null && b.finalRatePerQuintal! > 0)
          ? b.finalRatePerQuintal!
          : ((b.baseMspRate != null && b.baseMspRate! > 0) ? b.baseMspRate! : 2275.0);

      final double qty = b.quantityQuintal > 0 ? b.quantityQuintal : 20.0;

      final double calculatedAmount = (b.netPayableAmount != null && b.netPayableAmount! > 0)
          ? b.netPayableAmount!
          : (rate * qty);

      // Force-write all values into the booking record
      b.quantityQuintal = qty;
      b.baseMspRate = (b.baseMspRate != null && b.baseMspRate! > 0) ? b.baseMspRate : 2275.0;
      b.finalRatePerQuintal = rate;
      b.netPayableAmount = calculatedAmount;
      b.status = 'Completed';
      b.paymentStatus = 'Payment Successful (DBT Paid)';

      // Save directly to Isar
      await _database.saveBooking(b);

      // Trigger notification with formatted amount
      try {
        final notificationService = NotificationService();
        await notificationService.createNotification(
          userId: b.farmerId,
          title: 'DBT Payment Dispatched! ₹${calculatedAmount.toStringAsFixed(2)}',
          body: 'Token ${b.token}: Payout of ₹${calculatedAmount.toStringAsFixed(2)} transferred successfully via DBT.',
          type: 'payment',
        );
      } catch (notifErr) {
        debugPrint('Notification error: $notifErr');
      }

      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessScreen(booking: b),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final double payable = _computePayableAmount(b);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Initiate DBT Payment'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOTAL PAYABLE AMOUNT (DBT)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹ ${payable.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'For ${b.quantityQuintal.toStringAsFixed(1)} Qtl ${b.crop} (Token: ${b.token})',
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Beneficiary Bank Details',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Divider(height: 20),
                    _row('Farmer Name', b.farmerName),
                    _row('Seeded Bank Account', 'XXXX-XXXX-8921'),
                    _row('Bank', 'State Bank of India (SBI)'),
                    _row('IFSC Code', 'SBIN0004921'),
                    _row('Procurement Reference', b.token),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _executePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.account_balance_wallet_outlined),
                label: Text(
                  _isProcessing
                      ? 'Authorizing DBT Transfer...'
                      : 'Initiate DBT Payment',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 13)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
        ],
      ),
    );
  }
}