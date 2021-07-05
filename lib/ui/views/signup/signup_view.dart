import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/frosted_app_bar.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/utils/validators.dart';
import 'package:edutech/viewmodel/signup/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SignUpView extends StatelessWidget {
  //keys :-----------------------------------------------------------
  var formKey = GlobalKey<FormState>();

  //text controllers:-----------------------------------------------------------
  TextEditingController _userEmailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        backgroundColor: kBgDark,
        body: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => DeviceUtils.hideKeyboard(context),
              child: Form(
                key: formKey,
                child: ListView(
                  addAutomaticKeepAlives: true,
                  cacheExtent: double.infinity,
                  padding: fieldPadding,
                  shrinkWrap: true,
                  children: [
                    verticalSpaceMassive,
                    Text(
                      'Sign up',
                      style: kHeading3Style.copyWith(color: kcAccent),
                    ),
                    Text(
                      'to enjoy the Intentions Experience',
                      style: kSubheadingStyle.copyWith(color: kcAccent),
                    ),
                    verticalSpaceMedium,
                    _buildNameInput(),
                    verticalSpaceSmall,
                    _buildEmailInput(),
                    verticalSpaceSmall,
                    _buildPasswordInput(
                        onSuffixTapped: model.toggleObscure,
                        isObscure: model.isObscure),
                    verticalSpaceSmall,
                    _buildConfirmPasswordInput(
                        onSuffixTapped: model.toggleObscure,
                        isObscure: model.isObscure),
                    verticalSpaceSmall,
                    _buildPrivacyButton(context, () {
                      model.navigateToTerms();
                    }),
                    verticalSpaceMedium,
                    BoxButtonWidget(
                      buttonText: 'Next',
                      textColor: kcPrimaryColor,
                      buttonColor: kcAccent,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          DeviceUtils.hideKeyboard(context);
                          model.signUp(
                            email: _userEmailController.text,
                            password: _passwordController.text,
                            fullName: _nameController.text,
                          );
                        }
                      },
                      isLoading: model.busy,
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ),
            FrostedAppBar(),
          ],
        ),
      ),
      viewModelBuilder: () => SignUpViewModel(),
    );
  }

  Widget _buildNameInput() => AppTextField(
        controller: _nameController,
        isDark: true,
        fillColor: Colors.transparent,
        borderColor: kcAccent.withOpacity(0.4),
        hintText: 'Full Name',
        validator: (value) {
          if (value.isEmpty) {
            return 'Name can not be empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildEmailInput() => AppTextField(
        isEmail: true,
        isCapitalize: false,
        borderColor: kcAccent.withOpacity(0.4),
        fillColor: Colors.transparent,
        isDark: true,
        controller: _userEmailController,
        hintText: 'Email',
        validator: (value) {
          if (Validator.isEmail(value)) {
            return null;
          } else if (value.isEmpty) {
            return 'We need an email here';
          } else {
            return 'Use a valid email';
          }
        },
      );

  Widget _buildPasswordInput(
          {@required VoidCallback onSuffixTapped, @required bool isObscure}) =>
      AppTextField(
        isPassword: isObscure,
        isDark: true,
        isCapitalize: false,
        suffix: InkWell(
          onTap: onSuffixTapped,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        borderColor: kcAccent.withOpacity(0.4),
        fillColor: Colors.transparent,
        controller: _passwordController,
        hintText: 'Password',
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
        isDark: true,
        isCapitalize: false,
        suffix: InkWell(
          onTap: onSuffixTapped,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        borderColor: kcAccent.withOpacity(0.4),
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

  Widget _buildPrivacyButton(BuildContext context, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        'By signing up, you agree to our Terms ,\n'
        ' Data Policy and Cookies Policy',
        textAlign: TextAlign.center,
        style: kBodyStyle.copyWith(
            color: kcAccent, decoration: TextDecoration.underline),
      ),
    );
  }
}
