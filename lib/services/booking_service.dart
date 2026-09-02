import 'package:isar/isar.dart';
import 'package:smart_farmer_procurement/models/booking_model.dart';
import 'local_database_service.dart';

class BookingService {
  final IsarDatabaseService _database;

  BookingService({IsarDatabaseService? database}) : _database = database ?? IsarDatabaseService();

  Future<String> createBooking({
    required String farmerId,
    required String farmerName,
    required String centreId,
    required String centreName,
    required String crop,
    required double quantityQuintal,
    required String bookingDate,
    required String slotTime,
    required int tokenNumber,
  }) async {
    final token = tokenNumber.toString();
    final booking = BookingModel(
      bookingId: 'booking_$token',
      farmerId: farmerId,
      farmerName: farmerName,
      centreId: centreId,
      centreName: centreName,
      crop: crop,
      quantityQuintal: quantityQuintal,
      bookingDate: DateTime.tryParse(bookingDate) ?? DateTime.now(),
      slotTime: slotTime,
      token: token,
      status: 'Pending',
      createdAt: DateTime.now(),
    );
    await _database.saveBooking(booking);
    return booking.bookingId;
  }

  Stream<List<BookingModel>> getFarmerBookings(String farmerId) =>
      IsarDatabaseService.isar.bookingModels.filter().farmerIdEqualTo(farmerId).findAll().asStream();

  Future<void> rescheduleBooking({required String bookingId, required String newDate, required String newSlotTime}) async {
    final booking = await IsarDatabaseService.isar.bookingModels.getByBookingId(bookingId);
    if (booking == null) return;
    booking.bookingDate = DateTime.tryParse(newDate) ?? booking.bookingDate;
    booking.slotTime = newSlotTime;
    booking.status = 'Rescheduled';
    await _database.saveBooking(booking);
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    final booking = await IsarDatabaseService.isar.bookingModels.getByBookingId(bookingId);
    if (booking == null) return;
    booking.status = newStatus;
    await _database.saveBooking(booking);
  }
}
