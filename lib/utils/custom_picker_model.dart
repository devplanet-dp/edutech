import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value';
  }

  CustomPicker({DateTime currentTime,  LocaleType locale}) : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.month);
    this.setMiddleIndex(this.currentTime.day);
    this.setRightIndex(this.currentTime.year);
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index < 12) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 30) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (index >= 1900 && index < 2300) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return "|";
  }

  @override
  String rightDivider() {
    return "|";
  }

  @override
  List<int> layoutProportions() {
    return [1, 2, 1];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(currentTime.year, currentTime.month, currentTime.day,
        this.currentLeftIndex(), this.currentMiddleIndex(), this.currentRightIndex())
        : DateTime(currentTime.year, currentTime.month, currentTime.day, this.currentLeftIndex(),
        this.currentMiddleIndex(), this.currentRightIndex());
  }
}