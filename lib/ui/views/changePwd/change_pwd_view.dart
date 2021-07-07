import 'package:edutech/viewmodel/changepwd/change_pwd_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';

class ChangePasswordView extends StatelessWidget {
  //keys :-----------------------------------------------------------
  var formKey = GlobalKey<FormState>();

  TextEditingController _currentPasswordController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChangePwdViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: GestureDetector(
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: Form(
            key: formKey,
            child: CustomScrollView(
              slivers: [
                CustomSliverAppBar(
                  title: 'Change Password',
                  isDark: model.isDark(),
                  showLeading: true,
                ),
                SliverPadding(
                  sliver: SliverList(
                      delegate: SliverChildListDelegate([
                    verticalSpaceMedium,
                    Text(
                        'Enter your new password below'),
                    verticalSpaceMedium,
                    _buildCurrentPassword(
                        onSuffixTapped: model.toggleObscure,
                        isObscure: model.isObscure),
                    verticalSpaceSmall,
                    _buildPasswordInput(
                        onSuffixTapped: model.toggleObscure,
                        isObscure: model.isObscure),
                    verticalSpaceSmall,
                    _buildConfirmPasswordInput(
                        onSuffixTapped: model.toggleObscure,
                        isObscure: model.isObscure),
                    verticalSpaceSmall,
                    BoxButtonWidget(
                      buttonText: 'Change',
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          DeviceUtils.hideKeyboard(context);
                          model.updatePassword(
                              password: _currentPasswordController.text,
                              newPassword: _passwordController.text);
                        }
                      },
                      isLoading: model.busy,
                    )
                  ])),
                  padding: fieldPaddingAll,
                )
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => ChangePwdViewModel(),
    );
  }

  Widget _buildCurrentPassword(
          {@required VoidCallback onSuffixTapped, @required bool isObscure}) =>
      AppTextField(
        isPassword: isObscure,
        isDark: false,
        isCapitalize: false,
        suffix: InkWell(
          onTap: onSuffixTapped,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        controller: _currentPasswordController,
        hintText: 'Current Password',
        validator: (value) {
          if (value.isEmpty) {
            return 'We need the current password here';
          } else {
            return null;
          }
        },
      );

  Widget _buildPasswordInput(
          {@required VoidCallback onSuffixTapped, @required bool isObscure}) =>
      AppTextField(
        isPassword: isObscure,
        isDark: false,
        isCapitalize: false,
        suffix: InkWell(
          onTap: onSuffixTapped,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        controller: _passwordController,
        hintText: 'New Password',
        validator: (value) {
          if (value.isEmpty) {
            return 'We need a password here';
          } else {
            return null;
          }
        },
      );

  Widget _buildConfirmPasswordInput(
          {@required VoidCallback onSuffixTapped, @required bool isObscure}) =>
      AppTextField(
        isPassword: isObscure,
        isDark: false,
        isCapitalize: false,
        suffix: InkWell(
          onTap: onSuffixTapped,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        controller: _confirmPasswordController,
        hintText: 'Confirm Password',
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter the password to confirm';
          } else if (_passwordController.text.isNotEmpty &&
              _passwordController.text != value) {
            return 'Sorry! The Passwords doesn\'t match';
          } else {}
        },
      );
}
