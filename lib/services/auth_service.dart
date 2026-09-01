import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_farmer_procurement/models/user_model.dart';

enum UserRole { farmer, officer }

class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Create or register user profile
  Future<void> registerUser({
    required String uid,
    required String name,
    required String phoneNumber,
    required UserRole role,
    String? farmerId,
    String? officerId,
    String? aadhaarNumber,
    String? state,
    String? district,
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

    await _firestore.collection('users').doc(uid).set(userModel.toMap());
  }

  // Fetch current user model
  Future<UserModel?> getUserModel(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!, doc.id);
    }
    return null;
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}