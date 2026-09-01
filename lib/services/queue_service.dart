import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farmer_procurement/core/constants/firestore_paths.dart';

class QueueService {
  final FirebaseFirestore _firestore;

  QueueService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Real-time queue stream for Officer Dashboard & Live Queue Status (Screens 3 & 16)
  Stream<DocumentSnapshot> streamCenterQueue(String centreId) {
    return _firestore.doc(FirestorePaths.queueDoc(centreId)).snapshots();
  }

  // Advance current serving token (Officer Screen 4 - Call Next)
  Future<void> advanceToken({
    required String centreId,
    required int nextTokenNumber,
  }) async {
    await _firestore.doc(FirestorePaths.queueDoc(centreId)).update({
      'currentTokenNumber': nextTokenNumber,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // Mark farmer arrival & update queue token status (Officer Screen 5)
  Future<void> updateTokenStatus({
    required String centreId,
    required String tokenNumber,
    required String newStatus,
  }) async {
    final queueRef = _firestore.doc(FirestorePaths.queueDoc(centreId));
    final doc = await queueRef.get();

    if (doc.exists) {
      final List<dynamic> items = List.from(doc.get('items') ?? []);
      final index = items.indexWhere((e) => e['tokenNumber'].toString() == tokenNumber);

      if (index != -1) {
        items[index]['status'] = newStatus;
        await queueRef.update({'items': items});
      }
    }
  }
}