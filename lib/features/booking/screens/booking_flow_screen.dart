import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/centre_model.dart';
import '../../../models/booking_model.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';
import '../../farmer_home/screens/booking_confirmed_screen.dart';

class BookingFlowScreen extends StatefulWidget {
  final String crop;
  final double quantityQuintal;

  const BookingFlowScreen({
    super.key,
    required this.crop,
    required this.quantityQuintal,
  });

  @override
  State<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends State<BookingFlowScreen> {
  final _database = IsarDatabaseService();
  late Future<List<String>> _statesFuture;
  String? _state;
  String? _district;
  CentreModel? _centre;
  DateTime _date = DateTime.now();
  String? _slot;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _statesFuture = _database.states();
  }

  List<String> _slots() {
    final slots = <String>[];
    for (var minutes = 8 * 60; minutes < 18 * 60; minutes += 60) {
      final start = _timeLabel(minutes);
      final end = _timeLabel(minutes + 60);
      slots.add('$start - $end');
    }
    return slots;
  }

  String _timeLabel(int minutes) {
    final hour = minutes ~/ 60;
    final minute = minutes % 60;
    final suffix = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $suffix';
  }

  Future<void> _saveBooking() async {
    final user = SessionService.instance.currentUser;
    if (user == null || _centre == null || _slot == null || _state == null || _district == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all booking selections.')),
      );
      return;
    }

    setState(() => _saving = true);
    final normalizedDate = DateTime(_date.year, _date.month, _date.day);

    // Double check slot availability
    final isAvailable = await _database.isSlotAvailable(
      centre: _centre!,
      date: normalizedDate,
      slotTime: _slot!,
    );

    if (!isAvailable) {
      setState(() {
        _saving = false;
        _slot = null;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This slot was just filled. Please choose another available slot.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final nextNumber = await _database.generateNextSequentialToken(
      centreId: _centre!.centreId,
      date: normalizedDate,
    );
    final token = '#$nextNumber';

    final booking = BookingModel(
      bookingId: 'booking_${DateTime.now().millisecondsSinceEpoch}',
      farmerId: user.farmerId ?? user.uid,
      farmerName: user.name,
      centreId: _centre!.centreId,
      centreName: _centre!.centreName,
      crop: widget.crop,
      quantityQuintal: widget.quantityQuintal,
      bookingDate: normalizedDate,
      slotTime: _slot!,
      token: token,
      status: 'Pending',
      createdAt: DateTime.now(),
    );

    await _database.saveBooking(booking);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => BookingConfirmedScreen(booking: booking)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Location & Slot'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<String>>(
        future: _statesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          }
          final states = snapshot.data ?? [];
          if (states.isEmpty) {
            return const Center(child: Text('No procurement centres available in system.'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _stepHeader('1. Select Region & Center'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _state,
                      decoration: const InputDecoration(labelText: 'State', prefixIcon: Icon(Icons.map_outlined)),
                      items: states.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                      onChanged: (value) async {
                        setState(() {
                          _state = value;
                          _district = null;
                          _centre = null;
                          _slot = null;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    if (_state != null)
                      FutureBuilder<List<String>>(
                        future: _database.districts(_state!),
                        builder: (context, districtSnapshot) => DropdownButtonFormField<String>(
                          initialValue: _district,
                          decoration: const InputDecoration(
                            labelText: 'District',
                            prefixIcon: Icon(Icons.location_city_outlined),
                          ),
                          items: (districtSnapshot.data ?? [])
                              .map((value) => DropdownMenuItem(value: value, child: Text(value)))
                              .toList(),
                          onChanged: (value) => setState(() {
                            _district = value;
                            _centre = null;
                            _slot = null;
                          }),
                        ),
                      ),
                    const SizedBox(height: 12),
                    if (_district != null)
                      FutureBuilder<List<CentreModel>>(
                        future: _database.centresByDistrict(_state!, _district!),
                        builder: (context, centreSnapshot) => DropdownButtonFormField<CentreModel>(
                          initialValue: _centre,
                          decoration: const InputDecoration(
                            labelText: 'Procurement Centre',
                            prefixIcon: Icon(Icons.storefront_outlined),
                          ),
                          items: (centreSnapshot.data ?? [])
                              .map((centre) => DropdownMenuItem(value: centre, child: Text(centre.centreName)))
                              .toList(),
                          onChanged: (value) => setState(() {
                            _centre = value;
                            _slot = null;
                          }),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              if (_centre != null) ...[
                _stepHeader('2. Choose Date'),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: CalendarDatePicker(
                    initialDate: _date,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 60)),
                    onDateChanged: (value) => setState(() {
                      _date = value;
                      _slot = null;
                    }),
                  ),
                ),
                const SizedBox(height: 20),

                _stepHeader('3. Slot Availability for ${DateFormat('dd MMM yyyy').format(_date)}'),
                ..._slots().map((slot) => _slotTile(slot)),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: _saving || _slot == null ? null : _saveBooking,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text('Confirm Slot: ${_slot ?? "Choose Time"}'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _slotTile(String slot) {
    return FutureBuilder<int>(
      future: _database.bookedCount(
        centreId: _centre!.centreId,
        date: _date,
        slotTime: slot,
      ),
      builder: (context, snapshot) {
        final currentCount = snapshot.data ?? 0;
        final maxCapacity = _centre!.capacity;
        final remaining = maxCapacity - currentCount;
        final isAvailable = remaining > 0;
        final isSelected = _slot == slot;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.1)
                : isAvailable
                    ? Colors.white
                    : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : isAvailable
                      ? AppColors.border
                      : Colors.grey.shade300,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ListTile(
            enabled: isAvailable,
            leading: Icon(
              isSelected
                  ? Icons.check_circle
                  : isAvailable
                      ? Icons.radio_button_unchecked
                      : Icons.block,
              color: isSelected
                  ? AppColors.primary
                  : isAvailable
                      ? AppColors.textSecondary
                      : Colors.grey,
            ),
            title: Text(
              slot,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isAvailable ? AppColors.textPrimary : Colors.grey,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isAvailable ? '$remaining Slots Left' : 'Full (Unavailable)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                ),
              ),
            ),
            onTap: isAvailable ? () => setState(() => _slot = slot) : null,
          ),
        );
      },
    );
  }

  Widget _stepHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 4),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      );
}