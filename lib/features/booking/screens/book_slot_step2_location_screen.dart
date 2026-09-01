import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'book_slot_step3_center_screen.dart';

class BookSlotStep2LocationScreen extends StatefulWidget {
  const BookSlotStep2LocationScreen({super.key});

  @override
  State<BookSlotStep2LocationScreen> createState() =>
      _BookSlotStep2LocationScreenState();
}

class _BookSlotStep2LocationScreenState
    extends State<BookSlotStep2LocationScreen> {
  final TextEditingController _districtController =
      TextEditingController(text: 'Shivpuri');
  final TextEditingController _blockController =
      TextEditingController(text: 'Kolaras');

  @override
  void dispose() {
    _districtController.dispose();
    _blockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Slot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTracker(currentStep: 2),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'District',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _districtController,
                        initialValue: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter District',
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Block / Tehsil',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _blockController,
                        initialValue: null,
                        decoration: const InputDecoration(
                          hintText: 'Enter Block or Tehsil',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookSlotStep3CenterScreen(),
                    ),
                  );
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepTracker({required int currentStep}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        final stepNum = index + 1;
        final isActive = stepNum == currentStep;
        return Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$stepNum',
              style: TextStyle(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }),
    );
  }
}