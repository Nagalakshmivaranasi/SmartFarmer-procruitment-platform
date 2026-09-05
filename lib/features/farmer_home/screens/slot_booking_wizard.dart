import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../services/local_database_service.dart';
import '../../../services/session_service.dart';
import '../../booking/screens/booking_success_screen.dart';
import 'package:smart_farmer_procurement/l10n/generated/app_localizations.dart';
import '../../../services/direct_sms_service.dart';

class SlotBookingWizard extends StatefulWidget {
  const SlotBookingWizard({super.key});

  @override
  State<SlotBookingWizard> createState() => _SlotBookingWizardState();
}

class _SlotBookingWizardState extends State<SlotBookingWizard> {
  final _database = IsarDatabaseService();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Form State
  String _selectedCrop = 'Wheat';
  final _quantityController = TextEditingController(text: '25.0');
  String _selectedState = 'Madhya Pradesh';
  String _selectedDistrict = 'Shivpuri';
  String _selectedCentreId = 'CTR_SHIV_01';
  String _selectedCentreName = 'Shivpuri Procurement Center';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedSlotTime = '10:00 AM - 11:00 AM';

  // Map to store how many bookings exist per slot for the selected date & centre
  final Map<String, int> _slotCounts = {};
  bool _isLoadingSlots = false;

