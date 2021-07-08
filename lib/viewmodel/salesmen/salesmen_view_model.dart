import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class SalesmenViewModel extends BaseModel {
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();


  List<Sale> _saleResult = [];

  List<Sale> get saleResult => _saleResult;


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


  //text controllers:-----------------------------------------------------------
  final searchController = TextEditingController();
  String _searchKey = '';

  bool get isSearch => _searchKey.isNotEmpty;


  onValueChanged(String value) {
    _searchKey = value;
    notifyListeners();
  }

  Stream<List<UserModel>> searchUsers() => _firestoreService.searchAllUsers(
        searchKey: _searchKey,
        currentUid: currentUser.userId,
      );

  Stream<List<Sale>> userSaleStream(String uid) =>
      _firestoreService.streamMySales(uid);

  void navigateToSalesmenView() =>
      _navigationService.navigateTo(SalesmenViewRoute);

  void navigateToSaleStatView(UserModel user) =>
      _navigationService.navigateTo(SaleStatViewRoute, arguments: user);

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
