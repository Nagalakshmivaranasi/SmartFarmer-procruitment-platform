import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../farmer_home/screens/farmer_inspection_approval_screen.dart';
import '../models/inspection_result.dart';

class QualityInspectionFormScreen extends StatefulWidget {
  const QualityInspectionFormScreen({super.key});

  @override
  State<QualityInspectionFormScreen> createState() => _QualityInspectionFormScreenState();
}

class _QualityInspectionFormScreenState extends State<QualityInspectionFormScreen> {
  final _weightController = TextEditingController(text: '5000');
  final _moistureController = TextEditingController(text: '11.5');
  final _foreignMatterController = TextEditingController(text: '1.2');
  final _damagedController = TextEditingController(text: '1.0');
  bool _farmerArrived = false;

  final double _basePrice = 2275.0; // MSP for Wheat in ₹/Quintal
  final double _quantity = 50.0; // Quintals

  InspectionResult _calculateResult() {
    return InspectionResult(
      tokenId: 'TK-88912',
      cropName: 'Wheat (Sharbati)',
      totalQuantityQuintals: _quantity,
      moisturePercentage: double.tryParse(_moistureController.text) ?? 0.0,
      foreignMatterPercentage: double.tryParse(_foreignMatterController.text) ?? 0.0,
      damagedPercentage: double.tryParse(_damagedController.text) ?? 0.0,
      basePricePerQuintal: _basePrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateResult();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Arrival & Quality Check')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: ListTile(
                  title: const Text('Token #TK-88912 • Ramesh Kumar'),
                  subtitle: Text('Crop: Wheat • Declared Qty: ${_quantity.toInt()} Quintals'),
                ),
              ),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _farmerArrived ? Colors.green.shade50 : Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _farmerArrived ? Colors.green : Colors.orange.shade700,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _farmerArrived ? Icons.check_circle : Icons.pending_actions_outlined,
                      color: _farmerArrived ? Colors.green : Colors.orange.shade800,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _farmerArrived
                            ? 'Farmer has arrived and inspection can proceed.'
                            : 'Farmer arrival is pending before lab testing can begin.',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              if (!_farmerArrived)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _farmerArrived = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Farmer marked as arrived.')), 
                      );
                    },
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Mark Farmer Arrived'),
                  ),
                )
              else ...[
                const Text(
                  'Lab Testing Parameters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _buildInputField('Weight Recorded (kg)', _weightController),
                const SizedBox(height: 12),
                _buildInputField('Moisture Content (%)', _moistureController),
                const SizedBox(height: 12),
                _buildInputField('Foreign Matter (%)', _foreignMatterController),
                const SizedBox(height: 12),
                _buildInputField('Damaged / Discolored Grain (%)', _damagedController),
                const SizedBox(height: 20),

                _buildStatusCard(result),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FarmerInspectionApprovalScreen(result: result),
                        ),
                      );
                    },
                    child: const Text('Submit & Send to Farmer for Approval'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setState(() {}),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _buildStatusCard(InspectionResult result) {
    Color cardColor;
    String statusText;
    IconData icon;

    switch (result.status) {
      case InspectionStatus.fullyAccepted:
        cardColor = Colors.green;
        statusText = 'FULLY ACCEPTED (Grade A)';
        icon = Icons.check_circle;
        break;
      case InspectionStatus.partiallyAccepted:
        cardColor = Colors.orange.shade800;
        statusText = 'PARTIALLY ACCEPTED (Deductions Applied)';
        icon = Icons.warning;
        break;
      case InspectionStatus.rejected:
        cardColor = Colors.red;
        statusText = 'REJECTED (Exceeds Limits)';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: cardColor, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: cardColor,
                  ),
                ),
              ),
            ],
          ),
          if (result.status == InspectionStatus.partiallyAccepted) ...[
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Base Price:'),
                Text('₹${result.basePricePerQuintal}/Qtl'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Quality Deduction:'),
                Text('- ₹${result.priceDeductionPerQuintal.toStringAsFixed(2)}/Qtl', style: const TextStyle(color: Colors.red)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Final Rate:', style: TextStyle(fontWeight: FontWeight.bold)),
                Text('₹${result.finalPricePerQuintal.toStringAsFixed(2)}/Qtl', style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ] else if (result.status == InspectionStatus.rejected) ...[
            const SizedBox(height: 8),
            const Text(
              'Stock cannot be procured at government MSP due to high moisture or foreign matter levels.',
              style: TextStyle(fontSize: 12, color: Colors.red),
            ),
          ],
        ],
      ),
    );
  }
}