import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class DashViewModel extends BaseModel {
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();

  Stream<List<UserModel>> streamAllUsers() =>
      _firestoreService.streamAllUsers(currentUser.userId);

  Stream<List<Sale>> streamAllSales() => _firestoreService.streamSales();

  void navigateToSalesmenView() =>
      _navigationService.navigateTo(SalesmenViewRoute);


}
