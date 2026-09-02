import 'package:flutter/material.dart';

// Adjust these imports to match your actual folder structure
import 'services/local_database_service.dart';
import 'services/local_seed_service.dart';
import 'services/session_service.dart';
import 'features/auth/screens/welcome_screen.dart'; // Or login_screen.dart if you skip welcome

void main() async {
  // 1. Ensure Flutter bindings are initialized before doing any async work
  WidgetsFlutterBinding.ensureInitialized();

  await LocalDatabaseService.initialize();

  // 3. Inject test users (Farmer & Officer) if the database is empty
  await LocalSeedService.seedIfEmpty();
  await SessionService.instance.restore();

  // 4. Run the application
  runApp(const AgriProcurementApp());
}

/// The root widget of the application.
/// This fixes the "AgriProcurementApp isn't a class" error.
class AgriProcurementApp extends StatelessWidget {
  const AgriProcurementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KisanSetu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Use your existing app_theme colors if you have them, 
        // otherwise this defaults to a green theme for agriculture
        primarySwatch: Colors.green,
        primaryColor: Colors.green,
        useMaterial3: true,
      ),
      // This routes to your existing WelcomeScreen first
      home: const WelcomeScreen(), 
    );
  }
}