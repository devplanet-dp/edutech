import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/viewmodel/profile/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:stacked/stacked.dart';
import 'package:edutech/ui/shared/app_colors.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(title: 'Profile Photo', isDark: false),
            SliverPadding(
              padding: fieldPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  verticalSpaceSmall,
                  Text(
                    'Add a photo to your profile.',
                    style: kBodyStyle,
                  ),
                  verticalSpaceMedium,
                  _buildProfilePictureUpload(model),
                  verticalSpaceMedium,
                  BoxButtonWidget(
                    buttonColor: model.uploaded ? kcAccent : kAltWhite,
                    buttonText: model.uploaded ? 'Next' : 'Skip',
                    textColor: kAltWhite,
                    isLoading: model.busy,
                    onPressed: () {
                      if (model.uploaded) {
                        model.updateUserProfile();
                      } else {
                        model.navigateToSignUpComplete();
                      }
                    },
                  )
                ]),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }

  Center _buildProfilePictureUpload(ProfileViewModel model) {
    return Center(
        child: MaterialButton(
      elevation: 2,
      shape: CircleBorder(),
      onPressed: () {
        model.clearImage();
        model.selectImage();
      },
      child: CircleAvatar(
          radius: 54,
          backgroundColor: kcPrimaryColor,
          child: model.uploaded && model.selectedImage != null
              ? ClipOval(
                  child: Image.file(
                    model.selectedImage,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: (LineIcon.camera(
                    size: 32,
                    color: kAltWhite,
                  )),
                )),
    ));
  }
}
