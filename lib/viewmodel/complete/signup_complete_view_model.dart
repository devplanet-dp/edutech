import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';
import '../base_model.dart';

class SignUpCompleteViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();

  void navigateToHome() async {
    _navigationService.replaceWith(
      HomeViewRoute,
    );
  }

}
