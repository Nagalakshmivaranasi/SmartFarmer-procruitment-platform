import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farmer_procurement/core/constants/app_constants.dart';
import 'package:smart_farmer_procurement/core/constants/firestore_paths.dart';
import 'package:smart_farmer_procurement/features/smart_arrival/services/eta_service.dart';
import 'package:smart_farmer_procurement/models/notification.dart';

class NotificationService {
  final FirebaseFirestore _firestore;

  // Throttling state to prevent repetitive notification spam
  DateTime? _lastNotifiedServiceTime;
  int? _lastNotifiedFarmersAhead;
  bool _departureNotified = false;

  NotificationService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<AppNotification>> getUserNotifications(String userId) {
    return _firestore
        .collection(FirestorePaths.userNotifications(userId))
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromFirestore(doc))
            .toList());
  }

  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? metadata,
  }) async {
    final notification = AppNotification(
      id: '',
      userId: userId,
      title: title,
      body: body,
      type: type,
      createdAt: DateTime.now(),
      metadata: metadata,
    );

    await _firestore
        .collection(FirestorePaths.userNotifications(userId))
        .add(notification.toFirestore());
  }

  /// Evaluates Smart Arrival ETA updates and fires deduplicated alerts
  Future<void> evaluateAndNotifyArrivalUpdate({
    required String userId,
    required EtaCalculationResult result,
    required bool isBookingActive,
  }) async {
    if (!isBookingActive) return;

    final now = DateTime.now();

    // 1. Departure Time Trigger
    if (!_departureNotified &&
        (now.isAfter(result.recommendedDepartureTime) ||
            now.isAtSameMomentAs(result.recommendedDepartureTime))) {
      _departureNotified = true;
      await sendNotification(
        userId: userId,
        title: '🚜 It\'s time to leave',
        body:
            'Your procurement token is #${result.farmerToken}. Please start travelling to the procurement centre.',
        type: NotificationType.departureTime,
        metadata: {'token': result.farmerToken},
      );
    }

    // 2. Queue Approaching Trigger
    if (result.farmersAhead <= AppConstants.queueApproachingThresholdFarmers &&
        (_lastNotifiedFarmersAhead == null ||
            _lastNotifiedFarmersAhead! >
                AppConstants.queueApproachingThresholdFarmers)) {
      _lastNotifiedFarmersAhead = result.farmersAhead;
      await sendNotification(
        userId: userId,
        title: '🔔 Your token is approaching',
        body:
            'You are now only ${result.farmersAhead} farmer(s) away from procurement.',
        type: NotificationType.queueApproaching,
        metadata: {'farmersAhead': result.farmersAhead},
      );
    }

    // 3. Significant ETA / Delay Shift Trigger
    if (_lastNotifiedServiceTime != null) {
      final differenceMinutes = result.expectedServiceTime
          .difference(_lastNotifiedServiceTime!)
          .inMinutes
          .abs();

      if (differenceMinutes >=
          AppConstants.significantServiceTimeChangeMinutes) {
        final isDelayed =
            result.expectedServiceTime.isAfter(_lastNotifiedServiceTime!);
        _lastNotifiedServiceTime = result.expectedServiceTime;

        await sendNotification(
          userId: userId,
          title: isDelayed ? '⚠️ Procurement is delayed' : '🕐 ETA Updated',
          body: isDelayed
              ? 'Procurement is delayed. New expected service time: ${_formatTime(result.expectedServiceTime)}.'
              : 'Your estimated service time is now ${_formatTime(result.expectedServiceTime)}.',
          type: isDelayed
              ? NotificationType.delayWarning
              : NotificationType.etaUpdate,
          metadata: {'serviceTime': result.expectedServiceTime.toIso8601String()},
        );
      }
    } else {
      _lastNotifiedServiceTime = result.expectedServiceTime;
    }
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }
}