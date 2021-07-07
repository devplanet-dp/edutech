import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/viewmodel/drawer/filter_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:stacked/stacked.dart';

class FilterDrawerView extends StatelessWidget {
  final Function(DateTime startDate, DateTime endDate) onSearchClicked;
  final VoidCallback onClearTapped;

  const FilterDrawerView(
      {Key key, @required this.onSearchClicked, @required this.onClearTapped})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FilterDrawerViewModel>.reactive(
      builder: (context, model, child) => Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8), bottomLeft: Radius.circular(8))),
        height: context.screenHeight(percent: 1),
        width: context.screenWidth(percent: 0.75),
        child: Form(
          key: model.formKey,
          child: Padding(
            padding: fieldPadding,
            child: Column(
              children: [
                ///start date input
                verticalSpaceLarge,
                InkWell(
                  onTap: () {
                    DeviceUtils.hideKeyboard(context);
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(2020, 1, 1),
                        maxTime: DateTime(3000, 1, 1), onConfirm: (date) {
                      model.setStartDate(date);
                    });
                  },
                  child: AppTextField(
                    prefixIcon: Icon(
                      LineIcons.calendar,
                    ),
                    validator: (value) {
                      if (value.isNotEmpty) {
                        return null;
                      } else if (value.isEmpty) {
                        return 'Start date can not be empty';
                      }
                    },
                    controller: model.startDateController,
                    hintText: "Start date",
                    isEnabled: false,
                  ),
                ),
                verticalSpaceSmall,

                ///end date input
                InkWell(
                  onTap: () {
                    DeviceUtils.hideKeyboard(context);
                    if (model.formKey.currentState.validate()) {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: model.startDate.add(const Duration(days: 1)),
                          maxTime: DateTime(3000, 1, 1), onConfirm: (date) {
                        model.setEndDate(date);
                      });
                    }
                  },
                  child: AppTextField(
                    prefixIcon: Icon(
                      LineIcons.calendar,
                    ),
                    controller: model.endDateController,
                    hintText: 'End date',
                    isEnabled: false,
                    validator: (value) {
                      // if (model.startDateController.text.isNotEmpty &&
                      //     value.isEmpty) {
                      //   return 'We need an end date here';
                      // }
                    },
                  ),
                ),
                verticalSpaceSmall,
                Wrap(
                  spacing: 4,
                  children: [
                    ActionChip(
                        backgroundColor: kcPrimaryColor,
                        label: Padding(
                          padding: fieldPadding,
                          child: Text(
                            'Search',
                            style: kBodyStyle.copyWith(color: kAltWhite),
                          ),
                        ),
                        onPressed: () {
                          if (model.formKey.currentState.validate()) {
                            onSearchClicked(model.startDate, model.endDate);
                            Navigator.pop(context);
                          }
                        }),
                    ActionChip(
                        backgroundColor: kAltWhite,
                        label: Padding(
                          padding: fieldPadding,
                          child: Text(
                            'Clear',
                            style: kBodyStyle.copyWith(color: kAltBg),
                          ),
                        ),
                        onPressed: () {
                          onClearTapped();
                          model.clearFilter();
                          Navigator.pop(context);
                        })
                  ],
                ),
                verticalSpaceSmall,
              ],
            ),
          ),
        ),
      ),
      viewModelBuilder: () => FilterDrawerViewModel(),
    );
  }
}
