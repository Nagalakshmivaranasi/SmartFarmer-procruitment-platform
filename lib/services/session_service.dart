import '../models/user_model.dart';

class SessionService {
  SessionService._();
  static final SessionService instance = SessionService._();

  UserModel? currentUser;

  static UserModel? get currentStaticUser => instance.currentUser;
  static set currentStaticUser(UserModel? user) => instance.currentUser = user;

  Future<void> start(UserModel user) async {
    currentUser = user;
  }

  Future<UserModel?> restore() async {
    return currentUser;
  }

  Future<void> clear() async {
    currentUser = null;
  }
}