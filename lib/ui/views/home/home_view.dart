import 'package:animations/animations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/drawer/drawer.dart';
import 'package:edutech/ui/drawer/filter_drawer_view.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/views/account/user_account_view.dart';
import 'package:edutech/ui/views/sales/sale_item_view.dart';
import 'package:edutech/ui/widgets/app_info.dart';
import 'package:edutech/ui/widgets/app_title_widget.dart';
import 'package:edutech/ui/widgets/avatar_widget.dart';
import 'package:edutech/ui/widgets/busy_overlay.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/viewmodel/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
          drawer: DrawerView(),
          endDrawer: FilterDrawerView(
            startDate: model.startDate,
            endDate: model.endDate,
            onSearchClicked: (DateTime startDate, DateTime endDate) {
              model.setStartDate(startDate);
              model.setEndDate(endDate);
            },
            onClearTapped: () {
              model.clearFilter();
            },
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: fieldPadding,
              child: Column(
                children: [
                  verticalSpaceMedium,
                  Row(
                    children: [
                      AutoSizeText(
                        'Hi ${model.currentUser.name}',
                        maxLines: 3,
                        style: kBodyStyle.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Expanded(child: SizedBox()),
                      InkWell(
                        onTap: () => _scaffoldKey.currentState.openEndDrawer(),
                        child: Icon(
                          LineIcons.filter,
                          color: kcPrimaryColor,
                        ),
                      )
                    ],
                  ),
                  verticalSpaceSmall,
                  model.hasDateFilter ?? false
                      ? Row(
                          children: [
                            Chip(
                                label: Text(
                              'From: ${model.startDate.year}-${model.startDate.month}-${model.startDate.day}',
                              style: kCaptionStyle,
                            )),
                            Expanded(child: SizedBox()),
                            Chip(
                                label: Text(
                                    'To: ${model.endDate.year}-${model.endDate.month}-${model.endDate.day}',
                                    style: kCaptionStyle))
                          ],
                        )
                      : EmptyBox,
                  _MySalesView(
                    model: model,
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: _FABWidget(
            onTapped: () => model.navigateToAddBusiness(),
          ),
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
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

class _FABWidget extends StatelessWidget {
  final VoidCallback onTapped;

  const _FABWidget({
    Key key,
    @required this.onTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTapped,
      shape: RoundedRectangleBorder(borderRadius: kBorderLarge),
      clipBehavior: Clip.antiAlias,
      color: kcPrimaryColor,
      child: Text(
        'Add a sale',
        style:
            kBodyStyle.copyWith(fontWeight: FontWeight.bold, color: kAltWhite),
      ),
    );
  }
}

class _MySalesView extends StatelessWidget {
  final HomeViewModel model;

  const _MySalesView({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        verticalSpaceMedium,
        _buildSales(model),
        verticalSpaceMedium,
      ],
    );
  }


  Widget _buildSales(HomeViewModel model) {
    return StreamBuilder(
      stream: model.streamMySales(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        List<Sale> s = snapshot.data ?? [];
        if (model.startDate != null && model.endDate != null) {
          model.saleResult.clear();
          s.forEach((element) {
            if (element.createdAt.toDate().isAfter(
                    model.startDate.subtract(const Duration(days: 1))) &&
                element.createdAt
                    .toDate()
                    .isBefore(model.endDate.add(const Duration(days: 1)))) {
              model.saleResult.add(element);
            }
          });
        } else {
          model.saleResult.clear();
          model.saleResult.addAll(s);
        }
        if (model.saleResult.isNotEmpty) {
          model.saleResult.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: model.saleResult.length,
            itemBuilder: (_, index) =>
                SaleItemView(sale: model.saleResult[index]),
            separatorBuilder: (_, index) => verticalSpaceSmall,
          );
        } else {
          return AppInfoWidget(
              translateKey: 'No sales found',
              iconData: LineIcons.search,
              isDark: model.isDark());
        }
      },
    );
  }
}
