import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../payment/screens/payment_status_screen.dart';

class DealLockScreen extends StatefulWidget {
  final BookingModel? booking;

  const DealLockScreen({super.key, this.booking});

  @override
  State<DealLockScreen> createState() => _DealLockScreenState();
}

class _DealLockScreenState extends State<DealLockScreen> {
  bool _isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Final Price Offer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rate Offer Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Column(
                          children: const [
                            Text(
                              'Offered Rate per Quintal',
                              style: TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '₹ 2,275',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'MSP Base: ₹2,275/Quintal (Grade A Approved)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.statusGreen,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Breakdown Section
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _buildPriceRow('Total Quantity', '20 Quintal'),
                            const SizedBox(height: 10),
                            _buildPriceRow('Base Amount', '₹ 45,500'),
                            const SizedBox(height: 10),
                            _buildPriceRow('Deductions', '₹ 0.00'),
                            const Divider(height: 24),
                            _buildPriceRow('Estimated Total Payout', '₹ 45,500', isTotal: true),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Terms Confirmation Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _isAccepted,
                            activeColor: AppColors.primary,
                            onChanged: (val) {
                              if (val != null) setState(() => _isAccepted = val);
                            },
                          ),
                          const Expanded(
                            child: Text(
                              'I accept the final procurement weight and quality evaluation rate.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Action for dispute / re-inspection request
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Raise Dispute',
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isAccepted
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Deal Locked! Payment initiated.'),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentStatusScreen(booking: widget.booking),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(0, 48),
                      ),
                      child: const Text('Accept & Lock Deal'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 14 : 13,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}