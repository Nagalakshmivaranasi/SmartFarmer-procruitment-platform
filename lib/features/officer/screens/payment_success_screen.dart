import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/session_service.dart';
import '../../../services/direct_sms_service.dart'; // Optional background SMS
import 'package:smart_farmer_procurement/l10n/generated/app_localizations.dart';

class PaymentSuccessScreen extends StatefulWidget {
  final BookingModel booking;

  const PaymentSuccessScreen({super.key, required this.booking});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen> {
  @override
  void initState() {
    super.initState();
    _dispatchPaymentSmsIfNeeded();
  }

  Future<void> _dispatchPaymentSmsIfNeeded() async {
    final user = SessionService.instance.currentUser;
    final farmerPhone = user?.phoneNumber ?? '';

    if (farmerPhone.isNotEmpty) {
      final amount = widget.booking.netPayableAmount ?? (widget.booking.quantityQuintal * 2275.0);
      final now = DateTime.now();
      final utr = 'PFMS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}7712';

      // Send silent SMS via SIM
      await DirectSmsService.sendPaymentConfirmation(
        phone: farmerPhone,
        token: widget.booking.token,
        amount: amount,
        utr: utr,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final amount = widget.booking.netPayableAmount ?? (widget.booking.quantityQuintal * 2275.0);
    final now = DateTime.now();
    final utrValue = 'PFMS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}7712';
    final timeValue = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute.toString().padLeft(2, '0')}';

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
              Text(
                l10n.dbtPaymentDispatched,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.pfmsRoutingMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
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
                    _line(l10n.amountTransferred, '₹ ${amount.toStringAsFixed(2)}', isBold: true),
                    _line(l10n.beneficiary, widget.booking.farmerName),
                    _line(l10n.token, widget.booking.token),
                    _line(l10n.paymentMode, l10n.directBenefitTransfer),
                    _line(l10n.transactionUtr, utrValue),
                    _line(l10n.timestamp, timeValue),
                  ],
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(l10n.returnToHome, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
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