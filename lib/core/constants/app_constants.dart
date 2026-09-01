class AppConstants {
  static const int defaultAverageProcessingTimeMinutes = 5;
  static const int defaultTravelTimeMinutes = 20;

  // Thresholds for notification deduplication & throttling
  static const int significantServiceTimeChangeMinutes = 15;
  static const int queueApproachingThresholdFarmers = 2;

  // Arrival status thresholds (minutes)
  static const int lateWarningThresholdMinutes = 0;
  static const int timeToLeaveThresholdMinutes = 10;
}