import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/utils/margin.dart';
import 'package:edutech/utils/validators.dart';
import 'package:edutech/viewmodel/login/login_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  //keys :-----------------------------------------------------------
  final formKey = GlobalKey<FormState>();

  //text controllers:-----------------------------------------------------------
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: SingleChildScrollView(
            child: Padding(
              padding: fieldPadding,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'welcome',
                        style: kHeading2Style,
                      ),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: _buildSignUpContent(model.navigateToSignUp)),
                    YMargin(context.screenHeight(percent: 0.1)),
                    _buildEmailInput(),
                    verticalSpaceSmall,
                    _buildPasswordInput(
                        onSuffixTapped: model.toggleObscure,
                        isObscure: model.isObscure),
                    verticalSpaceSmall,
                    _buildForgetPassword(model.navigateToForgotPassword),
                    verticalSpaceSmall,
                    BoxButtonWidget(
                      buttonText: 'sign_in',
                      isLoading: model.busy,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          model.login(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                        }
                      },
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LoginViewModel(),
    );
  }

  Widget _buildEmailInput() => AppTextField(
        isEmail: true,
        isCapitalize: false,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        isDark: false,
        controller: emailController,
        hintText: 'email.hint',
        validator: (value) {
          if (Validator.isEmail(value)) {
            return null;
          } else if (value.isEmpty) {
            return 'email.empty';
          } else {
            return 'email.valid';
          }
        },
      );

  Widget _buildPasswordInput(
          {@required VoidCallback onSuffixTapped, @required bool isObscure}) =>
      AppTextField(
        isPassword: isObscure,
        isDark: false,
        isCapitalize: false,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        suffix: InkWell(
          onTap: onSuffixTapped,
          child: Icon(isObscure
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined),
        ),
        controller: passwordController,
        hintText: 'pwd.hint',
        validator: (value) {
          if (value.isEmpty) {
            return 'pwd.empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildSignUpContent(VoidCallback onSignUpTapped) {
    return RichText(
      text: TextSpan(
          text: 'sign_in_note',
          style: kBodyStyle.copyWith(color: kAltBg),
          children: [
            TextSpan(
                text: 'create_account',
                style: kBodyStyle.copyWith(color: kcPrimaryColor),
                recognizer: TapGestureRecognizer()..onTap = onSignUpTapped)
          ]),
    );
  }

  Widget _buildForgetPassword(VoidCallback onFogotPasswordTapped) {
    return Align(
        alignment: Alignment.topRight,
        child: TextButton(
          onPressed: onFogotPasswordTapped,
          child: Text('forgot_pwd', style: kBodyStyle),
        ));
  }
}
