import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutech/model/config.dart';
import 'package:edutech/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as Path;

class FirestoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _postsCollectionReference =
      FirebaseFirestore.instance.collection('posts');

  final CollectionReference _chatCollectionReference =
      FirebaseFirestore.instance.collection('rooms');
  final CollectionReference _configCollectionReference =
      FirebaseFirestore.instance.collection('config');

  final CollectionReference _jobCollectionReference =
      FirebaseFirestore.instance.collection('job');

  final CollectionReference _businessCollectionReference =
      FirebaseFirestore.instance.collection(TB_BUSINESS);

  final StreamController<List<UserModel>> _userController =
      StreamController<List<UserModel>>.broadcast();

  // #6: Create a list that will keep the paged results
  List<List<UserModel>> _allPagedResults = [];

  static const int UserLimit = 20;

  DocumentSnapshot _lastDocument;
  bool _hasMoreUsers = true;

  Config _config;

  Config get config => _config;

  static const TB_POST = 'posts';
  static const TB_USERS = 'users';
  static const TB_PURCHASE = 'purchase';
  static const TB_COMMENT = 'comment';
  static const TB_REPLY = 'reply';
  static const TB_LIKE = 'like';
  static const TB_UNLIKE = 'unlike';
  static const TB_MEMBER = 'member';
  static const TB_RATTINGS = 'ratting';
  static const TB_NOTIFICATION = 'notifications';
  static const TB_BUSINESS = 'business';
  static const TB_CONTRACTS = 'contracts';
  static const TB_INVESTOR = 'investor';
  static const TB_JOB = 'job';

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

  Future getAppConfig() async {
    try {
      var querySnap = await _configCollectionReference.get();
      _config = Config.fromMap(querySnap.docs[0].data());
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

  Future<UserModel> getUserByUserName(String userName) async {
    QuerySnapshot snap = await _usersCollectionReference
        .where('userName', isEqualTo: userName)
        .get();
    return snap.docs.map((doc) => UserModel.fromSnapshot(doc)).first;
  }

  Future<List<UserModel>> getSuperAdmins() async {
    QuerySnapshot snap = await _usersCollectionReference
        .where('isSuperAdmin', isEqualTo: true)
        .get();

    return snap.docs.map((doc) => UserModel.fromSnapshot(doc)).toList();
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


  ///business
  // Future<FirebaseResult> addBusiness(BusinessModel business) async {
  //   try {
  //     await _businessCollectionReference
  //         .doc(business.id)
  //         .set(business.toJson(), SetOptions(merge: true));
  //     return FirebaseResult(data: business);
  //   } catch (e) {
  //     if (e is PlatformException) {
  //       return FirebaseResult.error(errorMessage: e.message);
  //     }
  //
  //     return FirebaseResult.error(errorMessage: e.toString());
  //   }
  // }
  //
  // Future<FirebaseResult> removeBusiness(BusinessModel business) async {
  //   try {
  //     if (business.images != null && business.images.isNotEmpty) {
  //       try {
  //         var fileUrl = Uri.decodeFull(Path.basename(business.images))
  //             .replaceAll(new RegExp(r'(\?alt).*'), '');
  //
  //         await FirebaseStorage.instance.ref().child(fileUrl).delete();
  //       } catch (e) {
  //         return FirebaseResult.error(errorMessage: e.message);
  //       }
  //     }
  //     await _businessCollectionReference.doc(business.id).delete();
  //     return FirebaseResult(data: true);
  //   } catch (e) {
  //     if (e is PlatformException) {
  //       return FirebaseResult.error(errorMessage: e.message);
  //     }
  //
  //     return FirebaseResult.error(errorMessage: e.toString());
  //   }
  // }
  //
  // Stream<List<BusinessModel>> streamMyBusiness(String uid) {
  //   Stream<QuerySnapshot> snap = _businessCollectionReference
  //       .where('user_id', isEqualTo: uid)
  //       .orderBy('created_at', descending: true)
  //       .snapshots();
  //
  //   return snap.map((snapshot) => snapshot.docs
  //       .map((doc) => BusinessModel.fromJson(doc.data()))
  //       .toList());
  // }
  //
  // Stream<List<BusinessModel>> streamRecentBusiness({int limit = 5}) {
  //   Stream<QuerySnapshot> snap =
  //       _businessCollectionReference.limit(limit).snapshots();
  //
  //   return snap.map((snapshot) => snapshot.docs
  //       .map((doc) => BusinessModel.fromJson(doc.data()))
  //       .toList());
  // }
  //
  // Stream<List<BusinessModel>> searchBusiness(
  //     {int limit = 100, @required String searchKey}) {
  //   // Register the handler for when the posts data changes
  //   Stream<QuerySnapshot> snap = searchKey.isNotEmpty
  //       ? _firestore
  //           .collection(TB_BUSINESS)
  //           .where('title', isGreaterThanOrEqualTo: searchKey)
  //           .where('title', isLessThan: searchKey + 'z')
  //           .limit(limit)
  //           .snapshots()
  //       : _businessCollectionReference.limit(limit).snapshots();
  //
  //   return snap.map((snapshot) =>
  //       snapshot.docs.map((doc) => BusinessModel.fromSnapshot(doc)).toList());
  // }


}
