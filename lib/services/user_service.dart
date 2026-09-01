import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_farmer_procurement/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore;

  UserService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> saveUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap(), SetOptions(merge: true));
  }

  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }
}