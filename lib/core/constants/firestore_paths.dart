class FirestorePaths {
  static const String users = 'users';
  static const String centres = 'procurement_centres';
  static const String bookings = 'bookings';
  static const String queues = 'queues';
  static const String notifications = 'notifications';

  static String bookingDoc(String id) => '$bookings/$id';
  static String queueDoc(String centerId) => '$queues/$centerId';
  static String userNotifications(String userId) => '$users/$userId/$notifications';
}