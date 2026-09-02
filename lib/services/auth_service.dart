import 'package:isar/isar.dart';
import 'package:smart_farmer_procurement/models/user_model.dart';
import 'local_database_service.dart';
import 'session_service.dart';

enum UserRole { farmer, officer }

class AuthService {
  AuthService({IsarDatabaseService? database})
      : _database = database ?? IsarDatabaseService();

  final IsarDatabaseService _database;
  UserModel? get currentUser => SessionService.instance.currentUser;

  Future<UserModel?> findUserForLogin({
    required String identifier,
    required UserRole role,
  }) async {
    final normalized = identifier.trim();
    final user = await IsarDatabaseService.isar.userModels
      .filter()
      .uidEqualTo(normalized)
      .or()
      .officerIdEqualTo(normalized)
      .findFirst();
    return user?.role == role.name ? user : null;
  }

  // Create or register user profile
  Future<void> registerUser({
    required String uid,
    required String name,
    required String phoneNumber,
    required UserRole role,
    String? farmerId,
    String? officerId,
    String? aadhaarNumber,
    required String state,
    required String district,
    String? centreId,
  }) async {
    final userModel = UserModel(
      uid: uid,
      role: role.name,
      name: name,
      phoneNumber: phoneNumber,
      farmerId: farmerId,
      officerId: officerId,
      aadhaarNumber: aadhaarNumber,
      state: state,
      district: district,
      centreId: centreId,
      createdAt: DateTime.now(),
    );

    await _database.saveUser(userModel);
  }

  // Fetch current user model
  Future<UserModel?> getUserModel(String uid) async {
    return _database.findUserByUid(uid);
  }

  // Sign out
  Future<void> signOut() async {
    await SessionService.instance.clear();
  }
}