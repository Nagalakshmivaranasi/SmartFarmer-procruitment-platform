import 'package:isar/isar.dart';
import 'package:smart_farmer_procurement/models/queue.dart';
import 'package:smart_farmer_procurement/models/booking_model.dart';
import 'local_database_service.dart';

class QueueService {
  final IsarDatabaseService _database;

  QueueService({IsarDatabaseService? database}) : _database = database ?? IsarDatabaseService();

  Stream<CenterQueue> streamCenterQueue(String centreId) =>
      IsarDatabaseService.isar.bookingModels.filter().centreIdEqualTo(centreId).findAll().asStream().map((bookings) {
        final items = bookings.map((booking) => QueueItem(tokenNumber: booking.token, farmerId: booking.farmerId, status: QueueTokenStatus.active, createdAt: booking.createdAt)).toList();
        return CenterQueue(centerId: centreId, currentTokenNumber: items.isEmpty ? 0 : int.tryParse(items.first.tokenNumber) ?? 0, items: items);
      });

  Future<void> advanceToken({required String centreId, required int nextTokenNumber}) async {}

  Future<void> updateTokenStatus({required String centreId, required String tokenNumber, required String newStatus}) async {
    final booking = await _database.bookingByToken(tokenNumber);
    if (booking == null) return;
    booking.status = newStatus;
    await _database.saveBooking(booking);
  }
}
