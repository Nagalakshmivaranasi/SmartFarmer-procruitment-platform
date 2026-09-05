// lib/models/core_models.dart

enum UserRole { farmer, officer }

enum BookingStatus {
  slotBooked,
  arrivedAtCenter,
  underInspection,
  qualityCheckDone,
  reportGenerated,
  dealOffered,
  paymentProcessing,
  paymentCompleted,
  cancelled
}

class ProcurementCenter {
  final String id;
  final String name;
  final String state;
  final String district;
  final double distanceKm;
  final int capacityPerSlot;

  ProcurementCenter({
    required this.id,
    required this.name,
    required this.state,
    required this.district,
    required this.distanceKm,
    this.capacityPerSlot = 10,
  });
}

class AppUser {
  final String uid;
  final String fullName;
  final String phoneNumber;
  final UserRole role;
  final String? aadhaarNumber; // Stored securely/anonymized
  final String? officerId;
  final String? assignedCenterId; // Crucial: Relations to center
  final String state;
  final String district;

  AppUser({
    required this.uid,
    required this.fullName,
    required this.phoneNumber,
    required this.role,
    this.aadhaarNumber,
    this.officerId,
    this.assignedCenterId,
    required this.state,
    required this.district,
  });
}

class QualityParameters {
  double moistureContent; // e.g. 11.2%
  double foreignMatter; // e.g. 1.5%
  double otherFoodGrains; // e.g. 1.0%
  double damagedGrains; // e.g. 2.5%
  double immatureGrains; // e.g. 1.2%
  double weevilledGrains; // e.g. 0.8%
  double mixtureLowVarieties; // e.g. 0.5%

  QualityParameters({
    this.moistureContent = 0.0,
    this.foreignMatter = 0.0,
    this.otherFoodGrains = 0.0,
    this.damagedGrains = 0.0,
    this.immatureGrains = 0.0,
    this.weevilledGrains = 0.0,
    this.mixtureLowVarieties = 0.0,
  });
}

class SlotBooking {
  final String id;
  final String tokenNumber; // e.g., #42
  final String farmerId;
  final String farmerName;
  final String farmerPhone;
  final String? farmerAadhaarMasked;
  final String cropName;
  final String season;
  final double estimatedQuantityQuintal;
  final String state;
  final String district;
  final String centerId;
  final String centerName;
  final DateTime bookingDate;
  final String timeSlot;
  BookingStatus status;
  
  // Weights and Processing
  double grossWeightKg;
  double tareWeightKg;
  double get netWeightKg => (grossWeightKg - tareWeightKg) > 0 ? grossWeightKg - tareWeightKg : 0.0;
  QualityParameters? quality;
  double? offeredRatePerQuintal;
  double? totalPayout;
  DateTime createdAt;

  SlotBooking({
    required this.id,
    required this.tokenNumber,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    this.farmerAadhaarMasked,
    required this.cropName,
    required this.season,
    required this.estimatedQuantityQuintal,
    required this.state,
    required this.district,
    required this.centerId,
    required this.centerName,
    required this.bookingDate,
    required this.timeSlot,
    this.status = BookingStatus.slotBooked,
    this.grossWeightKg = 0.0,
    this.tareWeightKg = 0.0,
    this.quality,
    this.offeredRatePerQuintal,
    this.totalPayout,
    required this.createdAt,
  });
}