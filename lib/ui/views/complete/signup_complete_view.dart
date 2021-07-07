import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/viewmodel/complete/signup_complete_view_model.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:stacked/stacked.dart';

class SignUpCompleteView extends StatelessWidget {
  const SignUpCompleteView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SignUpCompleteViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Padding(
          padding: fieldPadding,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    verticalSpaceMedium,
                    Text(
                      'Congratulations!',
                      style: kHeading3Style,
                    ),
                    Text(
                      'Your account has been setup successfully!',
                      style: kBodyStyle,
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: Alignment.center,
                  child: LineIcon.checkCircleAlt(
                    color: kcPrimaryColor,
                    size: 72,
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: context.screenWidth(percent: 1),
                  height: 50,
                  margin: const EdgeInsets.symmetric(
                      vertical: 24.0, horizontal: 0.0),
                  child: BoxButtonWidget(
                      buttonText: 'continue',
                      buttonColor: kcAccent,
                      onPressed: () => model.navigateToHome()),
                ),
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SignUpCompleteViewModel(),
    );
  }
}
