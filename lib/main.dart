import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'services/local_database_service.dart';
import 'services/local_seed_service.dart';
import 'services/session_service.dart';
import 'features/auth/screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseService.initialize();
  await LocalSeedService.seedIfEmpty();
  await SessionService.instance.restore();

  runApp(const AgriProcurementApp());
}

class AgriProcurementApp extends StatelessWidget {
  const AgriProcurementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KisanSetu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(), 
    );
  }
}