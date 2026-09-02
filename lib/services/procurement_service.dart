import 'package:smart_farmer_procurement/models/procurement_inspection_model.dart';
import 'package:smart_farmer_procurement/models/booking_model.dart';
import 'local_database_service.dart';

class ProcurementService {
  final IsarDatabaseService _database;

  ProcurementService({IsarDatabaseService? database}) : _database = database ?? IsarDatabaseService();

  Future<void> saveInspectionAndOffer(ProcurementInspectionModel inspection) async {
    final booking = await IsarDatabaseService.isar.bookingModels.getByBookingId(inspection.bookingId);
    if (booking == null) return;
    booking.status = 'Deal Offered';
    await _database.saveBooking(booking);
  }

  Stream<ProcurementInspectionModel?> streamInspectionReport(String bookingId) =>
      Stream.value(null);

  Future<void> processPayment({required String bookingId, required String txnId}) async {
    final booking = await IsarDatabaseService.isar.bookingModels.getByBookingId(bookingId);
    if (booking == null) return;
    booking.paymentStatus = 'Paid';
    booking.status = 'Completed';
    await _database.saveBooking(booking);
  }
}
