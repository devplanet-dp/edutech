import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/ui/shared/bottom_sheet_type.dart';
import 'package:flutter/material.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../base_model.dart';

class LoginViewModel extends BaseModel {
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();
  final firebaseAuthenticationService =
      locator<FirebaseAuthenticationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  bool _isObscure = true;

  bool get isObscure => _isObscure;

  toggleObscure() {
    _isObscure = !_isObscure;
    notifyListeners();
  }

  Future login({
    @required String email,
    @required String password,
  }) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigateToHome();
      } else {
        await _dialogService.showDialog(
          title: 'Login Failed',
          description: 'Something went wrong!',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Login Failed',
        description: result,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    setBusy(true);
    await firebaseAuthenticationService.logout();
    final result = await firebaseAuthenticationService.signInWithGoogle();
    _handleAuthentications(result);
    setBusy(false);
  }



  void _handleAuthentications(FirebaseAuthenticationResult result) async {
    if (!result.hasError) {
      setBusy(true);
      final currentUser =
          await _authenticationService.createUpdateUser(result.user);
      setBusy(false);
      if (!currentUser.hasError) {
        navigateToHome();
      } else {
        _dialogService.showDialog(
            title: 'Sign In Failed', description: currentUser.errorMessage);
      }
    } else {
      _dialogService.showDialog(
          title: 'Sign In Failed', description: result.errorMessage);
    }
  }

  void navigateToHome() async {
    var isAdmin = currentUser.isAdmin
    ;
    if (isAdmin == null) {
      _navigationService.replaceWith(WelcomeViewRoute, arguments: true);
    } else if (!isAdmin) {
      _navigationService.replaceWith(HomeViewRoute);
    } else {
      _navigationService.replaceWith(HomeViewRoute);
    }
  }


  void navigateToSignUp() async {
    await _navigationService.navigateTo(SignUpViewRoute);
  }

  void navigateToForgotPassword() async {
    await _navigationService.navigateTo(ForgotPwdRoute);
  }

}
