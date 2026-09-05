import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/core_models.dart';
import '../../../services/procurement_repository.dart';

class FarmerInspectionFlow extends StatefulWidget {
  final SlotBooking booking;
  const FarmerInspectionFlow({super.key, required this.booking});

  @override
  State<FarmerInspectionFlow> createState() => _FarmerInspectionFlowState();
}

class _FarmerInspectionFlowState extends State<FarmerInspectionFlow> {
  int inspectionStage = 0;

  final _grossController = TextEditingController(text: '20.20');
  final _tareController = TextEditingController(text: '0.20');

  @override
  void dispose() {
    _grossController.dispose();
    _tareController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = Provider.of<ProcurementRepository>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Token ${widget.booking.tokenNumber} Processing'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _buildInspectionStage(repo),
        ),
      ),
    );
  }

  Widget _buildInspectionStage(ProcurementRepository repo) {
    switch (inspectionStage) {
      case 0:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text('Farmer Arrived at Center',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                'Farmer: ${widget.booking.farmerName}\nToken: ${widget.booking.tokenNumber}',
                textAlign: TextAlign.center),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                repo.updateBookingStatus(
                    widget.booking.id, BookingStatus.arrivedAtCenter);
                setState(() => inspectionStage = 1);
              },
              child: const Text('Mark Arrived & Proceed to Weighment'),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Weighing Station (वजन)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _grossController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Gross Weight (Brought) Quintal'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _tareController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  labelText: 'Tare Weight (Vehicle/Bags) Quintal'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                final gross = double.tryParse(_grossController.text) ?? 20.20;
                final tare = double.tryParse(_tareController.text) ?? 0.20;
                repo.updateWeighment(
                    widget.booking.id, gross * 100, tare * 100);
                repo.updateBookingStatus(
                    widget.booking.id, BookingStatus.underInspection);
                setState(() => inspectionStage = 2);
              },
              child: const Text('Save Weights & Check Quality'),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Quality Evaluation (3/3)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _paramRow('Moisture Content', '11.2 %'),
            _paramRow('Foreign Matter %', '1.5 %'),
            _paramRow('Other Food Grains %', '1.0 %'),
            _paramRow('Damaged / Discolored', '2.5 %'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                repo.updateQualityAndDeal(
                  widget.booking.id,
                  QualityParameters(
                    moistureContent: 11.2,
                    foreignMatter: 1.5,
                    otherFoodGrains: 1.0,
                    damagedGrains: 2.5,
                  ),
                  2425.0,
                );
                repo.updateBookingStatus(
                    widget.booking.id, BookingStatus.dealOffered);
                setState(() => inspectionStage = 3);
              },
              child: const Text('Generate Deal Offer'),
            ),
          ],
        );

      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.verified, size: 64, color: AppColors.statusSuccess),
            const SizedBox(height: 10),
            const Text('Quality Grade: Good',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.statusSuccess)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _summaryRow('Offered Rate', '₹ 2,425 / Quintal'),
                  _summaryRow('Net Weight', '20.00 Quintal'),
                  const Divider(),
                  _summaryRow('Total Payout', '₹ 48,500', isBold: true),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                repo.updateBookingStatus(
                    widget.booking.id, BookingStatus.paymentProcessing);
                setState(() => inspectionStage = 4);
              },
              child: const Text('Farmer Accept Deal & Process Payment'),
            ),
          ],
        );

      case 4:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.task_alt, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            const Text('Payment Completed',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text(
                'Direct Bank Transfer: ₹ 48,500\nTransaction ID: TXN987623412',
                textAlign: TextAlign.center),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                repo.updateBookingStatus(
                    widget.booking.id, BookingStatus.paymentCompleted);
                Navigator.pop(context);
              },
              child: const Text('Close & Back to Dashboard'),
            ),
          ],
        );

      default:
        return const SizedBox();
    }
  }

  Widget _paramRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}