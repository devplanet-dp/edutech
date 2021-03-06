import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutech/model/courses.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/services/cloud_storage_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/services/image_selector.dart';
import 'package:edutech/utils/app_utils.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

import '../../locator.dart';

class AddSaleViewModel extends BaseModel {
  final _firestoreService = locator<FirestoreService>();
  final _dialogService = locator<DialogService>();
  final _imageSelector = locator<ImageSelector>();
  final _cloudStorageService = locator<CloudStorageService>();
  final _navigationService = locator<NavigationService>();

  ///text edit controllers
  final studentNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final dateRegController = TextEditingController();
  final collegeController = TextEditingController();
  final regTypeController = TextEditingController();
  final leadSourceController = TextEditingController();
  final pointContactController = TextEditingController();
  final amountPaidController = TextEditingController();
  final courseFeeController = TextEditingController();
  final courseNameController = TextEditingController();

  DateTime _regDate;

  DateTime get dateReg => _regDate;

  File _attachment;

  File get attachment => _attachment;

  bool get haveMedia => attachment != null;

  Courses _courses;

  Courses get courses => _courses;

  Future selectImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _attachment = File(tempImage.path);
      notifyListeners();
    }
  }

  void setRegDate(DateTime regDate) {
    _regDate = regDate;
    dateRegController.text =
        "${regDate?.month}-${regDate?.day}-${regDate?.year}";
    notifyListeners();
  }

  clearImage() {
    _attachment = null;
    notifyListeners();
  }

  ///year study
  String _selectedYear = YEAR_STUDY[0];

  String get selectedYear => _selectedYear;

  bool isYearSelected(String year) => selectedYear == year;

  void setYearStudy(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  ///program type
  ProgramType _programType = ProgramType.SELD_PACED;

  ProgramType get selectedProgramType => _programType;

  bool isProgSelected(ProgramType type) => selectedProgramType == type;

  void setProgType(ProgramType type) {
    _programType = type;
    notifyListeners();
  }

  ///registered for
  RegisterType _regType = RegisterType.VERZEO;

  RegisterType get selectedRegType => _regType;

  bool isRegSelected(RegisterType type) => selectedRegType == type;

  void setRegType(RegisterType type) {
    _regType = type;
    notifyListeners();
  }

  ///lead source
  LeadSource _leadSource = LeadSource.SELF_GENERATED;

  LeadSource get selectedLeadSource => _leadSource;

  bool isLeadSelected(LeadSource type) => selectedLeadSource == type;

  void setLeadSource(LeadSource type) {
    _leadSource = type;
    notifyListeners();
  }

  void setCourseName(String name) {
    courseNameController.text = name;
    _navigationService.back();
    notifyListeners();
  }

  void setAmountPaid(String amount) {
    amountPaidController.text = amount;
    _navigationService.back();
    notifyListeners();
  }

  void setCourseFee(String amount) {
    courseFeeController.text = amount;
    _navigationService.back();
    notifyListeners();
  }

  Future getCourses() async {
    setBusy(true);
    var result = await _firestoreService.getAllCourses();

    if (!result.hasError) {
      _courses = result.data as Courses;
      setBusy(false);
    } else {
      setBusy(false);
      _dialogService.showDialog(
          title: 'Oops', description: result.errorMessage);
    }
  }

  Future<bool> addPost({String saleId}) async {
    setBusy(true);
    var id = saleId == null ? Uuid().v1() : saleId;
    CloudStorageResult storageResult;

    storageResult = await _cloudStorageService.uploadImage(
      imageToUpload: _attachment,
      id: id,
    );

    var result = await _firestoreService.addSale(Sale(
        id: id,
        userId: currentUser.userId,
        createdAt: Timestamp.now(),
        studentName: studentNameController.text,
        paymentProof: storageResult.imageUrl,
        email: emailController.text,
        mobileNumber: mobileController.text,
        dateRegistration: Timestamp.fromDate(dateReg),
        collegeName: collegeController.text,
        courseName: courseNameController.text,
        yearStudy: selectedYear,
        registeredFor: selectedRegType,
        leadSource: selectedLeadSource,
        programType: selectedProgramType,
        pointContact: pointContactController.text,
        amountPaid: double.parse(amountPaidController.text),
        courseFee: double.parse(courseFeeController.text)));

    setBusy(false);

    if (result.hasError) {
      await _dialogService.showDialog(
        title: 'Could not add sale',
        description: result.errorMessage,
      );
    } else {
      await _dialogService.showDialog(
        title: 'Success',
        description: 'Your sale has been created',
      );
      resetView();
    }
    return result != null;
  }

  setData(Sale sale) async {
    setBusy(true);
    if (sale.paymentProof.isNotEmpty) {
      _attachment = await urlToFile(sale.paymentProof);
    }
    studentNameController.text = sale.studentName;
    emailController.text = sale.email;
    mobileController.text = sale.mobileNumber;
    setRegDate(sale.dateRegistration.toDate());
    collegeController.text = sale.collegeName;
    courseNameController.text = sale.courseName;
    setProgType(sale.programType);
    setYearStudy(sale.yearStudy);
    setRegType(sale.registeredFor);
    setLeadSource(sale.leadSource);
    amountPaidController.text = sale.amountPaid.toString();
    courseFeeController.text = sale.courseFee.toString();
    setBusy(false);
    notifyListeners();
  }

  resetView() {
    _attachment = null;
    studentNameController.text = '';
    emailController.text = '';
    mobileController.text = '';
    dateRegController.text = '';
    collegeController.text = '';
    regTypeController.text = '';
    leadSourceController.text = '';
    pointContactController.text = '';
    amountPaidController.text = '';
    courseFeeController.text = '';
    courseNameController.text = '';
    notifyListeners();
  }

  @override
  void dispose() {
    studentNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    dateRegController.dispose();
    collegeController.dispose();
    regTypeController.dispose();
    leadSourceController.dispose();
    pointContactController.dispose();
    amountPaidController.dispose();
    courseFeeController.dispose();
    courseNameController.dispose();

    super.dispose();
  }
}
