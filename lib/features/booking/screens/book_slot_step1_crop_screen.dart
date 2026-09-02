import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'book_slot_step2_location_screen.dart';

class BookSlotStep1CropScreen extends StatefulWidget {
  const BookSlotStep1CropScreen({super.key});

  @override
  State<BookSlotStep1CropScreen> createState() => _BookSlotStep1CropScreenState();
}

class _BookSlotStep1CropScreenState extends State<BookSlotStep1CropScreen> {
  String _selectedCrop = 'Wheat';
  String _selectedSeason = 'Rabi';
  final TextEditingController _quantityController = TextEditingController(text: '20');
  final TextEditingController _landAreaController = TextEditingController(text: '5');

  final List<String> _crops = [
    'Wheat',
    'Paddy',
    'Mustard',
    'Gram',
    'Maize',
    'Cotton',
  ];

  final List<String> _seasons = [
    'Rabi',
    'Kharif',
    'Zaid',
  ];

  @override
  void dispose() {
    _quantityController.dispose();
    _landAreaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Slot (Step 1 of 6)'),
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
              _buildStepTracker(currentStep: 1),
              const SizedBox(height: 24),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Select Crop',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedCrop,
                            isExpanded: true,
                            items: _crops
                                .map((crop) => DropdownMenuItem(
                                      value: crop,
                                      child: Text(crop),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedCrop = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Crop Season',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSeason,
                            isExpanded: true,
                            items: _seasons
                                .map((season) => DropdownMenuItem(
                                      value: season,
                                      child: Text(season),
                                    ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedSeason = val);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Estimated Quantity (in Quintals)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter quantity',
                          suffixText: 'Quintal',
                        ),
                      ),
                      const SizedBox(height: 20),

                      const Text(
                        'Land Area (in Acres)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _landAreaController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Enter land area',
                          suffixText: 'Acres',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  final qty = double.tryParse(_quantityController.text) ?? 20.0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookSlotStep2LocationScreen(
                        crop: _selectedCrop,
                        quantityQuintal: qty,
                      ),
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