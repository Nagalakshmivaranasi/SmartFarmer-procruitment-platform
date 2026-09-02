import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/booking_model.dart';
import '../../../models/centre_model.dart';
import '../../../services/local_database_service.dart';

class RescheduleBookingScreen extends StatefulWidget {
  final BookingModel booking;

  const RescheduleBookingScreen({super.key, required this.booking});

  @override
  State<RescheduleBookingScreen> createState() => _RescheduleBookingScreenState();
}

class _RescheduleBookingScreenState extends State<RescheduleBookingScreen> {
  final _database = IsarDatabaseService();
  late DateTime _date;
  late Future<CentreModel?> _centreFuture;
  String? _slot;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _date = widget.booking.bookingDate;
    _centreFuture = _database.findCentreById(widget.booking.centreId);
  }

  List<String> _slots() {
    String label(int minutes) {
      final hour = minutes ~/ 60;
      final suffix = hour >= 12 ? 'PM' : 'AM';
      final display = hour % 12 == 0 ? 12 : hour % 12;
      return '${display.toString().padLeft(2, '0')}:${(minutes % 60).toString().padLeft(2, '0')} $suffix';
    }
    return [for (var minutes = 420; minutes < 1140; minutes += 30) '${label(minutes)} - ${label(minutes + 30)}'];
  }

  Future<void> _save() async {
    if (_slot == null) return;
    setState(() => _saving = true);
    widget.booking.bookingDate = DateTime(_date.year, _date.month, _date.day);
    widget.booking.slotTime = _slot!;
    widget.booking.status = 'Rescheduled';
    await _database.saveBooking(widget.booking);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Reschedule Booking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CalendarDatePicker(
            initialDate: _date.isBefore(DateTime.now()) ? DateTime.now() : _date,
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            onDateChanged: (date) => setState(() { _date = date; _slot = null; }),
          ),
          const Text('Select New Time', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ..._slots().map((slot) => FutureBuilder<bool>(
                future: _centreFuture.then((centre) => centre == null
                    ? false
                    : _database.isSlotAvailable(
                        centre: centre,
                        date: _date,
                        slotTime: slot,
                      )),
                builder: (context, snapshot) {
                  final available = snapshot.data ?? false;
                  return ListTile(
                    enabled: available,
                    selected: _slot == slot,
                    title: Text(slot),
                    trailing: Text(available ? (_slot == slot ? 'Selected' : 'Available') : 'Full'),
                    onTap: available ? () => setState(() => _slot = slot) : null,
                  );
                },
              )),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _saving || _slot == null ? null : _save,
            child: _saving ? const CircularProgressIndicator() : const Text('Confirm Reschedule'),
          ),
        ],
      ),
    );
  }

}
