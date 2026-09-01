import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farmer_procurement/core/constants/firestore_paths.dart';
import 'package:smart_farmer_procurement/models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore;

  BookingService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Create slot booking (Screens 7-12)
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
    final docRef = _firestore.collection(FirestorePaths.bookings).doc();

    final booking = BookingModel(
      bookingId: docRef.id,
      farmerId: farmerId,
      farmerName: farmerName,
      centreId: centreId,
      centreName: centreName,
      crop: crop,
      quantityQuintal: quantityQuintal,
      bookingDate: bookingDate,
      slotTime: slotTime,
      tokenNumber: tokenNumber,
      status: 'booked',
      createdAt: DateTime.now(),
    );

    await docRef.set(booking.toMap());
    return docRef.id;
  }

  // Stream active bookings for a farmer (Screen 13)
  Stream<List<BookingModel>> getFarmerBookings(String farmerId) {
    return _firestore
        .collection(FirestorePaths.bookings)
        .where('farmerId', isEqualTo: farmerId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => BookingModel.fromMap(doc.data(), doc.id))
            .toList());
  }

  // Reschedule slot (Screen 14)
  Future<void> rescheduleBooking({
    required String bookingId,
    required String newDate,
    required String newSlotTime,
  }) async {
    await _firestore.collection(FirestorePaths.bookings).doc(bookingId).update({
      'bookingDate': newDate,
      'slotTime': newSlotTime,
      'status': 'rescheduled',
    });
  }

  // Update booking status (Screens 15, Officer Flow 5-10)
  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    await _firestore.collection(FirestorePaths.bookings).doc(bookingId).update({
      'status': newStatus,
    });
  }
}