  final List<String> _crops = const ['Wheat', 'Paddy', 'Gram (Chana)', 'Mustard'];
  final List<Map<String, String>> _centres = const [
    {'id': 'CTR_SHIV_01', 'name': 'Shivpuri Procurement Center'},
    {'id': 'CTR_KOL_02', 'name': 'Kolaras Krishi Mandi'},
    {'id': 'CTR_POH_03', 'name': 'Pohari Grain Procurement Hub'},
  ];
  final List<String> _slots = const [
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '01:00 PM - 02:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _fetchSlotCounts();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _fetchSlotCounts() async {
    setState(() => _isLoadingSlots = true);
    try {
      await IsarDatabaseService.initialize();
      final Map<String, int> counts = {};
      for (var slot in _slots) {
        final count = await _database.getSlotBookingCount(
          centreId: _selectedCentreId,
          bookingDate: _selectedDate,
          slotTime: slot,
        );
        counts[slot] = count;
      }
      if (mounted) {
        setState(() {
          _slotCounts.clear();
          _slotCounts.addAll(counts);
          _isLoadingSlots = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingSlots = false);
    }
  }

  String _generateToken() {
    final random = Random();
    final number = 1000 + random.nextInt(9000);
    return 'KST-$number';
  }

  void _nextStep(AppLocalizations l10n) {
    if (_currentStep < 4) {
      setState(() => _currentStep++);
      if (_currentStep == 4) {
        _fetchSlotCounts();
      }
    } else {
      _handleCompleteBooking(l10n);
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _handleCompleteBooking(AppLocalizations l10n) async {
    final user = SessionService.instance.currentUser;
    final farmerId = user?.farmerId ?? user?.uid ?? 'FARMER_GUEST';
    final farmerName = user?.name.isNotEmpty == true ? user!.name : 'Registered Farmer';
    final quantity = double.tryParse(_quantityController.text.trim()) ?? 10.0;

    setState(() => _isSubmitting = true);

    try {
      await IsarDatabaseService.initialize();

      // Prevent overlapping slots for the same farmer
      final isDuplicate = await _database.hasDuplicateFarmerBooking(
        farmerId: farmerId,
        bookingDate: _selectedDate,
        slotTime: _selectedSlotTime,
      );

      if (isDuplicate) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.duplicateBookingError),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      // Limit: 1 person per slot
      final currentCapacity = await _database.getSlotBookingCount(
        centreId: _selectedCentreId,
        bookingDate: _selectedDate,
        slotTime: _selectedSlotTime,
      );

      if (currentCapacity >= 1) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.slotFullError),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => _isSubmitting = false);
        return;
      }

      final token = _generateToken();
      final newBooking = BookingModel(
        bookingId: 'BK_${DateTime.now().millisecondsSinceEpoch}',
        token: token,
        farmerId: farmerId,
        farmerName: farmerName,
        crop: _selectedCrop,
        quantityQuintal: quantity,
        centreId: _selectedCentreId,
        centreName: _selectedCentreName,
        bookingDate: _selectedDate,
        slotTime: _selectedSlotTime,
        status: 'Slot Booked',
        paymentStatus: 'Pending',
        createdAt: DateTime.now(),
      );

      await _database.saveBooking(newBooking);
      final farmerPhone = user?.phoneNumber ?? '';
      if (farmerPhone.isNotEmpty) {
        DirectSmsService.sendSlotConfirmation(
          phone: farmerPhone,
          token: newBooking.token,
          crop: newBooking.crop,
          quantity: newBooking.quantityQuintal,
          date: '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
          timeSlot: _selectedSlotTime,
        );
      }
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingSuccessScreen(booking: newBooking),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.failedToBookSlot(e.toString())),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stepTitles = [
      l10n.stepSelectCrop,
      l10n.stepProduceQuantity,
      l10n.stepLocation,
      l10n.stepCenter,
      l10n.stepDateAndSlot,
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.bookSlotTitle),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Progress Tracker
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.stepProgress(_currentStep + 1, 5, stepTitles[_currentStep]),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        '${((_currentStep + 1) / 5 * 100).toInt()}%',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_currentStep + 1) / 5,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
            ),

            // Step Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildStepBody(l10n),
              ),
            ),

            // Bottom Navigation Controls
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      flex: 1,
                      child: OutlinedButton(
                        onPressed: _isSubmitting ? null : _prevStep,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(l10n.back),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : () => _nextStep(l10n),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              _currentStep == 4 ? l10n.confirmAndBookSlot : l10n.continueButton,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepBody(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _Step1Crop(
          crops: _crops,
          selected: _selectedCrop,
          onSelected: (val) => setState(() => _selectedCrop = val),
          l10n: l10n,
        );
      case 1:
        return _Step2Quantity(
          controller: _quantityController,
          crop: _selectedCrop,
          l10n: l10n,
        );
      case 2:
        return _Step3Location(
          state: _selectedState,
          district: _selectedDistrict,
          onStateChanged: (val) => setState(() => _selectedState = val),
          onDistrictChanged: (val) => setState(() => _selectedDistrict = val),
          l10n: l10n,
        );
      case 3:
        return _Step4Center(
          centres: _centres,
          selectedId: _selectedCentreId,
          onSelected: (id, name) {
            setState(() {
              _selectedCentreId = id;
              _selectedCentreName = name;
            });
            _fetchSlotCounts();
          },
          l10n: l10n,
        );
      case 4:
      default:
        return _Step5TimeSlot(
          date: _selectedDate,
          slot: _selectedSlotTime,
          slots: _slots,
          slotCounts: _slotCounts,
          isLoading: _isLoadingSlots,
          onDatePicked: (val) {
            setState(() => _selectedDate = val);
            _fetchSlotCounts();
          },
          onSlotSelected: (val) => setState(() => _selectedSlotTime = val),
          l10n: l10n,
        );
    }
  }
}

// --- SUB-STEP WIDGETS ---

class _Step1Crop extends StatelessWidget {
  final List<String> crops;
  final String selected;
  final ValueChanged<String> onSelected;
  final AppLocalizations l10n;

  const _Step1Crop({
    required this.crops,
    required this.selected,
    required this.onSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.cropQuestion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...crops.map((crop) {
          final isSelected = selected == crop;
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.mintGreen.withValues(alpha: 0.3) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
            ),
            child: ListTile(
              leading: const Icon(Icons.grass_outlined, color: AppColors.primary),
              title: Text(crop, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () => onSelected(crop),
            ),
          );
        }),
      ],
    );
  }
}

class _Step2Quantity extends StatelessWidget {
  final TextEditingController controller;
  final String crop;
  final AppLocalizations l10n;

  const _Step2Quantity({
    required this.controller,
    required this.crop,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.estimatedQuantityForCrop(crop), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(l10n.quantitySubtext, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: l10n.quantityQuintalLabel,
            suffixText: 'Qtl',
            prefixIcon: const Icon(Icons.scale_outlined),
          ),
        ),
      ],
    );
  }
}

class _Step3Location extends StatelessWidget {
  final String state;
  final String district;
  final ValueChanged<String> onStateChanged;
  final ValueChanged<String> onDistrictChanged;
  final AppLocalizations l10n;

