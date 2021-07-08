import 'package:edutech/model/sale.dart';
import 'package:edutech/model/user.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/app_info.dart';
import 'package:edutech/ui/widgets/avatar_widget.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/viewmodel/salesmen/salesmen_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SalesmenView extends StatelessWidget {
  const SalesmenView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SalesmenViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: GestureDetector(
          onTap: () => DeviceUtils.hideKeyboard(context),
          child: CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: 'Search Salesmen',
                isDark: model.isDark(),
                showLeading: true,
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                verticalSpaceMedium,
                Padding(
                  padding: fieldPadding,
                  child: AppTextField(
                    isEnabled: true,
                    textInputAction: TextInputAction.search,
                    isTextArea: false,
                    isDark: model.isDark(),
                    borderColor: kcPrimaryColor.withOpacity(0.4),
                    controller: model.searchController,
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search',
                    onChanged: model.onValueChanged,
                  ),
                ),
                verticalSpaceMedium,
                SearchUserResult(
                  searchStream: model.searchUsers(),
                )
              ]))
            ],
          ),
        ),
      ),
      viewModelBuilder: () => SalesmenViewModel(),
    );
  }
}

class SearchUserResult extends StatelessWidget {
  final Stream<List<UserModel>> searchStream;
  final Stream<List<Sale>> saleStream;

  const SearchUserResult({
    Key key,
    @required this.searchStream,@required this.saleStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserModel>>(
        stream: searchStream,
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            List<UserModel> users = snapshot.data;

            if (users.isEmpty) {
              return AppInfoWidget(
                  iconData: Icons.search,
                  translateKey: 'No results found',
                  isDark: false);
            } else {
              return ListView.separated(
                  separatorBuilder: (_, index) => Divider(),
                  shrinkWrap: true,
                  itemCount: users.length,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (_, index) {
                    return ListTile(
                      onTap: () {},
                      title: Text(
                        users[index].name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: AvatarView(
                        path: users[index].profileUrl,
                        userName: users[index].name,
                      ),
                    );
                  });
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
