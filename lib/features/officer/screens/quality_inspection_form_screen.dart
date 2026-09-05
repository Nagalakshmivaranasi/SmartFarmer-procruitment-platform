import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/quality_evaluator.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/notification_service.dart';
import 'officer_payment_screen.dart';

class QualityInspectionFormScreen extends StatefulWidget {
  final BookingModel? booking;

  const QualityInspectionFormScreen({super.key, this.booking});

  @override
  State<QualityInspectionFormScreen> createState() => _QualityInspectionFormScreenState();
}

class _QualityInspectionFormScreenState extends State<QualityInspectionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _database = IsarDatabaseService();

  late final TextEditingController _grossWeightController;
  late final TextEditingController _tareWeightController;
  late final TextEditingController _moistureController;
  late final TextEditingController _foreignMatterController;
  late final TextEditingController _otherGrainsController;
  late final TextEditingController _damagedGrainsController;

  QualityEvaluationResult? _evaluation;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final b = widget.booking;
    final initialQty = b?.quantityQuintal ?? 20.0;

    // Prefill weighbridge values realistically based on booking
    _grossWeightController = TextEditingController(text: (initialQty + 0.50).toStringAsFixed(2));
    _tareWeightController = TextEditingController(text: '0.50');

    // Retain previously recorded parameters if present, otherwise set standard initial benchmarks
    _moistureController = TextEditingController(
      text: (b?.moistureLevel != null && b!.moistureLevel! > 0)
          ? b.moistureLevel!.toStringAsFixed(1)
          : '13.2', // Defaults to conditional partial range to test deductions
    );
    _foreignMatterController = TextEditingController(
      text: (b?.foreignMatterLevel != null && b!.foreignMatterLevel! > 0)
          ? b.foreignMatterLevel!.toStringAsFixed(1)
          : '1.2',
    );
    _otherGrainsController = TextEditingController(text: '1.0');
    _damagedGrainsController = TextEditingController(
      text: (b?.damagedGrainsLevel != null && b!.damagedGrainsLevel! > 0)
          ? b.damagedGrainsLevel!.toStringAsFixed(1)
          : '2.5',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _recalculate();
    });
  }

  @override
  void dispose() {
    _grossWeightController.dispose();
    _tareWeightController.dispose();
    _moistureController.dispose();
    _foreignMatterController.dispose();
    _otherGrainsController.dispose();
    _damagedGrainsController.dispose();
    super.dispose();
  }

  double get _currentNetWeight {
    final gross = double.tryParse(_grossWeightController.text.trim()) ?? 0.0;
    final tare = double.tryParse(_tareWeightController.text.trim()) ?? 0.0;
    final net = gross - tare;
    return net > 0.0 ? net : (widget.booking?.quantityQuintal ?? 0.0);
  }

  void _recalculate() {
    final netWeight = _currentNetWeight;
    final moisture = double.tryParse(_moistureController.text.trim()) ?? 0.0;
    final foreign = double.tryParse(_foreignMatterController.text.trim()) ?? 0.0;
    final other = double.tryParse(_otherGrainsController.text.trim()) ?? 0.0;
    final damaged = double.tryParse(_damagedGrainsController.text.trim()) ?? 0.0;

    setState(() {
      _evaluation = QualityEvaluator.evaluate(
        netWeightQuintal: netWeight,
        moisture: moisture,
        foreignMatter: foreign,
        damagedGrains: damaged,
        otherGrains: other,
      );
    });
  }

  Future<void> _submitInspection() async {
    if (!_formKey.currentState!.validate() || widget.booking == null || _evaluation == null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final current = widget.booking!;
      final eval = _evaluation!;
      String targetStatus;

      switch (eval.verdict) {
        case InspectionVerdict.accepted:
          targetStatus = 'Quality Approved - Ready for Payment';
          current.paymentStatus = 'Pending DBT Initiation';
          break;
        case InspectionVerdict.partiallyAccepted:
          targetStatus = 'Partial Acceptance - Farmer Approval Needed';
          current.paymentStatus = 'Pending Farmer Approval';
          break;
        case InspectionVerdict.rejected:
          targetStatus = 'Inspection Rejected';
          current.paymentStatus = 'Rejected (No Payout)';
          break;
      }

      final double actualNetWeight = _currentNetWeight;
      final double moisture = double.tryParse(_moistureController.text.trim()) ?? 0.0;
      final double foreign = double.tryParse(_foreignMatterController.text.trim()) ?? 0.0;
      final double damaged = double.tryParse(_damagedGrainsController.text.trim()) ?? 0.0;

      // Update actual measured quantities and metrics
      current.status = targetStatus;
      current.quantityQuintal = actualNetWeight;
      current.baseMspRate = QualityEvaluator.baseMsp;
      current.moistureLevel = moisture;
      current.foreignMatterLevel = foreign;
      current.damagedGrainsLevel = damaged;
      current.deductionPercentage = eval.deductionPercentage;
      current.finalRatePerQuintal = eval.finalRatePerQuintal;
      current.netPayableAmount = eval.netPayableAmount;
      current.rejectionReason = eval.remarks;

      // Persist directly to Isar database
      await _database.saveBooking(current);

      final notificationService = NotificationService();
      if (eval.verdict == InspectionVerdict.partiallyAccepted) {
        await notificationService.createNotification(
          userId: current.farmerId,
          title: 'Action Required: Procurement Offer Review',
          body:
              'Token ${current.token}: Produce tested with ${eval.deductionPercentage.toStringAsFixed(1)}% quality deduction. Net payable: ₹${eval.netPayableAmount.toStringAsFixed(2)}. Tap to review.',
          type: 'quality_approval',
        );
      } else if (eval.verdict == InspectionVerdict.accepted) {
        await notificationService.createNotification(
          userId: current.farmerId,
          title: 'Produce Accepted',
          body:
              'Token ${current.token}: Quality approved under standard FAQ limits. Total payable: ₹${eval.netPayableAmount.toStringAsFixed(2)}.',
          type: 'approved',
        );
      } else {
        await notificationService.createNotification(
          userId: current.farmerId,
          title: 'Produce Rejected',
          body: 'Token ${current.token}: Sample fell below procurement specifications (${eval.remarks}).',
          type: 'rejected',
        );
      }

      if (!mounted) return;

      if (eval.verdict == InspectionVerdict.accepted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OfficerPaymentScreen(booking: current),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Inspection recorded: $targetStatus'),
            backgroundColor: eval.verdict == InspectionVerdict.rejected ? Colors.red : Colors.orange.shade800,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving inspection: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;
    final eval = _evaluation;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Inspection: ${b?.token ?? "Token"}', style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Farmer Details Header
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
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Farmer: ${b?.farmerName ?? "N/A"}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Crop: ${b?.crop ?? "Wheat"} • Declared: ${b?.quantityQuintal.toStringAsFixed(1) ?? "0"} Qtl',
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text(b?.token ?? '#--'),
                      backgroundColor: AppColors.mintGreen,
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. Weighment Parameters
              const Text(
                'Weighment Parameters (Quintal)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _grossWeightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Gross Weight (Q)',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (_) => _recalculate(),
                      validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter valid weight' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _tareWeightController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Tare Weight (Q)',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (_) => _recalculate(),
                      validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Enter valid tare' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Calculated Net Produce: ${_currentNetWeight.toStringAsFixed(2)} Qtl',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Quality Analysis
              const Text(
                'Quality Analysis (%)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _moistureController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Moisture (%)',
                        helperText: 'FAQ ≤ 12.0%',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (_) => _recalculate(),
                      validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _foreignMatterController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Foreign Matter (%)',
                        helperText: 'FAQ ≤ 1.0%',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (_) => _recalculate(),
                      validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _damagedGrainsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Damaged / Discolored (%)',
                        helperText: 'Limit ≤ 2.0%',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (_) => _recalculate(),
                      validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Invalid' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _otherGrainsController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Other Grains (%)',
                        helperText: 'Limit ≤ 2.0%',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (_) => _recalculate(),
                      validator: (v) => (double.tryParse(v ?? '') ?? -1) < 0 ? 'Invalid' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 4. Evaluation Live Breakdown
              if (eval != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: eval.verdict == InspectionVerdict.accepted
                        ? const Color(0xFFE8F5E9)
                        : (eval.verdict == InspectionVerdict.partiallyAccepted
                            ? const Color(0xFFFFF8E1)
                            : const Color(0xFFFFEBEE)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: eval.verdict == InspectionVerdict.accepted
                          ? Colors.green
                          : (eval.verdict == InspectionVerdict.partiallyAccepted ? Colors.orange : Colors.red),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              eval.grade,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: eval.verdict == InspectionVerdict.accepted
                                    ? Colors.green.shade900
                                    : (eval.verdict == InspectionVerdict.partiallyAccepted
                                        ? Colors.orange.shade900
                                        : Colors.red.shade900),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: eval.verdict == InspectionVerdict.accepted
                                  ? Colors.green.shade800
                                  : (eval.verdict == InspectionVerdict.partiallyAccepted
                                      ? Colors.orange.shade800
                                      : Colors.red.shade800),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              eval.verdict == InspectionVerdict.accepted
                                  ? 'ACCEPTED'
                                  : (eval.verdict == InspectionVerdict.partiallyAccepted ? 'PARTIAL' : 'REJECTED'),
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(eval.remarks, style: const TextStyle(fontSize: 13)),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Base MSP Benchmark:'),
                          Text('₹ ${QualityEvaluator.baseMsp.toStringAsFixed(2)} / Qtl',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Net Measured Weight:'),
                          Text('${_currentNetWeight.toStringAsFixed(2)} Qtl',
                              style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                      if (eval.deductionPercentage > 0) ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Quality Deduction (${eval.deductionPercentage.toStringAsFixed(1)}%):',
                              style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '- ₹ ${(QualityEvaluator.baseMsp - eval.finalRatePerQuintal).toStringAsFixed(2)} / Qtl',
                              style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Value Deduction:',
                              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w500),
                            ),
                            Text(
                              '- ₹ ${((QualityEvaluator.baseMsp - eval.finalRatePerQuintal) * _currentNetWeight).toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Estimated Net DBT Payout:',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            '₹ ${eval.netPayableAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // 5. Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: _isSaving ? null : _submitInspection,
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          eval?.verdict == InspectionVerdict.accepted
                              ? 'Accept & Proceed to Payment'
                              : 'Confirm & Save Inspection Decision',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}