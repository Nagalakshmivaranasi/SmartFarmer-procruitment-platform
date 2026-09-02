import '../models/user_model.dart';
import 'local_database_service.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();
  UserModel? currentUser;

  Future<void> restore() async {}

  void start(UserModel user) {
    currentUser = user;
  }

  Future<void> clear() async {
    currentUser = null;
  }

  Future<UserModel?> findUser(String uid) =>
      IsarDatabaseService().findUserByUid(uid);
}