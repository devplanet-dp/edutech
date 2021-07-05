import 'package:animations/animations.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/views/account/user_account_view.dart';
import 'package:edutech/ui/widgets/app_title_widget.dart';
import 'package:edutech/ui/widgets/avatar_widget.dart';
import 'package:edutech/ui/widgets/busy_overlay.dart';
import 'package:edutech/ui/widgets/tile_widget.dart';
import 'package:edutech/utils/margin.dart';
import 'package:edutech/viewmodel/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  //keys :-----------------------------------------------------------
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => BusyOverlay(
        show: model.busy,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(context, model),
          body: SingleChildScrollView(
            child: Padding(
              padding: fieldPadding,
              child: Column(
                children: [
                  verticalSpaceMedium,
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'hi',
                      style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  verticalSpaceMedium,
                  _buildTiles(model)
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }

  Row _buildTiles(HomeViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: TileWidget(
          subHeader: 'my_business',
          primaryColor: Colors.red,
          onTap: () {},
          icon: LineIcons.businessTime,
          header: EmptyBox,
          isDark: model.isDark(),
        )),
        const XMargin(18),
        Expanded(
            child: TileWidget(
          subHeader: 'my_contracts',
          primaryColor: Colors.blue,
          onTap: () {},
          icon: LineIcons.fileContract,
          header: EmptyBox,
          isDark: model.isDark(),
        ))
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context, HomeViewModel model) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: IconButton(
        onPressed: () => _scaffoldKey.currentState.openDrawer(),
        icon: Icon(Icons.sort),
      ),
      centerTitle: true,
      title: AppTitleWidget(
        isDark: model.isDark(),
        isLarge: true,
      ),
      actions: [
        OpenContainer(
            closedColor: Colors.transparent,
            closedShape: CircleBorder(),
            closedBuilder: (_, open) => Padding(
                  padding: fieldPadding,
                  child: AvatarView(
                      path: model.currentUser.profileUrl,
                      userName: model.currentUser.name),
                ),
            openBuilder: (_, close) => UserAccountView())
      ],
    );
  }
}
