import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/services/cloud_storage_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/services/image_selector.dart';
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

  DateTime _regDate;

  DateTime get dateReg => _regDate;

  File _attachment;

  File get attachment => _attachment;

  bool get haveMedia => attachment != null;

  Future selectImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _attachment = File(tempImage.path);
      notifyListeners();
    }
  }

  void setBirthDate(DateTime regDate) {
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

  Future<bool> addPost() async {
    setBusy(true);
    var id = Uuid().v1();
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
        yearStudy: selectedYear,
        registeredFor: selectedRegType,
        leadSource: selectedLeadSource,
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

    super.dispose();
  }
}
