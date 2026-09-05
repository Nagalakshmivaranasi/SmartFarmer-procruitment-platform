import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  bool get isTelugu => _locale.languageCode == 'te';

  void setLocale(Locale loc) {
    if (!['en', 'te'].contains(loc.languageCode)) return;
    _locale = loc;
    notifyListeners();
  }

  void toggleLocale() {
    _locale = _locale.languageCode == 'en' ? const Locale('te') : const Locale('en');
    notifyListeners();
  }
}

final localeProvider = LocaleProvider();