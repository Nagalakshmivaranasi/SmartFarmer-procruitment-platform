import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_welcome_screen.dart';
import 'services/local_database_service.dart';
import 'services/procurement_repository.dart';
import 'l10n/generated/app_localizations.dart';
import 'core/locale/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IsarDatabaseService.initialize();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProcurementRepository()),
        ChangeNotifierProvider(create: (_) => localeProvider),
      ],
      child: const KisanSetuApp(),
    ),
  );
}

class KisanSetuApp extends StatelessWidget {
  const KisanSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          title: 'KisanSetu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          locale: provider.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const SplashWelcomeScreen(),
        );
      },
    );
  }
}