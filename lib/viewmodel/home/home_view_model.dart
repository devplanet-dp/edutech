import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../base_model.dart';

class HomeViewModel extends BaseModel {
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authenticationService = locator<AuthenticationService>();

  var formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  DateTime _startDate;
  DateTime _endDate;
  bool _hasDateFilter;

  bool get hasDateFilter => _hasDateFilter;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  void toggleDateFilter(bool value) {
    _hasDateFilter = value;
    notifyListeners();
  }

  void setStartDate(DateTime dateTime) {
    _startDate = dateTime;
    startDateController.text =
        "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
    endDateController.text = "";
    notifyListeners();
  }

  void clearFilter() {
    clearStartDate();
    clearEndDate();
    toggleDateFilter(false);
    notifyListeners();
  }

  void setEndDate(DateTime dateTime) {
    _endDate = dateTime;
    endDateController.text =
        "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
    toggleDateFilter(true);
    notifyListeners();
  }

  void clearEndDate() {
    _endDate = null;
    endDateController.text = '';
  }

  void clearStartDate() {
    _startDate = null;
    startDateController.text = '';
  }

  List<Sale> _saleResult = [];

  List<Sale> get saleResult => _saleResult;

  void filterSales() {}

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

  Stream<List<Sale>> streamMySales() =>
      _firestoreService.streamMySales(currentUser.userId);

  navigateToAddBusiness() => _navigationService.navigateTo(AddSaleViewRoute);

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }
}
