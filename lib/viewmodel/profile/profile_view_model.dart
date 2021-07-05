import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:edutech/constants/route_name.dart';
import 'package:edutech/services/cloud_storage_service.dart';
import 'package:edutech/services/firestore_service.dart';
import 'package:edutech/services/image_selector.dart';
import 'package:edutech/ui/shared/app_colors.dart';

import '../../locator.dart';
import '../base_model.dart';

class ProfileViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final DialogService _dialogService = locator<DialogService>();
  final ImageSelector _imageSelector = locator<ImageSelector>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  bool _isUploaded = false;

  File _selectedImage;

  File get selectedImage => _selectedImage;

  bool get uploaded => _isUploaded;

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

  Future updateUserProfile() async {
    setBusy(true);
    CloudStorageResult storageResult = await _cloudStorageService.uploadImage(
        imageToUpload: _selectedImage, id: currentUser.userId, isProfile: true);

    var result = await _firestoreService.updateUserProfile(
        uid: currentUser.userId, profileUri: storageResult.imageUrl);

    setBusy(false);

    if (result is bool) {
      if (result) {
        navigateToSignUpComplete();
      } else {
        await _dialogService.showDialog(
          title: 'Profile upload',
          description:
              'Something went wrong with profile. Please try again later',
        );
      }
    } else {
      await _dialogService.showDialog(
        title: 'Profile upload',
        description: result,
      );
    }
  }

  void navigateToSignUpComplete() {
    _navigationService.navigateTo(SignUpCompleteRoute);
  }
}
