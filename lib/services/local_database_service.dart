import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/booking_model.dart';
import '../models/centre_model.dart';
import '../models/notification.dart';
import '../models/user_model.dart';

class IsarDatabaseService {
  static late Isar _db;

  static Isar get isar => _db;
  Isar get db => _db;

  static Future<void> initialize() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      _db = await Isar.open(
        [
          BookingModelSchema,
          UserModelSchema,
          NotificationModelSchema,
        ],
        directory: dir.path,
      );
    } else {
      _db = Isar.getInstance()!;
    }
  }

  // --- USER LOOKUP METHODS ---
  Future<UserModel?> findOfficerById(String officerId) async {
    return await _db.userModels
        .filter()
        .officerIdEqualTo(officerId)
        .findFirst();
  }

  Future<UserModel?> findUserByUid(String uid) async {
    return await _db.userModels.filter().uidEqualTo(uid).findFirst();
  }

  Future<UserModel?> findFarmerByIdentity(String identity) async {
    final clean = identity.trim();
    return await _db.userModels
        .filter()
        .phoneNumberEqualTo(clean)
        .or()
        .farmerIdEqualTo(clean)
        .findFirst();
  }

  Future<String?> findPhoneNumber(String identifier) async {
    final user = await _db.userModels
        .filter()
        .farmerIdEqualTo(identifier)
        .or()
        .officerIdEqualTo(identifier)
        .or()
        .phoneNumberEqualTo(identifier)
        .findFirst();
    return user?.phoneNumber;
  }

  Future<void> saveUser(UserModel user) async {
    await _db.writeTxn(() async {
      await _db.userModels.put(user);
    });
  }

  // --- BOOKING QUERY METHODS ---
  Future<void> saveBooking(BookingModel booking) async {
    await _db.writeTxn(() async {
      await _db.bookingModels.put(booking);
    });
  }

  Future<List<BookingModel>> allBookings() async {
    return await _db.bookingModels.where().findAll();
  }

  Future<List<BookingModel>> farmerBookings(String farmerId) async {
    return await _db.bookingModels
        .filter()
        .farmerIdEqualTo(farmerId)
        .findAll();
  }

  Future<List<BookingModel>> activeBookingsForFarmer(String farmerId) async {
    final list = await farmerBookings(farmerId);
    return list.where((b) {
      final s = b.status.toLowerCase();
      return !s.contains('completed') &&
          !s.contains('rejected') &&
          !s.contains('declined') &&
          !s.contains('cancelled');
    }).toList();
  }

  Future<List<BookingModel>> bookingsForCentre(String centreId) async {
    return await _db.bookingModels
        .filter()
        .centreIdEqualTo(centreId)
        .findAll();
  }

  Future<BookingModel?> bookingByToken(String token) async {
    return await _db.bookingModels.filter().tokenEqualTo(token).findFirst();
  }

  // --- LOCATION & CENTRE METADATA ---
  Future<List<String>> states() async {
    return const ['Madhya Pradesh', 'Punjab', 'Haryana'];
  }

  Future<List<String>> districts(String state) async {
    if (state == 'Madhya Pradesh') return const ['Shivpuri', 'Gwalior', 'Indore'];
    if (state == 'Punjab') return const ['Ludhiana', 'Amritsar', 'Patiala'];
    return const ['Karnal', 'Ambala', 'Hisar'];
  }

Future<List<CentreModel>> centresByDistrict(String state, [String? district]) async {
    final d = district ?? state;
    return [
      CentreModel(
        centreId: 'CTR_SHIV_01',
        centreName: 'Shivpuri Procurement Center',
        district: d,
        state: state,
        capacity: 500,
      ),
      CentreModel(
        centreId: 'CTR_KOL_02',
        centreName: 'Kolaras Krishi Mandi',
        district: d,
        state: state,
        capacity: 400,
      ),
      CentreModel(
        centreId: 'CTR_POH_03',
        centreName: 'Pohari Grain Procurement Hub',
        district: d,
        state: state,
        capacity: 350,
      ),
    ];
  }
