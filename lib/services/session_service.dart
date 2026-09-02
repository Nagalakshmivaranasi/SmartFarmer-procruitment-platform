import '../models/user_model.dart';
import 'local_database_service.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();
  UserModel? currentUser;

  Future<void> restore() async {
    if (currentUser == null) {
      currentUser = await findUser('123456789012');
    }
  }

  void start(UserModel user) {
    currentUser = user;
  }

  Future<void> clear() async {
    currentUser = null;
  }

  Future<UserModel?> findUser(String uid) =>
      IsarDatabaseService().findUserByUid(uid);
}