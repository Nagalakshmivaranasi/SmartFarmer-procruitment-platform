class QualityParameters {
  final double moistureContentPct;
  final double foreignMatterPct;
  final double otherFoodGrainsPct;
  final double damagedGrainsPct;
  final double immatureGrainsPct;
  final double weevilledGrainsPct;

  QualityParameters({
    required this.moistureContentPct,
    required this.foreignMatterPct,
    required this.otherFoodGrainsPct,
    required this.damagedGrainsPct,
    required this.immatureGrainsPct,
    required this.weevilledGrainsPct,
  });

  factory QualityParameters.fromMap(Map<String, dynamic> map) {
    return QualityParameters(
      moistureContentPct: (map['moistureContentPct'] ?? 0).toDouble(),
      foreignMatterPct: (map['foreignMatterPct'] ?? 0).toDouble(),
      otherFoodGrainsPct: (map['otherFoodGrainsPct'] ?? 0).toDouble(),
      damagedGrainsPct: (map['damagedGrainsPct'] ?? 0).toDouble(),
      immatureGrainsPct: (map['immatureGrainsPct'] ?? 0).toDouble(),
      weevilledGrainsPct: (map['weevilledGrainsPct'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'moistureContentPct': moistureContentPct,
      'foreignMatterPct': foreignMatterPct,
      'otherFoodGrainsPct': otherFoodGrainsPct,
      'damagedGrainsPct': damagedGrainsPct,
      'immatureGrainsPct': immatureGrainsPct,
      'weevilledGrainsPct': weevilledGrainsPct,
    };
  }
}

class ProcurementInspectionModel {
  final String bookingId;
  final String farmerId;
  final String centreId;
  final double grossWeightKg;
  final double tareWeightKg;
  final double netWeightKg;
  final QualityParameters qualityParameters;
  final String qualityGrade;
  final double offeredRatePerQuintal;
  final double totalAmount;
  final String paymentStatus; // pending, initiated, completed
  final String? paymentTxnId;

  ProcurementInspectionModel({
    required this.bookingId,
    required this.farmerId,
    required this.centreId,
    required this.grossWeightKg,
    required this.tareWeightKg,
    required this.netWeightKg,
    required this.qualityParameters,
    required this.qualityGrade,
    required this.offeredRatePerQuintal,
    required this.totalAmount,
    required this.paymentStatus,
    this.paymentTxnId,
  });

  factory ProcurementInspectionModel.fromMap(Map<String, dynamic> data, String id) {
    return ProcurementInspectionModel(
      bookingId: id,
      farmerId: data['farmerId'] ?? '',
      centreId: data['centreId'] ?? '',
      grossWeightKg: (data['grossWeightKg'] ?? 0).toDouble(),
      tareWeightKg: (data['tareWeightKg'] ?? 0).toDouble(),
      netWeightKg: (data['netWeightKg'] ?? 0).toDouble(),
      qualityParameters: QualityParameters.fromMap(data['qualityParameters'] ?? {}),
      qualityGrade: data['qualityGrade'] ?? 'Good',
      offeredRatePerQuintal: (data['offeredRatePerQuintal'] ?? 0).toDouble(),
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      paymentStatus: data['paymentStatus'] ?? 'pending',
      paymentTxnId: data['paymentTxnId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'farmerId': farmerId,
      'centreId': centreId,
      'grossWeightKg': grossWeightKg,
      'tareWeightKg': tareWeightKg,
      'netWeightKg': netWeightKg,
      'qualityParameters': qualityParameters.toMap(),
      'qualityGrade': qualityGrade,
      'offeredRatePerQuintal': offeredRatePerQuintal,
      'totalAmount': totalAmount,
      'paymentStatus': paymentStatus,
      if (paymentTxnId != null) 'paymentTxnId': paymentTxnId,
    };
  }
}