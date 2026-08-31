import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase using google-services.json configuration
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Backend Database Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                // Test registration with AuthService and saving user to Firestore
                AuthService authService = AuthService();
                await authService.signUpWithEmail(
                  email: 'testfarmer@gmail.com',
                  password: 'TestPassword123',
                  name: 'Test Farmer',
                  phoneNumber: '9876543210',
                  role: UserRole.farmer,
                );
                debugPrint('SUCCESS: User registered and written to Firestore!');
              } catch (e) {
                debugPrint('ERROR testing Firebase: $e');
              }
            },
            child: const Text('Run Firebase Test'),
          ),
        ),
      ),
    );
  }
}