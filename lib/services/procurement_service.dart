import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farmer_procurement/models/procurement_inspection_model.dart';

class ProcurementService {
  final FirebaseFirestore _firestore;

  ProcurementService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Save Quality Check & Deal Offer (Officer Screens 6-8)
  Future<void> saveInspectionAndOffer(ProcurementInspectionModel inspection) async {
    await _firestore
        .collection('procurement_inspections')
        .doc(inspection.bookingId)
        .set(inspection.toMap());

    await _firestore.collection('bookings').doc(inspection.bookingId).update({
      'status': 'deal_offered',
    });
  }

  // Stream Quality Report for Farmer View (Farmer Screen 15)
  Stream<ProcurementInspectionModel?> streamInspectionReport(String bookingId) {
    return _firestore
        .collection('procurement_inspections')
        .doc(bookingId)
        .snapshots()
        .map((doc) => doc.exists && doc.data() != null
            ? ProcurementInspectionModel.fromMap(doc.data()!, doc.id)
            : null);
  }

  // Process & Complete Payment (Officer Screens 9-10)
  Future<void> processPayment({
    required String bookingId,
    required String txnId,
  }) async {
    await _firestore.collection('procurement_inspections').doc(bookingId).update({
      'paymentStatus': 'completed',
      'paymentTxnId': txnId,
    });

    await _firestore.collection('bookings').doc(bookingId).update({
      'status': 'completed',
    });
  }
}