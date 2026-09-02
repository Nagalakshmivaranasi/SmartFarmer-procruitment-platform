import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/centre_model.dart';
import 'book_slot_step5_time_screen.dart';

class BookSlotStep4DateScreen extends StatefulWidget {
  final String crop;
  final double quantityQuintal;
  final String state;
  final String district;
  final CentreModel centre;

  const BookSlotStep4DateScreen({
    super.key,
    required this.crop,
    required this.quantityQuintal,
    required this.state,
    required this.district,
    required this.centre,
  });

  @override
  State<BookSlotStep4DateScreen> createState() => _BookSlotStep4DateScreenState();
}

class _BookSlotStep4DateScreenState extends State<BookSlotStep4DateScreen> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Slot (Step 4 of 6)'),
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
              _buildStepTracker(currentStep: 4),
              const SizedBox(height: 24),

              // Calendar Picker Card
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: CalendarDatePicker(
                  initialDate: _selectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  onDateChanged: (newDate) {
                    setState(() => _selectedDate = newDate);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Selected Date Box Widget
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Selected Date',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookSlotStep5TimeScreen(
                        crop: widget.crop,
                        quantityQuintal: widget.quantityQuintal,
                        state: widget.state,
                        district: widget.district,
                        centre: widget.centre,
                        date: _selectedDate,
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