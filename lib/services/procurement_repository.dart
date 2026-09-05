import 'package:flutter/foundation.dart';
import '../models/core_models.dart';

class ProcurementRepository extends ChangeNotifier {
  final List<ProcurementCenter> _centers = [
    ProcurementCenter(
      id: 'CTR_SHIV_01',
      name: 'Shivpuri Procurement Center',
      state: 'Madhya Pradesh',
      district: 'Shivpuri',
      distanceKm: 5.2,
    ),
    ProcurementCenter(
      id: 'CTR_PICH_02',
      name: 'Pichhore Procurement Center',
      state: 'Madhya Pradesh',
      district: 'Shivpuri',
      distanceKm: 12.8,
    ),
    ProcurementCenter(
      id: 'CTR_KOL_03',
      name: 'Kolaras Procurement Center',
      state: 'Madhya Pradesh',
      district: 'Shivpuri',
      distanceKm: 18.4,
    ),
    ProcurementCenter(
      id: 'CTR_KAR_04',
      name: 'Karera Procurement Center',
      state: 'Madhya Pradesh',
      district: 'Shivpuri',
      distanceKm: 22.7,
    ),
  ];

  final List<AppUser> _users = [];
  final List<SlotBooking> _bookings = [];
  AppUser? _currentUser;

  List<ProcurementCenter> get centers => _centers;
  AppUser? get currentUser => _currentUser;
  List<SlotBooking> get allBookings => _bookings;

  void setCurrentUser(AppUser user) {
    _currentUser = user;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  List<String> getAvailableStates() =>
      _centers.map((c) => c.state).toSet().toList();

  List<String> getDistrictsForState(String state) => _centers
      .where((c) => c.state == state)
      .map((c) => c.district)
      .toSet()
      .toList();

  List<ProcurementCenter> getCentersForDistrict(String state, String district) =>
      _centers.where((c) => c.state == state && c.district == district).toList();

  ProcurementCenter? getCenterById(String centerId) {
    try {
      return _centers.firstWhere((c) => c.id == centerId);
    } catch (_) {
      return null;
    }
  }

  Future<AppUser> registerUser({
    required String fullName,
    required String phoneNumber,
    required UserRole role,
    String? aadhaarNumber,
    String? officerId,
    String? assignedCenterId,
    required String state,
    required String district,
  }) async {
    final newUser = AppUser(
      uid: 'USR_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      phoneNumber: phoneNumber,
      role: role,
      aadhaarNumber: aadhaarNumber,
      officerId: officerId,
      assignedCenterId: assignedCenterId,
      state: state,
      district: district,
    );
    _users.add(newUser);
    _currentUser = newUser;
    notifyListeners();
    return newUser;
  }

  Future<SlotBooking> createSlotBooking({
    required String cropName,
    required String season,
    required double estimatedQuantityQuintal,
    required String state,
    required String district,
    required String centerId,
    required DateTime bookingDate,
    required String timeSlot,
  }) async {
    final center = getCenterById(centerId)!;
    final tokenSequence =
        _bookings.where((b) => b.centerId == centerId).length + 1;
    final generatedToken = '#$tokenSequence';

    final booking = SlotBooking(
      id: 'BKG_${DateTime.now().millisecondsSinceEpoch}',
      tokenNumber: generatedToken,
      farmerId: _currentUser?.uid ?? 'FMR_DEMO',
      farmerName: _currentUser?.fullName ?? 'Farmer',
      farmerPhone: _currentUser?.phoneNumber ?? '',
      farmerAadhaarMasked: '[Aadhaar Redacted]',
      cropName: cropName,
      season: season,
      estimatedQuantityQuintal: estimatedQuantityQuintal,
      state: state,
      district: district,
      centerId: center.id,
      centerName: center.name,
      bookingDate: bookingDate,
      timeSlot: timeSlot,
      createdAt: DateTime.now(),
    );

    _bookings.add(booking);
    notifyListeners();
    return booking;
  }

  List<SlotBooking> getBookingsForCurrentOfficer() {
    if (_currentUser == null || _currentUser!.role != UserRole.officer) return [];
    return _bookings
        .where((b) => b.centerId == _currentUser!.assignedCenterId)
        .toList();
  }

  List<SlotBooking> getBookingsForCurrentFarmer() {
    if (_currentUser == null || _currentUser!.role != UserRole.farmer) return [];
    return _bookings.where((b) => b.farmerId == _currentUser!.uid).toList();
  }

  void updateBookingStatus(String bookingId, BookingStatus newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].status = newStatus;
      notifyListeners();
    }
  }

  void updateWeighment(String bookingId, double gross, double tare) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].grossWeightKg = gross;
      _bookings[index].tareWeightKg = tare;
      notifyListeners();
    }
  }

  void updateQualityAndDeal(
      String bookingId, QualityParameters params, double offeredRate) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].quality = params;
      _bookings[index].offeredRatePerQuintal = offeredRate;
      final netQuintal = _bookings[index].netWeightKg / 100;
      _bookings[index].totalPayout = (netQuintal > 0
              ? netQuintal
              : _bookings[index].estimatedQuantityQuintal) *
          offeredRate;
      notifyListeners();
    }
  }
}