import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/local_database_service.dart';
import 'quality_inspection_form_screen.dart';

class SlotVerificationScreen extends StatefulWidget {
  const SlotVerificationScreen({super.key});

  @override
  State<SlotVerificationScreen> createState() => _SlotVerificationScreenState();
}

class _SlotVerificationScreenState extends State<SlotVerificationScreen> {
  final _tokenController = TextEditingController();
  final _database = IsarDatabaseService();
  bool _handledScan = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _verify(String rawToken) async {
    final token = rawToken.trim().replaceFirst('#', '');
    if (token.isEmpty) return;
    final booking = await _database.bookingByToken(token);
    if (!mounted) return;
    if (booking == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Token not found in local database.')));
      return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => QualityInspectionFormScreen(booking: booking)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Slot Verification')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: MobileScanner(
                  onDetect: (capture) {
                    if (_handledScan) return;
                    final value = capture.barcodes.isEmpty ? null : capture.barcodes.first.rawValue;
                    if (value == null) return;
                    _handledScan = true;
                    _verify(value);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Or Enter Token ID Manually', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: _tokenController, decoration: const InputDecoration(hintText: 'Enter token ID'))),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: () => _verify(_tokenController.text), child: const Text('Verify')),
            ]),
          ]),
        ),
      ),
    );
  }
}
