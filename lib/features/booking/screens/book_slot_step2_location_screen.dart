import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/local_database_service.dart';
import 'book_slot_step3_center_screen.dart';

class BookSlotStep2LocationScreen extends StatefulWidget {
  final String crop;
  final double quantityQuintal;

  const BookSlotStep2LocationScreen({
    super.key,
    required this.crop,
    required this.quantityQuintal,
  });

  @override
  State<BookSlotStep2LocationScreen> createState() =>
      _BookSlotStep2LocationScreenState();
}

class _BookSlotStep2LocationScreenState
    extends State<BookSlotStep2LocationScreen> {
  final _database = IsarDatabaseService();
  String? _selectedState;
  String? _selectedDistrict;
  List<String> _states = [];
  List<String> _districts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    final loaded = await _database.states();
    setState(() {
      _states = loaded.isEmpty
          ? ['Madhya Pradesh', 'Telangana', 'Punjab', 'Haryana', 'Andhra Pradesh']
          : loaded;
      _selectedState = _states.first;
      _isLoading = false;
    });
    _loadDistricts(_selectedState!);
  }

  Future<void> _loadDistricts(String state) async {
    final loaded = await _database.districts(state);
    setState(() {
      _districts = loaded.isEmpty
          ? ['Shivpuri', 'Bhopal', 'Indore', 'Gwalior', 'Ujjain']
          : loaded;
      _selectedDistrict = _districts.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Slot (Step 2 of 6)'),
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

              if (_isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select State',
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
                              value: _selectedState,
                              isExpanded: true,
                              items: _states
                                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _selectedState = val);
                                  _loadDistricts(val);
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          'Select District',
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
                              value: _selectedDistrict,
                              isExpanded: true,
                              items: _districts
                                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                                  .toList(),
                              onChanged: (val) {
                                if (val != null) setState(() => _selectedDistrict = val);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              ElevatedButton(
                onPressed: (_selectedState == null || _selectedDistrict == null)
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookSlotStep3CenterScreen(
                              crop: widget.crop,
                              quantityQuintal: widget.quantityQuintal,
                              state: _selectedState!,
                              district: _selectedDistrict!,
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