import 'package:edutech/model/user.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/viewmodel/salesmen/salesmen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SaleStatView extends StatelessWidget {
  final UserModel salesmen;

  const SaleStatView({Key key, @required this.salesmen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesmenViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            CustomSliverAppBar(title: salesmen.name, isDark: false),
            SliverPadding(
              padding: fieldPadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([]),
              ),
            )
          ],
        ),
      ),
      viewModelBuilder: () => SalesmenViewModel(),
    );
  }
}
