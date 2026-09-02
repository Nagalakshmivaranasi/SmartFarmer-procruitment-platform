import 'package:smart_farmer_procurement/models/user_model.dart';
import 'local_database_service.dart';

class UserService {
  final IsarDatabaseService _database;

  UserService({IsarDatabaseService? database})
      : _database = database ?? IsarDatabaseService();

  Future<void> saveUserProfile(UserModel user) => _database.saveUser(user);

  Future<UserModel?> getUserProfile(String uid) => _database.findUserByUid(uid);
}