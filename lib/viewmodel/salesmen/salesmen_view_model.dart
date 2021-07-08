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