Future<Map<String, dynamic>> getLiveQueueSnapshot({
    required String centreId,
    required String userToken,
  }) async {
    final activeList = await _db.bookingModels
        .filter()
        .centreIdEqualTo(centreId)
        .and()
        .group((q) => q
            .statusEqualTo('Slot Booked')
            .or()
            .statusEqualTo('Arrived at Center')
            .or()
            .statusEqualTo('Under Inspection'))
        .sortByCreatedAt()
        .findAll();

    final currentServing = activeList.isNotEmpty ? activeList.first.token : 'None';
    final userIndex = activeList.indexWhere((b) => b.token.toUpperCase() == userToken.toUpperCase());

    final int tokensAhead = userIndex > 0 ? userIndex : 0;
    final int estimatedMinutes = tokensAhead * 12; // ~12 mins average per vehicle

    return {
      'currentServingToken': currentServing,
      'tokensAhead': tokensAhead,
      'estimatedMinutes': estimatedMinutes,
    };
  }
  Future<CentreModel?> findCentreById(String centreId) async {
    final list = await centresByDistrict('Madhya Pradesh', 'Shivpuri');
    try {
      return list.firstWhere((c) => c.centreId.toString() == centreId.toString());
    } catch (_) {
      return null;
    }
  }

  // Helper to extract centre identifier string safely
  String _extractCentreId(dynamic centreOrId) {
    if (centreOrId == null) return 'CTR_SHIV_01';
    if (centreOrId is String) return centreOrId;
    if (centreOrId is int) return centreOrId.toString();
    try {
      return (centreOrId as dynamic).centreId?.toString() ??
          (centreOrId as dynamic).id?.toString() ??
          'CTR_SHIV_01';
    } catch (_) {
      return 'CTR_SHIV_01';
    }
  }

  // --- SLOT CHECKS & TOKEN SEQUENCING ---
  Future<bool> isSlotAvailable({
    dynamic centre,
    dynamic centreId,
    DateTime? date,
    DateTime? bookingDate,
    required String slotTime,
    int maxCapacity = 5,
  }) async {
    final effectiveId = _extractCentreId(centre ?? centreId);
    final effectiveDate = date ?? bookingDate ?? DateTime.now();

    final count = await bookedCount(
      centre: effectiveId,
      date: effectiveDate,
      slotTime: slotTime,
    );
    return count < maxCapacity;
  }

  Future<int> bookedCount({
    dynamic centre,
    dynamic centreId,
    DateTime? date,
    DateTime? bookingDate,
    required String slotTime,
  }) async {
    final effectiveId = _extractCentreId(centre ?? centreId);
    final effectiveDate = date ?? bookingDate ?? DateTime.now();

    return await getSlotBookingCount(
      centreId: effectiveId,
      bookingDate: effectiveDate,
      slotTime: slotTime,
    );
  }

  Future<int> getSlotBookingCount({
    required String centreId,
    required DateTime bookingDate,
    required String slotTime,
  }) async {
    final startOfDay = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
    final endOfDay = DateTime(bookingDate.year, bookingDate.month, bookingDate.day, 23, 59, 59);

    return await _db.bookingModels
        .filter()
        .centreIdEqualTo(centreId)
        .bookingDateBetween(startOfDay, endOfDay)
        .slotTimeEqualTo(slotTime)
        .count();
  }

  Future<bool> hasDuplicateFarmerBooking({
    required String farmerId,
    required DateTime bookingDate,
    required String slotTime,
  }) async {
    final startOfDay = DateTime(bookingDate.year, bookingDate.month, bookingDate.day);
    final endOfDay = DateTime(bookingDate.year, bookingDate.month, bookingDate.day, 23, 59, 59);

    final list = await _db.bookingModels
        .filter()
        .farmerIdEqualTo(farmerId)
        .bookingDateBetween(startOfDay, endOfDay)
        .slotTimeEqualTo(slotTime)
        .findAll();

    return list.any((b) =>
        b.status != 'Inspection Rejected' &&
        b.status != 'Deal Declined by Farmer' &&
        b.status != 'Cancelled by Farmer');
  }

  // Accepts both named arguments (centreId:, date:) and optional positional parameters
Future<String> generateNextSequentialToken({
    dynamic centreId,
    dynamic centre,
    dynamic date,
  }) async {
    final count = await _db.bookingModels.where().count();
    final number = 1001 + count;
    return 'KST-$number';
  }

  // Intercepts named calls: generateNextSequentialToken(centreId: ..., date: ...)
  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #generateNextSequentialToken) {
      return (() async {
        final count = await _db.bookingModels.where().count();
        final number = 1001 + count;
        return 'KST-$number';
      })();
    }
    return super.noSuchMethod(invocation);
  }

  Future<int> queuePosition(dynamic arg) async {
    String token = '';
    if (arg is BookingModel) {
      token = arg.token;
    } else if (arg is String) {
      token = arg;
    }

    final active = await _db.bookingModels
        .filter()
        .statusEqualTo('Slot Booked')
        .or()
        .statusEqualTo('Arrived at Center')
        .sortByCreatedAt()
        .findAll();

    final idx = active.indexWhere((b) => b.token == token);
    return idx >= 0 ? idx + 1 : 1;
  }

  // --- NOTIFICATIONS ---
  Future<List<NotificationModel>> userNotifications(String userId) async {
    return await _db.notificationModels
        .filter()
        .userIdEqualTo(userId)
        .sortByCreatedAtDesc()
        .findAll();
  }

  Future<void> saveNotification(NotificationModel notification) async {
    await _db.writeTxn(() async {
      await _db.notificationModels.put(notification);
    });
  }
}