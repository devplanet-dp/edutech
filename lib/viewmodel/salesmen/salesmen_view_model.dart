import 'dart:io';

import 'package:csv/csv.dart';
import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/utils/app_utils.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class SalesmenViewModel extends BaseModel {
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();

  //text controllers:-----------------------------------------------------------
  final searchController = TextEditingController();
  String _searchKey = '';

  bool get isSearch => _searchKey.isNotEmpty;

  onValueChanged(String value) {
    _searchKey = value;
    notifyListeners();
  }

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

  bool _showGraph = false;

  bool get showGraph => _showGraph;

  void toggleShowGraph() {
    _showGraph = !_showGraph;
    notifyListeners();
  }

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

  Future exportCSVFile(UserModel salesman) async {
    var response = await _dialogService.showConfirmationDialog(
        title: 'Download CSV',
        description: 'Do you want to download the report as CSV');
    if (response.confirmed) {
      if (await Permission.storage.request().isGranted) {
        setBusy(true);
        var result = await _firestoreService.getMySales(salesman.userId);
        setBusy(false);
        if (!result.hasError) {
          List<Sale> s = result.data as List<Sale>;

          List<List<dynamic>> rows = [];

          List<dynamic> row = [];
          row.add("Student Name");
          row.add("Email");
          row.add("Mobile Number");
          row.add("Date of registration");
          row.add("College name");
          row.add("Course name");
          row.add("Program type");
          row.add("Year");
          row.add("Registered for");
          row.add("Lead source");
          row.add("Amount paid");
          row.add("Course fee");
          row.add("Point of contact");
          rows.add(row);
          for (int i = 0; i < s.length; i++) {
            DateTime datReg = s[i].dateRegistration.toDate();
            List<dynamic> row = [];
            row.add(s[i].studentName);
            row.add(s[i].email);
            row.add(s[i].mobileNumber);
            row.add('${datReg.year}/${datReg.month}/${datReg.day}');
            row.add(s[i].collegeName);
            row.add(s[i].courseName);
            row.add(s[i].programType.toShortString());
            row.add(s[i].yearStudy);
            row.add(s[i].registeredFor.toShortString());
            row.add(s[i].leadSource.toShortString());
            row.add('${formatCurrency.format(s[i].amountPaid)}');
            row.add('${formatCurrency.format(s[i].courseFee)}');
            row.add(salesman.name);
            rows.add(row);
          }
          String csv = const ListToCsvConverter().convert(rows);

          String dir = await ExtStorage.getExternalStoragePublicDirectory(
              ExtStorage.DIRECTORY_DOWNLOADS);
          print("dir $dir");
          String file = "$dir";

          File f =
              File(file + "/${salesman.name} - sales - ${DateTime.now()}.csv");

          f.writeAsString(csv);
          await _dialogService.showDialog(
              title: 'Success',
              description: 'CSV file is expored to ${f.path}');
        } else {
          await _dialogService.showDialog(
              title: 'Oops', description: result.errorMessage);
        }
      } else {
        await Permission.storage.request();
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
