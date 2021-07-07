import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/utils/app_utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class SaleSheetView extends StatelessWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const SaleSheetView({Key key, this.request, this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Sale s = request.customData as Sale;
    DateTime regDate = s.dateRegistration.toDate();
    return Material(
      shape: RoundedRectangleBorder(borderRadius: kBorderMedium),
      child: Padding(
        padding: fieldPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            verticalSpaceMedium,
            Row(
              children: [
                AutoSizeText(
                  request.title,
                  style: kHeading3Style,
                  maxLines: 1,
                ),
                Expanded(
                  child: SizedBox(),
                ),
                TextButton(
                  onPressed: () => completer(SheetResponse(confirmed: false)),
                  child: Text('Close'),
                )
              ],
            ),
            verticalSpaceMedium,
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  FieldItem(title: 'Email', value: s.email),
                  FieldItem(
                    title: 'Mobile number',
                    value: s.mobileNumber,
                    trailing: ActionChip(
                      onPressed: () => launchURL('tel:${s.mobileNumber}'),
                      backgroundColor: kcPrimaryColor.withOpacity(0.7),
                      label: Icon(
                        Icons.call,
                        color: kAltWhite,
                      ),
                    ),
                  ),
                  FieldItem(
                      title: 'Date of registration',
                      value:
                          '${regDate.year} - ${regDate.month} - ${regDate.day}'),
                  FieldItem(title: 'College name', value: s.collegeName),
                  FieldItem(title: 'Year study', value: s.yearStudy),
                  FieldItem(
                      title: 'Registered for',
                      value: s.registeredFor.toShortString()),
                  FieldItem(
                      title: 'Lead source',
                      value: s.leadSource.toShortString()),
                  FieldItem(title: 'Point of contact', value: s.pointContact),
                  FieldItem(
                      title: 'Amount paid',
                      value: formatCurrency.format(s.amountPaid)),
                  FieldItem(
                      title: 'Course fee',
                      value: formatCurrency.format(s.courseFee)),
                  Text(
                    'Payment proof',
                    style: kCaptionStyle.copyWith(fontWeight: FontWeight.bold),
                  ),
                  CachedNetworkImage(
                    imageUrl: s.paymentProof,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => ShimmerView(
                      thumbWidth: context.screenWidth(percent: 1),
                      thumbHeight: context.screenHeight(percent: 0.3),
                    ),
                    errorWidget: (context, url, error) => Container(
                        height: context.screenHeight(percent: 0.3),
                        width: context.screenWidth(percent: 1),
                        child: Center(child: Icon(Icons.error))),
                  ),
                  Divider()
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class FieldItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget trailing;

  const FieldItem(
      {Key key, @required this.title, @required this.value, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: kCaptionStyle.copyWith(fontWeight: FontWeight.bold),
            ),
            AutoSizeText(
              value,
              style: kBodyStyle,
              maxLines: 1,
            ),
            Divider()
          ],
        ),
        Expanded(child: SizedBox()),
        trailing != null ? trailing : EmptyBox
      ],
    );
  }
}
