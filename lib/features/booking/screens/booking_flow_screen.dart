import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/centre_model.dart';
import '../../../models/booking_model.dart';
import '../../../services/session_service.dart';
import '../../../services/local_database_service.dart';
import 'booking_confirmed_screen.dart';

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
    for (var minutes = 7 * 60; minutes < 19 * 60; minutes += 30) {
      final start = _timeLabel(minutes);
      final end = _timeLabel(minutes + 30);
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
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Complete all booking selections.')));
      return;
    }
    setState(() => _saving = true);
    final token = '${DateTime.now().millisecondsSinceEpoch}${Random().nextInt(900)}';
    final booking = BookingModel(
      bookingId: 'booking_$token',
      farmerId: user.farmerId ?? user.uid,
      farmerName: user.name,
      centreId: _centre!.centreId,
      centreName: _centre!.centreName,
      crop: widget.crop,
      quantityQuintal: widget.quantityQuintal,
      bookingDate: DateTime(_date.year, _date.month, _date.day),
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
      appBar: AppBar(title: const Text('Book Slot')),
      body: FutureBuilder<List<String>>(
        future: _statesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final states = snapshot.data ?? [];
          if (states.isEmpty) {
            return const Center(child: Text('No procurement centres available.'));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _stepTitle('1. Select State'),
              DropdownButtonFormField<String>(
                initialValue: _state,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.map_outlined)),
                items: states.map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                onChanged: (value) async {
                  setState(() { _state = value; _district = null; _centre = null; _slot = null; });
                },
              ),
              const SizedBox(height: 18),
              if (_state != null) ...[
                _stepTitle('2. Select District'),
                FutureBuilder<List<String>>(
                  future: _database.districts(_state!),
                  builder: (context, districtSnapshot) => DropdownButtonFormField<String>(
                    initialValue: _district,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.location_city_outlined)),
                    items: (districtSnapshot.data ?? []).map((value) => DropdownMenuItem(value: value, child: Text(value))).toList(),
                    onChanged: (value) => setState(() { _district = value; _centre = null; _slot = null; }),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (_district != null) ...[
                _stepTitle('3. Select Procurement Centre'),
                FutureBuilder<List<CentreModel>>(
                  future: _database.centresByDistrict(_state!, _district!),
                  builder: (context, centreSnapshot) => DropdownButtonFormField<CentreModel>(
                    initialValue: _centre,
                    decoration: const InputDecoration(prefixIcon: Icon(Icons.storefront_outlined)),
                    items: (centreSnapshot.data ?? []).map((centre) => DropdownMenuItem(value: centre, child: Text(centre.centreName))).toList(),
                    onChanged: (value) => setState(() { _centre = value; _slot = null; }),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              if (_centre != null) ...[
                _stepTitle('4. Select Date'),
                CalendarDatePicker(
                  initialDate: _date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 90)),
                  onDateChanged: (value) => setState(() { _date = value; _slot = null; }),
                ),
                _stepTitle('5. Select Time Slot'),
                ..._slots().map((slot) => _slotTile(slot)),
              ],
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _saving || _slot == null ? null : _saveBooking,
                child: _saving ? const CircularProgressIndicator() : const Text('Confirm Booking'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _slotTile(String slot) {
    return FutureBuilder<bool>(
      future: _database.isSlotAvailable(centre: _centre!, date: _date, slotTime: slot),
      builder: (context, snapshot) {
        final available = snapshot.data ?? false;
        final selected = _slot == slot;
        return ListTile(
          enabled: available,
          title: Text(slot),
          trailing: Text(selected ? 'Selected' : available ? 'Available' : 'Full'),
          selected: selected,
          selectedColor: AppColors.primary,
          onTap: available ? () => setState(() => _slot = slot) : null,
        );
      },
    );
  }

  Widget _stepTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      );
}
