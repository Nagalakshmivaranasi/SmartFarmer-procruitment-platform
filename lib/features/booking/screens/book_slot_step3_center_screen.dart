import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/centre_model.dart';
import '../../../services/local_database_service.dart';
import 'book_slot_step4_date_screen.dart';

class BookSlotStep3CenterScreen extends StatefulWidget {
  final String crop;
  final double quantityQuintal;
  final String state;
  final String district;

  const BookSlotStep3CenterScreen({
    super.key,
    required this.crop,
    required this.quantityQuintal,
    required this.state,
    required this.district,
  });

  @override
  State<BookSlotStep3CenterScreen> createState() => _BookSlotStep3CenterScreenState();
}

class _BookSlotStep3CenterScreenState extends State<BookSlotStep3CenterScreen> {
  final _database = IsarDatabaseService();
  CentreModel? _selectedCenter;
  List<CentreModel> _centers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCenters();
  }

  Future<void> _loadCenters() async {
    final loaded = await _database.centresByDistrict(widget.state, widget.district);
    setState(() {
      _centers = loaded;
      if (_centers.isNotEmpty) {
        _selectedCenter = _centers.first;
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Slot (Step 3 of 6)'),
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
              _buildStepTracker(currentStep: 3),
              const SizedBox(height: 24),

              Text(
                'Procurement Centers in ${widget.district}, ${widget.state}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              if (_isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (_centers.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('No procurement centers found in this district.'),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    itemCount: _centers.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final center = _centers[index];
                      final isSelected = _selectedCenter?.centreId == center.centreId;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCenter = center),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      center.centreName,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'ID: ${center.centreId} • Capacity: ${center.capacity} slots/day',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                color: isSelected ? AppColors.primary : Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

              ElevatedButton(
                onPressed: _selectedCenter == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookSlotStep4DateScreen(
                              crop: widget.crop,
                              quantityQuintal: widget.quantityQuintal,
                              state: widget.state,
                              district: widget.district,
                              centre: _selectedCenter!,
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