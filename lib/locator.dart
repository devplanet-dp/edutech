import 'package:get_it/get_it.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/image_selector.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked_themes/stacked_themes.dart';

import 'services/firestore_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());
  locator.registerLazySingleton(() => FirestoreService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => ThemeService.getInstance());
  locator.registerLazySingleton(() => BottomSheetService());
}
