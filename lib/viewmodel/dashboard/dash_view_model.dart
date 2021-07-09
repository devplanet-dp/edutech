import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class DashViewModel extends BaseModel {
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();

  Stream<List<UserModel>> streamAllUsers() =>
      _firestoreService.streamAllUsers(currentUser.userId);

  Stream<List<Sale>> streamAppSales({int limit}) =>
      _firestoreService.streamSales(limit: limit);

  void navigateToSalesmenView() =>
      _navigationService.navigateTo(SalesmenViewRoute);
  Future signOut() async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      description: 'Do you really want to sign out?',
      confirmationTitle: 'Yes',
      cancelTitle: 'No',
    );
    if (dialogResponse.confirmed) {
      setBusy(true);
      var result = await _authenticationService.signOutUser();
      setBusy(false);
      if (!result.hasError) {
        _navigationService.replaceWith(LoginViewRoute);
      } else {
        await _dialogService.showDialog(
          title: 'Sign Out Failed',
          description: result.errorMessage,
        );
      }
    }
  }

}
