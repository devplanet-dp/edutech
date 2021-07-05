import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/viewmodel/forgot_password/fogot_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ResetPasswordView extends StatelessWidget {
  final String email;

  ResetPasswordView({Key key, this.email}) : super(key: key);

  //keys :-----------------------------------------------------------
  final formKey = GlobalKey<FormState>();

  //text controllers:-----------------------------------------------------------
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: noTitleAppBar(isLight: false),
        backgroundColor: kBgDark,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: Form(
            key: formKey,
            child: ListView(
              padding: fieldPadding,
              children: [
                Text(
                  'Verify your email',
                  style: kHeading3Style,
                ),
                Text(
                  'Please enter the code sent to \n$email',
                  style: kSubheadingStyle,
                ),
                verticalSpaceMedium,
                _buildCodeInput(),
                verticalSpaceSmall,
                _buildPasswordInput(),
                verticalSpaceMedium,
                BoxButtonWidget(
                  buttonText: 'Confirm',
                  textColor: kcPrimaryColor,
                  buttonColor: kcAccent,
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      model.sendConfirmCode(
                        code: _codeController.text,
                        passowrd: _passwordController.text,
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
      ),
      viewModelBuilder: () => ForgotViewModel(),
    );
  }

  Widget _buildCodeInput() => AppTextField(
        controller: _codeController,
        isDark: true,
        fillColor: Colors.transparent,
        borderColor: kcAccent.withOpacity(0.4),
        hintText: 'Verification code',
        validator: (value) {
          if (value.isEmpty) {
            return 'code can not be empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildPasswordInput() => AppTextField(
        isPassword: true,
        isDark: true,
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
}
