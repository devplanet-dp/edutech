import 'package:edutech/viewmodel/base_model.dart';
import 'package:flutter/material.dart';

class FilterDrawerViewModel extends BaseModel{
  var formKey = GlobalKey<FormState>();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  DateTime _startDate;
  DateTime _endDate;

  DateTime get startDate => _startDate;

  DateTime get endDate => _endDate;

  void setStartDate(DateTime dateTime) {
    _startDate = dateTime;
    startDateController.text =
    "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
    endDateController.text = "";
    notifyListeners();
  }

  void clearFilter(){
    clearStartDate();
    clearEndDate();
    notifyListeners();
  }
  void setEndDate(DateTime dateTime) {
    _endDate = dateTime;
    endDateController.text =
    "${dateTime.year} - ${dateTime.month} - ${dateTime.day}";
    notifyListeners();
  }

  void clearEndDate(){
    _endDate = null;
    endDateController.text = '';
  }
  void clearStartDate(){
    _startDate = null;
    startDateController.text = '';
  }
}