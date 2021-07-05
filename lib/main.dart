import 'package:edutech/ui/router.dart';
import 'package:edutech/ui/shared/app_theme.dart';
import 'package:edutech/ui/views/startup/startup_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // DeviceOrientation.landscapeRight,
    // DeviceOrientation.landscapeLeft,
  ]).then((_) async {
    setupLocator();
    await Firebase.initializeApp();
    await ThemeManager.initialise();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
        defaultThemeMode: ThemeMode.dark,
        darkTheme: themeDataDark,
        lightTheme: themeData,
        builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
              darkTheme: darkTheme,
              themeMode: themeMode,
              debugShowCheckedModeBanner: false,
              title: 'Verzeo EduTech',
              navigatorKey: StackedService.navigatorKey,
              theme: regularTheme,
              home: StartupView(),
              onGenerateRoute: generateRoute,
            ));
  }
}
