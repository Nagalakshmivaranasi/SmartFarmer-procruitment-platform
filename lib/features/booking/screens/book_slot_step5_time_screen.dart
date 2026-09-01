import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import 'booking_confirmed_screen.dart';

class TimeSlot {
  final String timeText;
  final bool isAvailable;

  TimeSlot({required this.timeText, required this.isAvailable});
}

class BookSlotStep5TimeScreen extends StatefulWidget {
  const BookSlotStep5TimeScreen({super.key});

  @override
  State<BookSlotStep5TimeScreen> createState() => _BookSlotStep5TimeScreenState();
}

class _BookSlotStep5TimeScreenState extends State<BookSlotStep5TimeScreen> {
  String _selectedSlot = '11:00 AM - 12:00 PM';

  final List<TimeSlot> _slots = [
    TimeSlot(timeText: '09:00 AM - 10:00 AM', isAvailable: true),
    TimeSlot(timeText: '10:00 AM - 11:00 AM', isAvailable: true),
    TimeSlot(timeText: '11:00 AM - 12:00 PM', isAvailable: true),
    TimeSlot(timeText: '01:00 PM - 02:00 PM', isAvailable: true),
    TimeSlot(timeText: '02:00 PM - 03:00 PM', isAvailable: true),
  ];

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
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStepTracker(currentStep: 5),
              const SizedBox(height: 24),

              const Text(
                'Available Slots',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: _slots.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final slot = _slots[index];
                    final isSelected = slot.timeText == _selectedSlot;

                    return GestureDetector(
                      onTap: slot.isAvailable
                          ? () => setState(() => _selectedSlot = slot.timeText)
                          : null,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              slot.timeText,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? AppColors.primary
                                    : (slot.isAvailable
                                        ? AppColors.textPrimary
                                        : AppColors.textSecondary),
                              ),
                            ),
                            Text(
                              isSelected
                                  ? 'Selected'
                                  : (slot.isAvailable ? 'Available' : 'Full'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? AppColors.primary
                                    : (slot.isAvailable
                                        ? AppColors.statusGreen
                                        : Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingConfirmedScreen(),
                    ),
                    (route) => route.isFirst,
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