import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutech/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../locator.dart';
import 'firestore_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();

  UserModel _currentUser;

  UserModel get currentUser => _currentUser;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await populateCurrentUser(authResult.user.uid);
      return authResult.user != null;
    } catch (e) {
      return e.message;
    }
  }

  Future<FirebaseResult> createUpdateUser(User user, {bool isInvestor}) async {
    try {
      final userExist = await isUserExist(user.uid);
      if (!userExist) {
        UserModel um = UserModel();
        um.userId = user.uid;
        um.email = user.email;
        um.name = user.displayName ?? user.email;
        um.profileUrl = user.photoURL;
        um.isActive = true;
        um.createdDate = Timestamp.now();
        final result = await _firestoreService.createUser(um);
        return FirebaseResult(data: um);
      }

      await populateCurrentUser(user.uid);
      return FirebaseResult(data: _currentUser);
    } catch (e) {
      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future signUpWithEmail({
    @required String email,
    @required String password,
    @required String fullName,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // create a new user profile on firestore
      _currentUser = UserModel(
        userId: authResult.user.uid,
        email: email,
        name: fullName,
        createdDate: Timestamp.now(),
      );

      var createUserResult = await _firestoreService.createUser(_currentUser);

      return createUserResult;
    } catch (e) {
      return e.message;
    }
  }

  Future sendPasswordResetEmail({@required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future updateUserPassword(
      {@required String currentPassword,
      @required String email,
      @required String newPassword}) async {
    try {
      await _firebaseAuth.currentUser.updatePassword(newPassword);
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future confirmPasswordResetCode(
      {@required String code, @required String newPassword}) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
          code: code, newPassword: newPassword);
      return true;
    } catch (e) {
      return e.message;
    }
  }

  Future<bool> isUserExist(String uid) async {
    var user = await _firestoreService.getUser(uid);
    return user != null;
  }

  Future<bool> isUserLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    await populateCurrentUser(user?.uid);
    return user != null;
  }

  Future<bool> updateCurrentUser() async {
    var user = _firebaseAuth.currentUser;
    await populateCurrentUser(user.uid);
    return user != null;
  }

  Future<FirebaseResult> signOutUser() async {
    try {
      await _firebaseAuth.signOut();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message);
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> populateCurrentUser(String uid) async {
    if (uid != null) {
      var result = await _firestoreService.getUser(uid);
      if (result is UserModel) {
        _currentUser = result;
        return FirebaseResult(data: result);
      } else {
        return FirebaseResult(data: null);
      }
    }
    return FirebaseResult.error(errorMessage: 'Invalid user');
  }
}

class FirebaseResult {
  final dynamic data;

  /// Contains the error message for the request
  final String errorMessage;

  FirebaseResult({this.data}) : errorMessage = null;

  FirebaseResult.error({this.errorMessage}) : data = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage != null && errorMessage.isNotEmpty;
}
