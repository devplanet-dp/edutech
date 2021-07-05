import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/constants/route_name.dart';
import 'package:edutech/services/auth_service.dart';

import '../../locator.dart';
import '../base_model.dart';

class ForgotViewModel extends BaseModel{
  final AuthenticationService _authenticationService =
  locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();


  Future sendResetPassowrd({@required String email}) async {
    setBusy(true);

    var result = await _authenticationService.sendPasswordResetEmail(
      email: email,
    );

    setBusy(false);

    if (result is bool) {
      if (result) {
        showSuccessSheet(email: email);
      } else {
        await _dialogService.showDialog(
          title: 'Reset password Failed',
          description: 'Something went wrong!',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Reset password Failed',
        description: result,
      );
    }
  }

  void navigateToLogin() {
    _navigationService.replaceWith(LoginViewRoute);
  }

  Future sendConfirmCode(
      {@required String code, @required String passowrd}) async {
    setBusy(true);

    var result = await _authenticationService.confirmPasswordResetCode(
        code: code, newPassword: passowrd);

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigateToLogin();
      } else {
        await _dialogService.showDialog(
          title: 'Confirmation Failed',
          description: 'Something went wrong!',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Confirmation Failed',
        description: result,
      );
    }
  }

  Future showSuccessSheet({String email}) async {
    var sheetResponse = await _bottomSheetService.showBottomSheet(
        title: 'Verify email',
        description:
        'Please follow the instructions sent to $email to reset the passowrd ',
        cancelButtonTitle: 'Cancel',
        confirmButtonTitle: 'Ok');

    if (sheetResponse != null) {
      navigateToLogin();
    }
  }
}