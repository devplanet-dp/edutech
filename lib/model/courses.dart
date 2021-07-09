import 'package:cloud_firestore/cloud_firestore.dart';

class Courses {
  List<String> title;

  Courses({this.title});

  Courses.fromMap(Map<dynamic, dynamic> json) {
    title = List.from(json['title'] ?? []);
  }

  Courses.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}
