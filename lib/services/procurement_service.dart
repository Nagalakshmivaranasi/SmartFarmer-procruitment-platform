import 'package:smart_farmer_procurement/models/procurement_inspection_model.dart';
import 'package:smart_farmer_procurement/models/booking_model.dart';
import 'local_database_service.dart';
import 'notification_service.dart';

class ProcurementService {
  final IsarDatabaseService _database;

  ProcurementService({IsarDatabaseService? database})
      : _database = database ?? IsarDatabaseService();

  Future<void> saveInspectionAndOffer(ProcurementInspectionModel inspection) async {
    final booking = await IsarDatabaseService.isar.bookingModels.getByBookingId(inspection.bookingId);
    if (booking == null) return;

    booking.status = 'Deal Offered';
    await _database.saveBooking(booking);
  }

  Stream<ProcurementInspectionModel?> streamInspectionReport(String bookingId) =>
      Stream.value(null);

  Future<double> processPayment({
    required String bookingId,
    required String txnId,
  }) async {
    final booking = await IsarDatabaseService.isar.bookingModels.getByBookingId(bookingId);
    if (booking == null) return 0.0;

    // 1. Determine effective rate per quintal
    final double baseMsp = (booking.baseMspRate != null && booking.baseMspRate! > 0)
        ? booking.baseMspRate!
        : 2275.0;

    final double effectiveRate = (booking.finalRatePerQuintal != null && booking.finalRatePerQuintal! > 0)
        ? booking.finalRatePerQuintal!
        : baseMsp;

    // 2. Ensure netPayableAmount is accurately calculated
    final double calculatedTotal = (booking.netPayableAmount != null && booking.netPayableAmount! > 0)
        ? booking.netPayableAmount!
        : (effectiveRate * (booking.quantityQuintal > 0 ? booking.quantityQuintal : 1.0));

    // 3. Persist exact financial state into DB
    booking.finalRatePerQuintal = effectiveRate;
    booking.netPayableAmount = calculatedTotal;
    booking.paymentStatus = 'Payment Successful (DBT Paid)';
    booking.status = 'Procurement Completed';

    await _database.saveBooking(booking);

    // 4. Send notification with the real disbursed rupee amount
    try {
      final notificationService = NotificationService();
      await notificationService.createNotification(
        userId: booking.farmerId,
        title: 'DBT Payment Dispatched',
        body: '₹ ${calculatedTotal.toStringAsFixed(2)} has been transferred via DBT (Ref: $txnId) for Token ${booking.token}.',
        type: 'payment_success',
      );
    } catch (_) {
      // Notification failure should not fail database persistence
    }

    return calculatedTotal;
  }
}