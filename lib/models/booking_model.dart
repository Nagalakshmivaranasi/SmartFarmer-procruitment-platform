import 'package:isar/isar.dart';

part 'booking_model.g.dart';

@collection
class BookingModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String bookingId;

  late String token;
  late String farmerId;
  late String farmerName;
  late String crop;
  late double quantityQuintal;
  late String centreId;
  late String centreName;
  late DateTime bookingDate;
  late String slotTime;
  late String status;
  late String paymentStatus;
  DateTime? createdAt;

  // Quality parameters & pricing fields
  double? baseMspRate;
  double? moistureLevel;
  double? foreignMatterLevel;
  double? damagedGrainsLevel;
  double? deductionPercentage;
  double? finalRatePerQuintal;
  double? netPayableAmount;
  String? rejectionReason;

  BookingModel({
    required this.bookingId,
    required this.token,
    required this.farmerId,
    required this.farmerName,
    required this.crop,
    required this.quantityQuintal,
    required this.centreId,
    required this.centreName,
    required this.bookingDate,
    required this.slotTime,
    this.status = 'Slot Booked',
    this.paymentStatus = 'Pending',
    this.createdAt,
    this.baseMspRate,
    this.moistureLevel,
    this.foreignMatterLevel,
    this.damagedGrainsLevel,
    this.deductionPercentage,
    this.finalRatePerQuintal,
    this.netPayableAmount,
    this.rejectionReason,
  });
}