import 'package:url_launcher/url_launcher.dart';
import '../models/booking_model.dart';
import '../models/notification.dart';
import 'local_database_service.dart';

class LocalNotificationService {
  final _database = IsarDatabaseService();

  Future<void> notifyBookingSuccess(BookingModel booking) async {
    final notification = NotificationModel(
      userId: booking.farmerId,
      title: 'Slot Booked Successfully',
      body: 'Your slot for ${booking.crop} at ${booking.centreName} is confirmed for ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year} ${booking.slotTime}. Token #${booking.token}.',
      type: 'bookingConfirmed',
      createdAt: DateTime.now(),
      bookingId: booking.bookingId,
    );
    await _database.saveNotification(notification);
  }

  Future<void> notifyDelay(BookingModel booking) async {
    final notification = NotificationModel(
      userId: booking.farmerId,
      title: 'Procurement Delay',
      body: 'Your slot at ${booking.centreName} is delayed by 20 minutes.',
      type: 'delayWarning',
      createdAt: DateTime.now(),
      bookingId: booking.bookingId,
    );
    await _database.saveNotification(notification);
    final phone = await _database.findPhoneNumber(booking.farmerId);
    if (phone == null || phone.isEmpty) return;
    final uri = Uri(
      scheme: 'sms',
      path: phone.startsWith('+') ? phone : '+91$phone',
      queryParameters: {'body': notification.body},
    );
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
