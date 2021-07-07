import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  String name;
  String email;
  String profileUrl;
  String userId;
  bool isActive;
  bool isAdmin;
  Timestamp createdDate;

  UserModel(
      {this.name,
        this.email,
        this.profileUrl = '',
        this.userId,
        this.isAdmin,
        this.createdDate,
        this.isActive = true});

  UserModel.fromMap(Map<dynamic, dynamic> json) {
    name = json['name'];
    email = json['email'];
    profileUrl = json['profileUrl'];
    userId = json['userId'];
    isAdmin = json['isAdmin']??false;
    isActive = json['isActive'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['profileUrl'] = this.profileUrl;
    data['userId'] = this.userId;
    data['isActive'] = this.isActive;
    data['isAdmin'] = this.isAdmin;
    data['createdDate'] = this.createdDate;
    return data;
  }

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}
