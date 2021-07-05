import 'package:cloud_firestore/cloud_firestore.dart';

class Config {
  String termsEN;
  String termsSP;
  String appDesc;
  String disclaimer;
  String founder;
  String founderMessage;
  String founderProfile;
  List<String> intro;

  Config({this.termsEN, this.termsSP, this.intro,this.founder,this.founderMessage,this.founderProfile});

  Config.fromMap(Map<dynamic, dynamic> json) {
    termsEN = json['terms_EN'];
    termsSP = json['terms_SP'];
    disclaimer = json['disclaimer'];
    founder = json['founder_name'];
    founderProfile = json['founder_profile'];
    founderMessage = json['founder_message'];
    appDesc = json['app_description'];
    intro = List.from(json['intro'] ?? []);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['terms_EN'] = this.termsEN;
    data['terms_SP'] = this.termsSP;
    data['disclaimer'] = this.disclaimer;
    data['app_description'] = this.appDesc;
    data['founder_name'] = this.founder;
    data['founder_profile'] = this.founderProfile;
    data['founder_message'] = this.founderMessage;
    data['intro'] = this.intro.toList();
    return data;
  }

  Config.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data());
}
