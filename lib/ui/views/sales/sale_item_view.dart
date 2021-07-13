import 'package:auto_size_text/auto_size_text.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/utils/timeago.dart';
import 'package:edutech/viewmodel/sales/sale_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SaleItemView extends StatelessWidget {
  final Sale sale;

  SaleItemView({Key key, @required this.sale}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SaleItemViewModel>.reactive(
      builder: (context, model, child) => InkWell(
        onTap: ()=>model.showSaleSheet(sale),
        child: Container(
          width: context.screenWidth(percent: 1),
          decoration: BoxDecoration(
            color: kAltWhite,
            borderRadius: kBorderMedium,
            border: Border.all(
                color: model.isPaymentCompleted(sale)
                    ? Colors.greenAccent
                    : Colors.redAccent,
                width: 1),
            boxShadow: [
              BoxShadow(
                  blurRadius: 10,
                  color: kAltBg.withOpacity(0.17),
                  offset: Offset(0, 4))
            ],
          ),
          child: ListTile(
            isThreeLine: true,
            leading: CircleAvatar(
              radius: 24,
              backgroundColor: kcPrimaryColor.withOpacity(0.7),
              child: Center(
                  child: Text(
                sale.studentName[0].toUpperCase(),
                style: kHeading2Style,
              )),
            ),
            subtitle: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  sale.yearStudy,
                  maxLines: 1,
                ),
                AutoSizeText(
                  sale.courseName,
                  maxLines: 1,
                  style: kBodyStyle.copyWith(
                      fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            title: AutoSizeText(
              sale.studentName,
              maxLines: 1,
            ),
            trailing: AutoSizeText(
              '${timeAgoSinceDate(sale.createdAt.toDate())}',
              maxLines: 1,
              style:
                  kBodyStyle.copyWith(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => SaleItemViewModel(),
    );
  }
}
