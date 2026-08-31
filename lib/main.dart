import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('SmartFarmer Firebase Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // Immediate console feedback to confirm click
              print('--- BUTTON CLICKED: STARTING FIREBASE TEST ---');
              
              try {
                AuthService authService = AuthService();
                final testEmail = 'farmer_${DateTime.now().millisecondsSinceEpoch}@gmail.com';
                
                print('Attempting signup for: $testEmail');
                
                await authService.signUpWithEmail(
                  email: testEmail,
                  password: 'TestPassword123',
                  name: 'Test Farmer',
                  phoneNumber: '9876543210',
                  role: UserRole.farmer,
                );
                
                print('SUCCESS: Registered $testEmail and wrote to Firestore!');
              } catch (e, stack) {
                print('ERROR testing Firebase: $e');
                print('STACK TRACE: $stack');
              }
            },
            child: const Text('Run Firebase Test'),
          ),
        ),
      ),
    );
  }
}