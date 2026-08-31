import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Get current logged-in Firebase user
  User? get currentUser => _auth.currentUser;

  // Stream of auth changes (logged in / logged out state)
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // 2. Sign Up with Email, Password, and Profile details
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
    required String phoneNumber,
    required UserRole role,
  }) async {
    // Create user in Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    String uid = userCredential.user!.uid;

    // Build user profile model
    UserModel newUser = UserModel(
      uid: uid,
      email: email.trim(),
      name: name.trim(),
      phoneNumber: phoneNumber.trim(),
      role: role,
      createdAt: DateTime.now(),
    );

    // Save user profile in Firestore 'users' collection
    await _firestore.collection('users').doc(uid).set(newUser.toMap());

    return userCredential;
  }

  // 3. Sign In with Email & Password
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // 4. Fetch User Profile Data from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromSnapshot(doc);
    }
    return null;
  }

  // 5. Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}