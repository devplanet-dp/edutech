import 'package:flutter/material.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';

class AppIconWidget extends StatelessWidget {
  final IconData iconData;
  final Color iconColor;
  final Color bgColor;

  const AppIconWidget({
    Key key,
    this.iconData,
    this.iconColor,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kRadiusSmall))),
      clipBehavior: Clip.antiAlias,
      color: bgColor ?? kcPrimaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          iconData,
          color: iconColor ?? kAltWhite,
        ),
      ),
    );
  }
}
