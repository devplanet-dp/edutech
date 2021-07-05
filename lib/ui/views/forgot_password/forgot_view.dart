import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/utils/validators.dart';
import 'package:edutech/viewmodel/forgot_password/fogot_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ForgotView extends StatelessWidget {
  //keys :-----------------------------------------------------------
  final formKey = GlobalKey<FormState>();

  //text controllers:-----------------------------------------------------------
  final TextEditingController _userEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForgotViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Form(
                key: formKey,
                child: ListView(
                  padding: fieldPadding,
                  children: [
                    Text(
                      'Forgot Your Password?',
                      style: kHeading3Style,
                    ),
                    Text(
                        'Enter the email address associated \nwith your account.',
                        style: kBodyStyle),
                    verticalSpaceMedium,
                    _buildEmailInput(),
                    verticalSpaceMedium,
                    BoxButtonWidget(
                      buttonText: 'Reset password',
                      textColor: kAltWhite,
                      onPressed: () {
                        if (formKey.currentState.validate()) {
                          model.sendResetPassowrd(
                            email: _userEmailController.text,
                          );
                        }
                      },
                      isLoading: model.busy,
                    ),
                    verticalSpaceMedium,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => ForgotViewModel(),
    );
  }

  Widget _buildEmailInput() => AppTextField(
        isEmail: true,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        isDark: false,
        isCapitalize: false,
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
}
