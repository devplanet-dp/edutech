import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/ui/drawer/filter_drawer_view.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/views/sales/sale_item_view.dart';
import 'package:edutech/ui/widgets/app_info.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/viewmodel/salesmen/salesmen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked/stacked.dart';

class SaleStatView extends StatelessWidget {
  //keys :-----------------------------------------------------------
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final UserModel salesmen;

  SaleStatView({Key key, @required this.salesmen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesmenViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
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
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(
              title: salesmen.name,
              isDark: false,
              action: IconButton(
                icon: Icon(LineIcons.filter),
                color: kcPrimaryColor,
                onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
              ),
            ),
            SliverPadding(
              padding: fieldPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SaleResultView(
                    model: model,
                    uid: salesmen.userId,
                  )
                ]),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => SalesmenViewModel(),
    );
  }
}

class _SaleResultView extends StatelessWidget {
  final SalesmenViewModel model;
  final String uid;

  const _SaleResultView({Key key, this.model, this.uid}) : super(key: key);

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

  Widget _buildSales(SalesmenViewModel model) {
    return StreamBuilder(
      stream: model.userSaleStream(uid),
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
