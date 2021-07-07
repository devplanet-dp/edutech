import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/services/auth_service.dart';

import '../../locator.dart';
import '../base_model.dart';

class ChangePwdViewModel extends BaseModel {
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

  Future changePassword(
      {@required String currentPassword, @required String newPassword}) async {
    setBusy(true);

    var result = await _authenticationService.updateUserPassword(
        newPassword: newPassword,
        currentPassword: currentPassword,
        email: currentUser.email);

    setBusy(false);

    if (result is bool) {
      var response = await _dialogService.showDialog(
        title: 'Password changed!',
        description: 'Your password has been changed successfully',
      );
      if (response.confirmed) {
        _navigationService.back();
      }
    } else {
      await _dialogService.showDialog(
        title: 'Oops!',
        description: result.toString(),
      );
    }
  }

  Future updatePassword(
      {@required String password, @required String newPassword}) async {
    setBusy(true);

    var result = await _authenticationService.loginWithEmail(
      email: currentUser.email,
      password: password,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        changePassword(currentPassword: password, newPassword: newPassword);
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
}
