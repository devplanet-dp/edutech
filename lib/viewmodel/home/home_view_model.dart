import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/services/firestore_service.dart';

import '../../locator.dart';
import '../base_model.dart';

class HomeViewModel extends BaseModel{
  final _firestoreService = locator<FirestoreService>();
  final _navigationService = locator<NavigationService>();




}