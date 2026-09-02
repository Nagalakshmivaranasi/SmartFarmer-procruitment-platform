import 'package:smart_farmer_procurement/features/smart_arrival/services/eta_service.dart';
import 'package:smart_farmer_procurement/models/notification.dart';
import 'package:smart_farmer_procurement/models/notification_legacy.dart';
import 'local_database_service.dart';

class NotificationService {
  final IsarDatabaseService _database;
  DateTime? _lastNotifiedServiceTime;
  int? _lastNotifiedFarmersAhead;
  bool _departureNotified = false;

  NotificationService({IsarDatabaseService? database}) : _database = database ?? IsarDatabaseService();

  Stream<List<AppNotification>> getUserNotifications(String userId) =>
      Stream.fromFuture(_database.userNotifications(userId)).map((items) => items.map((item) => AppNotification(
        id: item.id.toString(), userId: item.userId, title: item.title, body: item.body,
        type: NotificationType.values.firstWhere((type) => type.name == item.type, orElse: () => NotificationType.general),
        createdAt: item.createdAt, isRead: item.isRead,
      )).toList());

  Future<void> sendNotification({required String userId, required String title, required String body, required NotificationType type, Map<String, dynamic>? metadata}) async {
    await _database.saveNotification(NotificationModel(userId: userId, title: title, body: body, type: type.name, createdAt: DateTime.now()));
  }

  Future<void> evaluateAndNotifyArrivalUpdate({required String userId, required EtaCalculationResult result, required bool isBookingActive}) async {
    if (!isBookingActive) return;
    final now = DateTime.now();
    if (!_departureNotified && !now.isBefore(result.recommendedDepartureTime)) {
      _departureNotified = true;
      await sendNotification(userId: userId, title: 'It is time to leave', body: 'Your procurement token is #${result.farmerToken}.', type: NotificationType.departureTime);
    }
    if (result.farmersAhead <= 2 && (_lastNotifiedFarmersAhead == null || _lastNotifiedFarmersAhead! > 2)) {
      _lastNotifiedFarmersAhead = result.farmersAhead;
      await sendNotification(userId: userId, title: 'Your token is approaching', body: 'You are ${result.farmersAhead} farmer(s) away.', type: NotificationType.queueApproaching);
    }
    if (_lastNotifiedServiceTime != null && result.expectedServiceTime.difference(_lastNotifiedServiceTime!).inMinutes.abs() >= 15) {
      final delayed = result.expectedServiceTime.isAfter(_lastNotifiedServiceTime!);
      await sendNotification(userId: userId, title: delayed ? 'Procurement is delayed' : 'ETA Updated', body: 'Expected service time: ${_formatTime(result.expectedServiceTime)}.', type: delayed ? NotificationType.delayWarning : NotificationType.etaUpdate);
    }
    _lastNotifiedServiceTime = result.expectedServiceTime;
  }

  String _formatTime(DateTime value) => '${value.hour % 12 == 0 ? 12 : value.hour % 12}:${value.minute.toString().padLeft(2, '0')} ${value.hour >= 12 ? 'PM' : 'AM'}';
}
