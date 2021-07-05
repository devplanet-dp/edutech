import 'package:edutech/model/user.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/avatar_widget.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/viewmodel/account/user_account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class UserAccountView extends StatelessWidget {
  //text controllers:-----------------------------------------------------------
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutMeController = TextEditingController();

  //keys :-----------------------------------------------------------
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<UserAccountViewModel>.reactive(
      onModelReady: (model) {
        UserModel u = model.currentUser;
        _nameController.text = u.name;
        model.updateFields(_nameController );
      },
      builder: (context, model, child) => Scaffold(
        body: GestureDetector(
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                    title: 'account_update', isDark: model.isDark()),
                SliverPadding(
                  padding: fieldPadding,
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Text('update_account'),
                      verticalSpaceMedium,
                      _buildProfilePictureUpload(model),
                      verticalSpaceMedium,
                      _buildNameInput(model.isDark()),
                      verticalSpaceSmall,
                      _buildAboutMeInput(model.isDark()),
                      verticalSpaceSmall,
                      BoxButtonWidget(
                        buttonText: 'update',
                        buttonColor: kcPrimaryColor,
                        textColor: kAltWhite,
                        isLoading: model.busy,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            model.updateUserData(
                                userName: '',
                                name: _nameController.text,
                                aboutMe: _aboutMeController.text);
                          }
                        },
                      )
                    ]),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => UserAccountViewModel(),
    );
  }

  Widget _buildNameInput(var isDark) => AppTextField(
        initialValue: _nameController.text,
        controller: _nameController,
        isDark: isDark,
        fillColor: Colors.transparent,
        borderColor: kcAccent.withOpacity(0.4),
        hintText: 'Full name',
        validator: (value) {
          if (value.isEmpty) {
            return 'Name can not be empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildAboutMeInput(var isDark) => AppTextField(
        controller: _aboutMeController,
        isDark: isDark,
        minLine: 5,
        maxLength: 500,
        textInputAction: TextInputAction.newline,
        fillColor: Colors.transparent,
        borderColor: kcAccent.withOpacity(0.4),
        hintText: 'About Me',
      );

  Center _buildProfilePictureUpload(UserAccountViewModel model) {
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
          child: model.uploaded && model.selectedImage != null
              ? ClipOval(
                  child: Image.file(
                    model.selectedImage,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                  ),
                )
              : AvatarView(
                  height: 72,
                  widget: 72,
                  path: model.currentUser.profileUrl,
                  userName: model.currentUser.name)),
    ));
  }
}