  const _Step3Location({
    required this.state,
    required this.district,
    required this.onStateChanged,
    required this.onDistrictChanged,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.selectRegion, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: state,
          decoration: InputDecoration(labelText: l10n.state, prefixIcon: const Icon(Icons.map_outlined)),
          items: const [DropdownMenuItem(value: 'Madhya Pradesh', child: Text('Madhya Pradesh'))],
          onChanged: (v) => onStateChanged(v ?? state),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          initialValue: district,
          decoration: InputDecoration(labelText: l10n.district, prefixIcon: const Icon(Icons.location_city_outlined)),
          items: const [
            DropdownMenuItem(value: 'Shivpuri', child: Text('Shivpuri')),
            DropdownMenuItem(value: 'Gwalior', child: Text('Gwalior')),
          ],
          onChanged: (v) => onDistrictChanged(v ?? district),
        ),
      ],
    );
  }
}

class _Step4Center extends StatelessWidget {
  final List<Map<String, String>> centres;
  final String selectedId;
  final void Function(String id, String name) onSelected;
  final AppLocalizations l10n;

  const _Step4Center({
    required this.centres,
    required this.selectedId,
    required this.onSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.procurementCenter, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ...centres.map((c) {
          final isSelected = selectedId == c['id'];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.mintGreen.withValues(alpha: 0.3) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1),
            ),
            child: ListTile(
              leading: Icon(Icons.storefront_outlined, color: isSelected ? AppColors.primary : Colors.grey),
              title: Text(c['name']!, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
              trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () => onSelected(c['id']!, c['name']!),
            ),
          );
        }),
      ],
    );
  }
}

class _Step5TimeSlot extends StatelessWidget {
  final DateTime date;
  final String slot;
  final List<String> slots;
  final Map<String, int> slotCounts;
  final bool isLoading;
  final ValueChanged<DateTime> onDatePicked;
  final ValueChanged<String> onSlotSelected;
  final AppLocalizations l10n;

  const _Step5TimeSlot({
    required this.date,
    required this.slot,
    required this.slots,
    required this.slotCounts,
    required this.isLoading,
    required this.onDatePicked,
    required this.onSlotSelected,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.chooseDateAndArrivalSlot, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: AppColors.border),
          ),
          tileColor: Colors.white,
          leading: const Icon(Icons.calendar_today_outlined, color: AppColors.primary),
          title: Text(
            l10n.dateLabel('${date.day}/${date.month}/${date.year}'),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 30)),
            );
            if (picked != null) onDatePicked(picked);
          },
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.availableTimeWindows, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            if (isLoading)
              const SizedBox(
                height: 14,
                width: 14,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          itemBuilder: (context, index) {
            final s = slots[index];
            final count = slotCounts[s] ?? 0;
            final isFilled = count >= 1; // Limit: 1 person per slot
            final isSelected = slot == s;

            // Visual styling: White if empty, Red if filled
            Color cardBgColor = Colors.white;
            Color borderColor = AppColors.border;
            Color textColor = AppColors.textPrimary;
            Color badgeBgColor = AppColors.mintGreen.withValues(alpha: 0.5);
            Color badgeTextColor = AppColors.primary;
            String statusLabel = 'Available (0/1)';
            IconData iconData = Icons.access_time_outlined;

            if (isFilled) {
              cardBgColor = Colors.red.shade50;
              borderColor = Colors.red.shade300;
              textColor = Colors.grey.shade600;
              badgeBgColor = Colors.red.shade100;
              badgeTextColor = Colors.red.shade700;
              statusLabel = 'Filled (1/1)';
              iconData = Icons.block;
            } else if (isSelected) {
              cardBgColor = AppColors.mintGreen.withValues(alpha: 0.3);
              borderColor = AppColors.primary;
              textColor = AppColors.primary;
            }

            return GestureDetector(
              onTap: isFilled ? null : () => onSlotSelected(s),
              child: Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : borderColor,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          iconData,
                          color: isFilled ? Colors.red : (isSelected ? AppColors.primary : Colors.grey),
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          s,
                          style: TextStyle(
                            fontWeight: isSelected || isFilled ? FontWeight.bold : FontWeight.normal,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeBgColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}