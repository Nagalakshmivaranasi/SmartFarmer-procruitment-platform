import 'package:isar/isar.dart';
part 'notification.g.dart';

@collection
class NotificationModel {
  Id id = Isar.autoIncrement;
  String userId;
  String title;
  String body;
  String type;
  DateTime createdAt;
  bool isRead;
  String? bookingId;

  NotificationModel({
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
    this.bookingId,
  });
}
