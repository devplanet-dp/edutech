import 'dart:io';

import 'package:edutech/services/cloud_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/services/auth_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/services/image_selector.dart';
import 'package:edutech/ui/shared/app_colors.dart';

import '../../locator.dart';
import '../base_model.dart';

class UserAccountViewModel extends BaseModel {
  final _navigationService = locator<NavigationService>();
  final _firestoreService = locator<FirestoreService>();
  final _authService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _imageSelector = locator<ImageSelector>();
  final _cloudStorageService = locator<CloudStorageService>();

  bool _isUploaded = false;

  File _selectedImage;

  File get selectedImage => _selectedImage;

  bool get uploaded => _isUploaded;
  void updateFields(TextEditingController nameController){
    nameController.text = currentUser.name;
    notifyListeners();
  }

  Future selectImage() async {
    var tempImage = await _imageSelector.selectImage();
    if (tempImage != null) {
      _selectedImage = await _cropImage(imageFile: File(tempImage.path));
      _isUploaded = true;
      notifyListeners();
    }
  }

  Future<File> _cropImage({@required File imageFile}) async {
    File croppedFile = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: imageFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: kcPrimaryColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }

  clearImage() {
    _isUploaded = false;
    _selectedImage = null;
    notifyListeners();
  }

  Future updateUserData(
      {@required String userName,
      @required String name,
      @required String aboutMe}) async {
    setBusy(true);
    CloudStorageResult storageResult;
    if (_isUploaded) {
      storageResult = await _cloudStorageService.uploadImage(
          imageToUpload: _selectedImage,
          id: currentUser.userId,
          isProfile: true);
    }

    var result = await _firestoreService.updateUserData(
        aboutMe: aboutMe ?? '',
        uid: currentUser.userId,
        profileUri:
            _isUploaded ? storageResult.imageUrl : currentUser.profileUrl,
        userName: userName,
        name: name);

    _authService.updateCurrentUser();

    setBusy(false);

    if (result is bool) {
      if (result) {
        await _dialogService.showDialog(
          title: 'Account update',
          description: 'Account details updated successfully',
        );
        _navigationService.back(result: true);
      } else {
        await _dialogService.showDialog(
          title: 'Account update',
          description:
              'Something went wrong with profile. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Account update',
        description: result,
      );
    }
  }
}
