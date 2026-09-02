import 'package:isar/isar.dart';

part 'booking_model.g.dart';

@collection
class BookingModel {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  String bookingId;
  @Index()
  String farmerId;
  String farmerName;
  @Index()
  String centreId;
  String centreName;
  String crop;
  double quantityQuintal;
  @Index()
  DateTime bookingDate;
  String slotTime;
  @Index(unique: true, replace: true)
  String token;
  String status;
  String paymentStatus;
  DateTime createdAt;

  BookingModel({
    required this.bookingId,
    required this.farmerId,
    required this.farmerName,
    required this.centreId,
    required this.centreName,
    required this.crop,
    required this.quantityQuintal,
    required this.bookingDate,
    required this.slotTime,
    String token = '',
    int? tokenNumber,
    required this.status,
    this.paymentStatus = 'Pending',
    required this.createdAt,
  }) : token = token.isEmpty ? tokenNumber?.toString() ?? '' : token;

  @ignore
  int get tokenNumber => int.tryParse(token) ?? 0;

  factory BookingModel.fromMap(Map<String, dynamic> data, String id) {
    return BookingModel(
      bookingId: id,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      centreId: data['centreId'] ?? '',
      centreName: data['centreName'] ?? '',
      crop: data['crop'] ?? '',
      quantityQuintal: (data['quantityQuintal'] ?? 0).toDouble(),
        bookingDate: DateTime.tryParse(data['bookingDate']?.toString() ?? '') ?? DateTime.now(),
      slotTime: data['slotTime'] ?? '',
        token: data['token']?.toString() ?? data['tokenNumber']?.toString() ?? '',
        status: data['status'] ?? 'Pending',
        paymentStatus: data['paymentStatus'] ?? 'Pending',
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bookingId': bookingId,
      'farmerId': farmerId,
      'farmerName': farmerName,
      'centreId': centreId,
      'centreName': centreName,
      'crop': crop,
      'quantityQuintal': quantityQuintal,
      'bookingDate': bookingDate.toIso8601String(),
      'slotTime': slotTime,
      'token': token,
      'status': status,
      'paymentStatus': paymentStatus,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}