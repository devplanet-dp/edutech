import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/constants/route_name.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';

import '../../locator.dart';
import '../base_model.dart';

class WelcomeViewModel extends BaseModel {

  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  void navigateToLogin() async {
    await _navigationService.navigateTo(LoginViewRoute);
  }

  void navigateToSignUp(bool isInvestor) async {
    await _navigationService.navigateTo(SignUpViewRoute, arguments: isInvestor);
  }

  void navigateToSignUpComplete() async {
    _navigationService.navigateTo(SignUpCompleteRoute);
  }

}
