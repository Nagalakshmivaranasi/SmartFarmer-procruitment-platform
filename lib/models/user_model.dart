import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String uid;

  String role;
  String name;
  String? farmerId;
  String? officerId;
  String phoneNumber;
  String? aadhaarNumber;
  String? state;
  String? district;
  String? centreId;
  DateTime createdAt;

  UserModel({
    required this.uid,
    required this.role,
    required this.name,
    this.farmerId,
    this.officerId,
    required this.phoneNumber,
    this.aadhaarNumber,
    this.state,
    this.district,
    this.centreId,
    required this.createdAt,
  });

  // Retained for seeding data locally or future cloud syncing
  factory UserModel.fromMap(Map<String, dynamic> data, String mappedUid) {
    return UserModel(
      uid: mappedUid,
      role: data['role'] ?? 'farmer',
      name: data['name'] ?? '',
      farmerId: data['farmerId'],
      officerId: data['officerId'],
      phoneNumber: data['phoneNumber'] ?? '',
      aadhaarNumber: data['aadhaarNumber'] ?? '',
      state: data['state'] ?? '',
      district: data['district'] ?? '',
      centreId: data['centreId'],
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role,
      'name': name,
      if (farmerId != null) 'farmerId': farmerId,
      if (officerId != null) 'officerId': officerId,
      'phoneNumber': phoneNumber,
      if (aadhaarNumber != null) 'aadhaarNumber': aadhaarNumber,
      if (state != null) 'state': state,
      if (district != null) 'district': district,
      if (centreId != null) 'centreId': centreId,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}