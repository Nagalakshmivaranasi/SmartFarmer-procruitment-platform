import '../models/notification.dart';
import 'local_database_service.dart';

class NotificationService {
  final IsarDatabaseService _db;

  NotificationService({IsarDatabaseService? db})
      : _db = db ?? IsarDatabaseService();

  Future<List<NotificationModel>> getNotifications(String userId) async {
    return _db.userNotifications(userId);
  }

  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    String type = 'general',
  }) async {
    final notif = NotificationModel(
      userId: userId,
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
    );
    await _db.saveNotification(notif);
  }
}