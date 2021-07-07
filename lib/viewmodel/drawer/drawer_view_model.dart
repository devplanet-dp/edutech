import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/constants/route_name.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/ui/shared/bottom_sheet_type.dart';

import '../../locator.dart';
import '../base_model.dart';

class DrawerViewModel extends BaseModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final _bottomSheetService = locator<BottomSheetService>();

  goBack() => _navigationService.back();


  navigateToChangePwd() => _navigationService.navigateTo(ChangePwdViewRoute);



  Future signOut() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to sign out?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      var signOut = await _authenticationService.signOutUser();
      if (!signOut.hasError) {
        _navigationService.replaceWith(LoginViewRoute);
      } else {
        _dialogService.showDialog(
            title: 'Sign Out Failed', description: signOut.errorMessage);
      }
    }
  }
}
