import 'package:edutech/constants/route_name.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../base_model.dart';

class StartupViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();

  Future handleStartUpLogic() async {
    var hasLoggedInUser = await _authenticationService.isUserLoggedIn();


    if (hasLoggedInUser && currentUser != null) {
      if (currentUser.isAdmin) {
        _navigationService.replaceWith(
          DashboardViewRoute,
        );
      } else {
        _navigationService.replaceWith(
          HomeViewRoute,
        );
      }
    } else {
      _navigationService.replaceWith(LoginViewRoute);
    }
  }
}
