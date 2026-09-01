class BookingModel {
  final String bookingId;
  final String farmerId;
  final String farmerName;
  final String centreId;
  final String centreName;
  final String crop;
  final double quantityQuintal;
  final String bookingDate;
  final String slotTime;
  final int tokenNumber;
  final String status;
  final DateTime createdAt;

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
    required this.tokenNumber,
    required this.status,
    required this.createdAt,
  });

  factory BookingModel.fromMap(Map<String, dynamic> data, String id) {
    return BookingModel(
      bookingId: id,
      farmerId: data['farmerId'] ?? '',
      farmerName: data['farmerName'] ?? '',
      centreId: data['centreId'] ?? '',
      centreName: data['centreName'] ?? '',
      crop: data['crop'] ?? '',
      quantityQuintal: (data['quantityQuintal'] ?? 0).toDouble(),
      bookingDate: data['bookingDate'] ?? '',
      slotTime: data['slotTime'] ?? '',
      tokenNumber: data['tokenNumber'] ?? 0,
      status: data['status'] ?? 'booked',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
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
      'bookingDate': bookingDate,
      'slotTime': slotTime,
      'tokenNumber': tokenNumber,
      'status': status,
      'createdAt': createdAt,
    };
  }
}