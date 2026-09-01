enum InspectionStatus { fullyAccepted, partiallyAccepted, rejected }

class InspectionResult {
  final String tokenId;
  final String cropName;
  final double totalQuantityQuintals;
  final double moisturePercentage;
  final double foreignMatterPercentage;
  final double damagedPercentage;
  final double basePricePerQuintal;

  InspectionResult({
    required this.tokenId,
    required this.cropName,
    required this.totalQuantityQuintals,
    required this.moisturePercentage,
    required this.foreignMatterPercentage,
    required this.damagedPercentage,
    required this.basePricePerQuintal,
  });

  /// Business Logic to evaluate decision status based on Govt/Procurement standards
  InspectionStatus get status {
    // Rejection Thresholds: Moisture > 16%, Foreign Matter > 4%, or Damaged > 7%
    if (moisturePercentage > 16.0 ||
        foreignMatterPercentage > 4.0 ||
        damagedPercentage > 7.0) {
      return InspectionStatus.rejected;
    }

    // Partial Acceptance Thresholds: Moisture between 12% and 16%, or Foreign Matter > 2%
    if (moisturePercentage > 12.0 ||
        foreignMatterPercentage > 2.0 ||
        damagedPercentage > 3.0) {
      return InspectionStatus.partiallyAccepted;
    }

    return InspectionStatus.fullyAccepted;
  }

  /// Price deduction per quintal for partial acceptance
  double get priceDeductionPerQuintal {
    if (status != InspectionStatus.partiallyAccepted) return 0.0;
    
    double deduction = 0.0;
    if (moisturePercentage > 12.0) {
      deduction += (moisturePercentage - 12.0) * 20.0; // ₹20 penalty per 1% excess moisture
    }
    if (foreignMatterPercentage > 2.0) {
      deduction += (foreignMatterPercentage - 2.0) * 30.0; // ₹30 penalty per 1% foreign matter
    }
    return deduction;
  }

  double get finalPricePerQuintal => basePricePerQuintal - priceDeductionPerQuintal;
  double get totalPayout => totalQuantityQuintals * finalPricePerQuintal;
}