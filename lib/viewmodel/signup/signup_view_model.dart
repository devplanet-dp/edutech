import 'package:edutech/constants/route_name.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../base_model.dart';

class SignUpViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();

  bool _isObscure = true;

  bool get isObscure => _isObscure;

  toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future signUp(
      {@required String email,
      @required String password,
      @required String fullName,
      }) async {
    setBusy(true);

    var result = await _authenticationService.signUpWithEmail(
        email: email,
        password: password,
        fullName: fullName,
      );

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigateToProfileUpdate();
      } else {
        await _dialogService.showDialog(
          title: 'Sign Up Failure',
          description: 'General sign up failure. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Sign Up Failure',
        description: result,
      );
    }
  }

  void navigateToSignUpComplete() async {
    await _navigationService.navigateTo(SignUpCompleteRoute);
  }

  void navigateToProfileUpdate() async {
    await _navigationService.navigateTo(ProfileViewRoute);
  }

  void navigateToLogin() async {
    await _navigationService.replaceWith(LoginViewRoute);
  }

  void navigateToTerms() async {
    await _navigationService.navigateTo(TermsViewRoute);
  }
}
