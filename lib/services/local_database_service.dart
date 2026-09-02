import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/booking_model.dart';
import '../models/centre_model.dart';
import '../models/notification.dart';
import '../models/user_model.dart';

class IsarDatabaseService {
  static late Isar isar;

  static Future<void> initialize() async {
    if (Isar.instanceNames.isNotEmpty) {
      isar = Isar.getInstance()!;
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [
        UserModelSchema,
        BookingModelSchema,
        CentreModelSchema,
        NotificationModelSchema,
      ],
      directory: dir.path,
    );
  }

  Future<UserModel?> findUserByUid(String uid) => isar.userModels.getByUid(uid);

  Future<void> saveUser(UserModel user) async =>
      isar.writeTxn(() => isar.userModels.put(user));

  Future<List<CentreModel>> centresByState(String state) => isar.centreModels
      .filter()
      .stateEqualTo(state)
      .sortByCentreName()
      .findAll();

  Future<List<CentreModel>> centresByDistrict(String state, String district) =>
      isar.centreModels
          .filter()
          .stateEqualTo(state)
          .districtEqualTo(district)
          .sortByCentreName()
          .findAll();

  Future<List<String>> states() async {
    final values = (await isar.centreModels.where().findAll())
        .map((centre) => centre.state)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  Future<List<String>> districts(String state) async {
    final values = (await centresByState(state))
        .map((centre) => centre.district)
        .toSet()
        .toList();
    values.sort();
    return values;
  }

  Future<List<BookingModel>> bookingsForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    return isar.bookingModels
        .filter()
        .bookingDateBetween(start, start.add(const Duration(days: 1)))
        .findAll();
  }

  Future<List<BookingModel>> todaysBookings() => bookingsForDate(DateTime.now());

  Future<List<BookingModel>> allBookings() =>
      isar.bookingModels.where().sortByBookingDate().findAll();

  Future<List<BookingModel>> bookingsForCentre(String centreId) => isar.bookingModels
      .filter()
      .centreIdEqualTo(centreId)
      .sortByBookingDate()
      .findAll();

  Future<List<BookingModel>> activeBookingsForFarmer(String farmerId) async {
    final bookings = await farmerBookings(farmerId);
    final today = DateTime.now();
    return bookings.where((booking) =>
        booking.bookingDate.year == today.year &&
        booking.bookingDate.month == today.month &&
        booking.bookingDate.day == today.day &&
        booking.status != 'Completed').toList();
  }

  Future<int> queuePosition(BookingModel booking) async {
    final bookings = await bookingsForDate(booking.bookingDate);
    final sameSlot = bookings.where((item) =>
        item.centreId == booking.centreId &&
        item.slotTime == booking.slotTime &&
        item.status != 'Completed').toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final index = sameSlot.indexWhere((item) => item.id == booking.id);
    return index < 0 ? 0 : index + 1;
  }

  Future<List<BookingModel>> farmerBookings(String farmerId) => isar.bookingModels
      .filter()
      .farmerIdEqualTo(farmerId)
      .sortByBookingDate()
      .findAll();

  Future<BookingModel?> bookingByToken(String token) => isar.bookingModels.getByToken(token);

  Future<void> saveBooking(BookingModel booking) async =>
      isar.writeTxn(() => isar.bookingModels.put(booking));

  Future<void> saveCentre(CentreModel centre) async =>
      isar.writeTxn(() => isar.centreModels.put(centre));

    Future<void> saveNotification(NotificationModel notification) async =>
      isar.writeTxn(() => isar.notificationModels.put(notification));

    Future<List<NotificationModel>> userNotifications(String userId) =>
      isar.notificationModels
        .filter()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .findAll();

    Future<String?> findPhoneNumber(String farmerId) async {
    final user = await isar.userModels
      .filter()
      .farmerIdEqualTo(farmerId)
      .findFirst();
    return user?.phoneNumber;
    }

    Future<CentreModel?> findCentreById(String centreId) =>
      isar.centreModels.getByCentreId(centreId);

  Future<int> bookedCount({
    required String centreId,
    required DateTime date,
    required String slotTime,
  }) async {
    final start = DateTime(date.year, date.month, date.day);
    final bookings = await isar.bookingModels
        .filter()
        .centreIdEqualTo(centreId)
        .bookingDateBetween(start, start.add(const Duration(days: 1)))
        .slotTimeEqualTo(slotTime)
      .findAll();
    return bookings.where((booking) => booking.status != 'Completed').length;
  }

  Future<bool> isSlotAvailable({
    required CentreModel centre,
    required DateTime date,
    required String slotTime,
  }) async {
    final count = await bookedCount(
      centreId: centre.centreId,
      date: date,
      slotTime: slotTime,
    );
    return count < centre.capacity;
  }
}

typedef LocalDatabaseService = IsarDatabaseService;