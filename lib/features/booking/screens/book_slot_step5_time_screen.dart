import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/centre_model.dart';
import '../../../services/local_database_service.dart';
import 'booking_confirmation_screen.dart';

class BookSlotStep5TimeScreen extends StatefulWidget {
  final String crop;
  final double quantityQuintal;
  final String state;
  final String district;
  final CentreModel centre;
  final DateTime date;

  const BookSlotStep5TimeScreen({
    super.key,
    required this.crop,
    required this.quantityQuintal,
    required this.state,
    required this.district,
    required this.centre,
    required this.date,
  });

  @override
  State<BookSlotStep5TimeScreen> createState() => _BookSlotStep5TimeScreenState();
}

class _BookSlotStep5TimeScreenState extends State<BookSlotStep5TimeScreen> {
  final _database = IsarDatabaseService();
  String? _selectedSlot;
  late List<String> _allSlots;

  @override
  void initState() {
    super.initState();
    _allSlots = _generateTimeSlots();
  }

  List<String> _generateTimeSlots() {
    final slots = <String>[];
    for (var minutes = 7 * 60; minutes < 19 * 60; minutes += 30) {
      final startStr = _formatMinutes(minutes);
      final endStr = _formatMinutes(minutes + 30);
      slots.add('$startStr - $endStr');
    }
    return slots;
  }

  String _formatMinutes(int minutes) {
    final hour = minutes ~/ 60;
    final min = minutes % 60;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '${displayHour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $suffix';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Book Slot (Step 5 of 6)'),
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
              _buildStepTracker(currentStep: 5),
              const SizedBox(height: 24),

              Text(
                'Available Slots for ${widget.date.day}/${widget.date.month}/${widget.date.year}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              Expanded(
                child: ListView.separated(
                  itemCount: _allSlots.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final slotText = _allSlots[index];
                    return FutureBuilder<bool>(
                      future: _database.isSlotAvailable(
                        centre: widget.centre,
                        date: widget.date,
                        slotTime: slotText,
                      ),
                      builder: (context, snapshot) {
                        final isAvailable = snapshot.data ?? true;
                        final isSelected = slotText == _selectedSlot;

                        return GestureDetector(
                          onTap: isAvailable
                              ? () => setState(() => _selectedSlot = slotText)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: !isAvailable
                                  ? Colors.grey.shade200
                                  : (isSelected ? Colors.white : AppColors.cardBg),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: !isAvailable
                                    ? Colors.grey.shade400
                                    : (isSelected ? AppColors.primary : AppColors.border),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  slotText,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: !isAvailable
                                        ? Colors.grey.shade600
                                        : (isSelected
                                            ? AppColors.primary
                                            : AppColors.textPrimary),
                                  ),
                                ),
                                Text(
                                  !isAvailable
                                      ? '$slotText - Not Available'
                                      : (isSelected ? 'Selected' : 'Available'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: !isAvailable
                                        ? Colors.red.shade700
                                        : (isSelected
                                            ? AppColors.primary
                                            : AppColors.statusGreen),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              ElevatedButton(
                onPressed: _selectedSlot == null
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingConfirmationScreen(
                              crop: widget.crop,
                              quantityQuintal: widget.quantityQuintal,
                              state: widget.state,
                              district: widget.district,
                              centre: widget.centre,
                              date: widget.date,
                              slotTime: _selectedSlot!,
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