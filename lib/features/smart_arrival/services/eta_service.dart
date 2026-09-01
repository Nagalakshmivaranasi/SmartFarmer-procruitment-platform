import '../../../core/constants/app_constants.dart';
import '../../../models/queue.dart';

enum ArrivalStatus {
  enoughTime,
  timeToLeave,
  pleaseLeaveNow,
  alreadyLate,
}

class EtaCalculationResult {
  final int farmerToken;
  final int currentToken;
  final int farmersAhead;
  final Duration estimatedWaitingTime;
  final DateTime expectedServiceTime;
  final Duration travelTime;
  final DateTime recommendedDepartureTime;
  final ArrivalStatus arrivalStatus;

  EtaCalculationResult({
    required this.farmerToken,
    required this.currentToken,
    required this.farmersAhead,
    required this.estimatedWaitingTime,
    required this.expectedServiceTime,
    required this.travelTime,
    required this.recommendedDepartureTime,
    required this.arrivalStatus,
  });
}

class EtaService {
  /// Calculate active farmers ahead of the user's token
  int calculateFarmersAhead({
    required int farmerToken,
    required CenterQueue queue,
  }) {
    if (queue.items.isNotEmpty) {
      final activeAhead = queue.items.where((item) {
        final tokenNum = int.tryParse(item.tokenNumber) ?? 0;
        return tokenNum >= queue.currentTokenNumber &&
            tokenNum < farmerToken &&
            (item.status == QueueTokenStatus.active ||
                item.status == QueueTokenStatus.serving);
      }).length;
      return activeAhead;
    }

    final diff = farmerToken - queue.currentTokenNumber;
    return diff > 0 ? diff : 0;
  }

  /// Calculates waiting time, service time, departure time, and arrival status
  EtaCalculationResult calculateEta({
    required int farmerToken,
    required CenterQueue queue,
    Duration? travelTime,
    DateTime? now,
  }) {
    final currentTime = now ?? DateTime.now();
    final effectiveTravelTime =
        travelTime ?? const Duration(minutes: AppConstants.defaultTravelTimeMinutes);
    final avgProcessing = queue.averageProcessingMinutes > 0
        ? queue.averageProcessingMinutes
        : AppConstants.defaultAverageProcessingTimeMinutes;

    final farmersAhead = calculateFarmersAhead(
      farmerToken: farmerToken,
      queue: queue,
    );

    final waitingMinutes = farmersAhead * avgProcessing;
    final estimatedWaitingTime = Duration(minutes: waitingMinutes);
    final expectedServiceTime = currentTime.add(estimatedWaitingTime);
    final recommendedDepartureTime =
        expectedServiceTime.subtract(effectiveTravelTime);

    final timeUntilDeparture =
        recommendedDepartureTime.difference(currentTime);

    ArrivalStatus arrivalStatus;
    if (timeUntilDeparture.inMinutes < AppConstants.lateWarningThresholdMinutes) {
      arrivalStatus = ArrivalStatus.alreadyLate;
    } else if (timeUntilDeparture.inMinutes <= 0) {
      arrivalStatus = ArrivalStatus.pleaseLeaveNow;
    } else if (timeUntilDeparture.inMinutes <=
        AppConstants.timeToLeaveThresholdMinutes) {
      arrivalStatus = ArrivalStatus.timeToLeave;
    } else {
      arrivalStatus = ArrivalStatus.enoughTime;
    }

    return EtaCalculationResult(
      farmerToken: farmerToken,
      currentToken: queue.currentTokenNumber,
      farmersAhead: farmersAhead,
      estimatedWaitingTime: estimatedWaitingTime,
      expectedServiceTime: expectedServiceTime,
      travelTime: effectiveTravelTime,
      recommendedDepartureTime: recommendedDepartureTime,
      arrivalStatus: arrivalStatus,
    );
  }

  /// Travel time calculation endpoint (extensible for location APIs)
  Future<Duration> calculateTravelTime({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    return const Duration(minutes: AppConstants.defaultTravelTimeMinutes);
  }
}