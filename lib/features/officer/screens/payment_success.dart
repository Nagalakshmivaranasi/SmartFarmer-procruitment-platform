import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final BookingModel booking;

  const PaymentSuccessScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final amount = booking.netPayableAmount ?? (booking.quantityQuintal * 2275.0);
    final now = DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: const BoxDecoration(
                    color: AppColors.mintGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, size: 54, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'DBT Payment Dispatched!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              const Text(
                'Payment order processed and routed through PFMS.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _line('Amount Transferred', '₹ ${amount.toStringAsFixed(2)}', isBold: true),
                    _line('Beneficiary', booking.farmerName),
                    _line('Token', booking.token),
                    _line('Payment Mode', 'Direct Benefit Transfer (DBT)'),
                    _line('Transaction UTR', 'PFMS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}7712'),
                    _line('Timestamp', '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}'),
                  ],
                ),
              ),
              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  // Returns back to Officer Home / Dashboard
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Return to Home', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _line(String k, String v, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Text(
            v,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              fontSize: isBold ? 15 : 13,
              color: isBold ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}