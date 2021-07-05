import 'package:flutter/material.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:edutech/model/config.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';

import '../locator.dart';

class BaseModel extends ChangeNotifier {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final ThemeService _themeService = locator<ThemeService>();

  bool isDark() => _themeService.isDarkMode;

  UserModel get currentUser => _authenticationService.currentUser;

  Config get appConfig => _firestoreService.config;

  toggleTheme() => _themeService.toggleDarkLightTheme();

  bool _busy = false;

  bool get busy => _busy;

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  void applyChanges() => notifyListeners();
}
