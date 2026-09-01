import 'package:cloud_firestore/cloud_firestore.dart';

enum QueueTokenStatus { active, serving, completed, cancelled, skipped }

class QueueItem {
  final String tokenNumber;
  final String farmerId;
  final QueueTokenStatus status;
  final DateTime createdAt;

  QueueItem({
    required this.tokenNumber,
    required this.farmerId,
    required this.status,
    required this.createdAt,
  });

  factory QueueItem.fromMap(Map<String, dynamic> map) {
    return QueueItem(
      tokenNumber: map['tokenNumber']?.toString() ?? '0',
      farmerId: map['farmerId'] ?? '',
      status: QueueTokenStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => QueueTokenStatus.active,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tokenNumber': tokenNumber,
      'farmerId': farmerId,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class CenterQueue {
  final String centerId;
  final int currentTokenNumber;
  final int averageProcessingMinutes;
  final List<QueueItem> items;

  CenterQueue({
    required this.centerId,
    required this.currentTokenNumber,
    this.averageProcessingMinutes = 5,
    required this.items,
  });

  factory CenterQueue.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final rawItems = (data['items'] as List<dynamic>?) ?? [];
    return CenterQueue(
      centerId: doc.id,
      currentTokenNumber: data['currentTokenNumber'] ?? 0,
      averageProcessingMinutes: data['averageProcessingMinutes'] ?? 5,
      items: rawItems
          .map((e) => QueueItem.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}