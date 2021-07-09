import 'package:edutech/ui/widgets/app_icon.dart';
import 'package:edutech/ui/widgets/busy_overlay.dart';
import 'package:edutech/viewmodel/drawer/drawer_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:stacked/stacked.dart';

class DrawerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerViewModel>.reactive(
      builder: (context, model, child) => BusyOverlay(
        show: model.busy,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            actions: [
              IconButton(
                onPressed: () => model.goBack(),
                icon: Icon(Icons.close),
              )
            ],
          ),
          body: Column(
            children: [
              ListTile(
                leading: AppIconWidget(
                  bgColor: CupertinoColors.destructiveRed,
                  iconData: LineIcon.userLock().icon,
                ),
                title: Text('Change password'),
                onTap: () => model.navigateToChangePwd(),
              ),
              // ListTile(
              //     leading: AppIconWidget(
              //       bgColor: CupertinoColors.systemPurple,
              //       iconData: model.isDark()
              //           ? LineIcon.moon().icon
              //           : LineIcon.sun().icon,
              //     ),
              //     title: Text('change_theme'
              //         .tr(args: model.isDark() ? ['Dark'] : ['Light'])),
              //     onTap: () {
              //       model.toggleTheme();
              //     }),
              ListTile(
                  leading: AppIconWidget(
                    bgColor: CupertinoColors.activeGreen,
                    iconData: LineIcon.alternateSignOut().icon,
                  ),
                  title: Text('Sign out'),
                  onTap: () {
                    model.signOut();
                  })
            ],
          ),
        ),
      ),
      viewModelBuilder: () => DrawerViewModel(),
    );
  }
}
