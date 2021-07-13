import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutech/model/config.dart';
import 'package:edutech/model/courses.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _saleCollectionReference =
      FirebaseFirestore.instance.collection(TB_SALE);

  final CollectionReference _courseCollectionReference =
      FirebaseFirestore.instance.collection(TB_COURSES);

  final StreamController<List<UserModel>> _userController =
      StreamController<List<UserModel>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<UserModel>> _allPagedResults = [];

  static const int UserLimit = 20;

  DocumentSnapshot _lastDocument;
  bool _hasMoreUsers = true;

  Config _config;

  Config get config => _config;

  static const TB_SALE = 'sale';
  static const TB_COURSES = 'courses';

  FirebaseFirestore _firestore;

  FirestoreService() {
    this._firestore = FirebaseFirestore.instance;
  }

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference
          .doc(user.userId)
          .set(user.toJson(), SetOptions(merge: true));
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateUserProfile({String uid, String profileUri}) async {
    try {
      await _usersCollectionReference
          .doc(uid)
          .update({'profileUrl': profileUri});
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream listenToUserslTime(String searchKey) {
    // Register the handler for when the posts data changes
    _requestMoreUsers(searchKey);
    return _userController.stream;
  }

  // #1: Move the request posts into it's own function
  void _requestMoreUsers(String searchKey) {
    // #2: split the query from the actual subscription
    var pagePostsQuery = _usersCollectionReference
        .orderBy('createdDate', descending: true)
        // #3: Limit the amount of results
        .limit(UserLimit);
    // #5: If we have a document start the query after it
    if (_lastDocument != null) {
      pagePostsQuery = pagePostsQuery.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreUsers) return;

    // #7: Get and store the page index that the results belong to
    var currentRequestIndex = _allPagedResults.length;

    pagePostsQuery.snapshots().listen((postsSnapshot) {
      if (postsSnapshot.docs.isNotEmpty) {
        var users = postsSnapshot.docs
            .map((snapshot) => UserModel.fromSnapshot(snapshot))
            .toList();

        // #8: Check if the page exists or not
        var pageExists = currentRequestIndex < _allPagedResults.length;

        // #9: If the page exists update the posts for that page
        if (pageExists) {
          _allPagedResults[currentRequestIndex] = users;
        }
        // #10: If the page doesn't exist add the page data
        else {
          _allPagedResults.add(users);
        }

        // #11: Concatenate the full list to be shown
        var allPosts = _allPagedResults.fold<List<UserModel>>(
            [], (initialValue, pageItems) => initialValue..addAll(pageItems));

        // #12: Broadcase all posts
        _userController.add(allPosts);

        // #13: Save the last document from the results only if it's the current last page
        if (currentRequestIndex == _allPagedResults.length - 1) {
          _lastDocument = postsSnapshot.docs.last;
        }

        // #14: Determine if there's more posts to request
        _hasMoreUsers = users.length == UserLimit;
      }
    });
  }

  void requestMoreUsers(searchKey) => _requestMoreUsers(searchKey);

  Future updateUserAboutMe(
      {String uid, String aboutMe, String favCharacter}) async {
    try {
      await _usersCollectionReference
          .doc(uid)
          .update({'favoriteCharacter': favCharacter, 'aboutMe': aboutMe});
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Stream<List<UserModel>> searchUsers(
      {int limit = 10, String searchKey, @required currentUid}) {
    Stream<QuerySnapshot> snap = searchKey.isNotEmpty
        ? _usersCollectionReference
            .where('name', isGreaterThanOrEqualTo: searchKey)
            .where('name', isLessThan: searchKey + 'z')
            .limit(limit)
            .snapshots()
        : _usersCollectionReference
            .where('userId', isNotEqualTo: currentUid)
            .limit(limit)
            .snapshots();

    return snap.map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
  }

  Stream<List<UserModel>> searchAllUsers(
      {String searchKey, @required currentUid}) {
    Stream<QuerySnapshot> snap = searchKey.isNotEmpty
        ? _usersCollectionReference
            .where('name', isGreaterThanOrEqualTo: searchKey)
            .where('name', isLessThan: searchKey + 'z')
            .snapshots()
        : _usersCollectionReference
            .where('userId', isNotEqualTo: currentUid)
            .snapshots();

    return snap.map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
  }

  Stream<List<UserModel>> streamAllUsers(String currentUid) {
    Stream<QuerySnapshot> snap = _usersCollectionReference
        .where('userId', isNotEqualTo: currentUid)
        .snapshots();

    return snap.map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromSnapshot(doc)).toList());
  }

  Future updateUserData(
      {String uid,
      String profileUri,
      String userName,
      String name,
      String aboutMe,
      String favCharacter,
      Timestamp birthDay}) async {
    try {
      await _usersCollectionReference.doc(uid).update({
        'profileUrl': profileUri,
        'userName': userName,
        'name': name,
      });
      return true;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromSnapshot(userData);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<UserModel> getUserById(String uid) async {
    var userData = await _usersCollectionReference.doc(uid).get();
    return UserModel.fromSnapshot(userData);
  }

  Future<List<UserModel>> getAllUsers() async {
    QuerySnapshot snap = await _usersCollectionReference
        .where('isSuperAdmin', isEqualTo: false)
        .get();

    return snap.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
  }

  Stream<UserModel> streamUser(String uid) {
    var snap = _usersCollectionReference.doc(uid).snapshots();
    return snap.map((doc) => UserModel.fromSnapshot(doc));
  }

  Future<FirebaseResult> getAllCourses() async {
    try {
      QuerySnapshot snap = await _courseCollectionReference.get();
      return FirebaseResult(
          data: snap.docs.map((doc) => Courses.fromSnapshot(doc)).toList()[0]);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message);
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> addSale(Sale sale) async {
    try {
      await _saleCollectionReference
          .doc(sale.id)
          .set(sale.toJson(), SetOptions(merge: true));
      return FirebaseResult(data: sale);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message);
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Future<FirebaseResult> removeSale(Sale sale) async {
    try {
      if (sale.paymentProof != null && sale.paymentProof.isNotEmpty) {
        try {
          var fileUrl = Uri.decodeFull(Path.basename(sale.paymentProof))
              .replaceAll(new RegExp(r'(\?alt).*'), '');

          await FirebaseStorage.instance.ref().child(fileUrl).delete();
        } catch (e) {
          return FirebaseResult.error(errorMessage: e.message);
        }
      }
      await _saleCollectionReference.doc(sale.id).delete();
      return FirebaseResult(data: true);
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message);
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<Sale>> streamMySales(String uid) {
    Stream<QuerySnapshot> snap = _saleCollectionReference
        .where('user_id', isEqualTo: uid)
        .orderBy('created_at', descending: true)
        .snapshots();

    return snap.map((snapshot) =>
        snapshot.docs.map((doc) => Sale.fromJson(doc.data())).toList());
  }

  Future<FirebaseResult> getMySales(String uid) async {
    try {
      QuerySnapshot snap =
          await _saleCollectionReference.where('user_id', isEqualTo: uid).get();
      return FirebaseResult(
          data: snap.docs.map((doc) => Sale.fromSnapshot(doc)).toList());
    } catch (e) {
      if (e is PlatformException) {
        return FirebaseResult.error(errorMessage: e.message);
      }

      return FirebaseResult.error(errorMessage: e.toString());
    }
  }

  Stream<List<Sale>> streamSales({int limit}) {
    Stream<QuerySnapshot> snap = limit == null
        ? _saleCollectionReference.snapshots()
        : _saleCollectionReference.limit(limit).snapshots();

    return snap.map((snapshot) =>
        snapshot.docs.map((doc) => Sale.fromJson(doc.data())).toList());
  }

  Stream<List<Sale>> search({int limit = 100, @required String searchKey}) {
    // Register the handler for when the posts data changes
    Stream<QuerySnapshot> snap = searchKey.isNotEmpty
        ? _firestore
            .collection(TB_SALE)
            .where('title', isGreaterThanOrEqualTo: searchKey)
            .where('title', isLessThan: searchKey + 'z')
            .limit(limit)
            .snapshots()
        : _saleCollectionReference.limit(limit).snapshots();

    return snap.map((snapshot) =>
        snapshot.docs.map((doc) => Sale.fromSnapshot(doc)).toList());
  }
}
