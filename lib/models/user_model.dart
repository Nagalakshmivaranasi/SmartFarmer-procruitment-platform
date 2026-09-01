class UserModel {
  final String uid;
  final String role; // 'farmer' or 'officer'
  final String name;
  final String? farmerId;
  final String? officerId;
  final String phoneNumber;
  final String? aadhaarNumber;
  final String? state;
  final String? district;
  final String? centreId;
  final DateTime createdAt;

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

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      uid: id,
      role: data['role'] ?? 'farmer',
      name: data['name'] ?? '',
      farmerId: data['farmerId'],
      officerId: data['officerId'],
      phoneNumber: data['phoneNumber'] ?? '',
      aadhaarNumber: data['aadhaarNumber'],
      state: data['state'],
      district: data['district'],
      centreId: data['centreId'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as dynamic).toDate()
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