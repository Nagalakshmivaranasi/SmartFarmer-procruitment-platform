import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import 'quality_inspection_form_screen.dart';

class GateVerificationScreen extends StatefulWidget {
  final BookingModel booking;

  const GateVerificationScreen({super.key, required this.booking});

  @override
  State<GateVerificationScreen> createState() => _GateVerificationScreenState();
}

class _GateVerificationScreenState extends State<GateVerificationScreen> {
  final _database = IsarDatabaseService();
  bool _isProcessing = false;

  Future<void> _markArrivedAndInspect() async {
    setState(() => _isProcessing = true);

    try {
      final b = widget.booking;
      b.status = 'Arrived at Center';
      await _database.saveBooking(b);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => QualityInspectionFormScreen(booking: b),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update status: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = widget.booking;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Gate Verification'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Token Callout Box
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    const Text(
                      'TOKEN NUMBER',
                      style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.1),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      b.token,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Status: ${b.status}',
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Farmer & Consignment Information Card
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
                    const Text('Farmer & Produce Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    const Divider(height: 20),
                    _tile(Icons.person, 'Farmer Name', b.farmerName),
                    _tile(Icons.fingerprint, 'Farmer ID', b.farmerId),
                    _tile(Icons.eco, 'Crop', b.crop),
                    _tile(Icons.balance, 'Declared Quantity', '${b.quantityQuintal.toStringAsFixed(1)} Quintal'),
                    _tile(Icons.warehouse, 'Centre', b.centreName),
                    _tile(Icons.schedule, 'Slot Window', '${b.bookingDate.day}/${b.bookingDate.month}/${b.bookingDate.year} (${b.slotTime})'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _isProcessing ? null : _markArrivedAndInspect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle_outline),
                label: Text(
                  _isProcessing ? 'Recording Arrival...' : 'Mark Arrived & Go to Quality Check',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(IconData icon, String title, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                Text(val, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}