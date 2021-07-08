import 'package:cloud_firestore/cloud_firestore.dart';

const List<double> AMOUNT_PAID = [
  1000,
  2000,
  3000,
  3500,
  4000,
  4500,
  5000,
  5500,
  7000,
  7500,
  10000
];

const List<double> COURSE_FEE = [
  3000,
  3500,
  4500,
  5500,
  6500,
  7000,
  7500,
  15000,
  20000,
  25000
];

const List<String> YEAR_STUDY = [
  '1st Year',
  '2nd year',
  '3rd Year',
  '4th Year',
  'Others',
];

enum LeadSource { SELF_GENERATED, CGFL, RSL }
enum RegisterType { VERZEO, SMARTKNOWER }

class Sale {
  String id;
  String userId;
  Timestamp createdAt;
  String studentName;
  String email;
  String mobileNumber;
  Timestamp dateRegistration;
  String collegeName;
  String yearStudy;
  RegisterType registeredFor;
  LeadSource leadSource;
  String pointContact;
  double amountPaid;
  double courseFee;
  String paymentProof;

  Sale(
      {this.id,
      this.userId,
      this.createdAt,
      this.studentName,
      this.email,
      this.mobileNumber,
      this.dateRegistration,
      this.collegeName,
      this.yearStudy,
      this.registeredFor,
      this.leadSource,
      this.pointContact,
      this.amountPaid,
      this.courseFee,
      this.paymentProof});

  bool get isPaymentCompleted => amountPaid == courseFee;

  Sale.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    studentName = json['student_name'];
    email = json['email'];
    mobileNumber = json['mobile_number'];
    dateRegistration = json['date_registration'];
    collegeName = json['college_name'];
    yearStudy = json['year_study'];
    registeredFor = RegisterType.values.elementAt(json['registered_for']) ??
        RegisterType.VERZEO;
    leadSource =
        LeadSource.values.elementAt(json['lead_source']) ?? RegisterType.VERZEO;
    pointContact = json['point_contact'];
    amountPaid = json['amount_paid'];
    courseFee = json['course_fee'];
    paymentProof = json['payment_proof'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['student_name'] = this.studentName;
    data['email'] = this.email;
    data['mobile_number'] = this.mobileNumber;
    data['date_registration'] = this.dateRegistration;
    data['college_name'] = this.collegeName;
    data['year_study'] = this.yearStudy;
    data['registered_for'] = this.registeredFor.index;
    data['lead_source'] = this.leadSource.index;
    data['point_contact'] = this.pointContact;
    data['amount_paid'] = this.amountPaid;
    data['course_fee'] = this.courseFee;
    data['payment_proof'] = this.paymentProof;
    return data;
  }

  Sale.fromSnapshot(DocumentSnapshot snapshot) : this.fromJson(snapshot.data());
}
