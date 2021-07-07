import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/shared/app_colors.dart';
import 'package:edutech/ui/shared/shared_styles.dart';
import 'package:edutech/ui/shared/ui_helpers.dart';
import 'package:edutech/ui/widgets/busy_button.dart';
import 'package:edutech/ui/widgets/busy_overlay.dart';
import 'package:edutech/ui/widgets/sliver_app_bar.dart';
import 'package:edutech/ui/widgets/text_field_widget.dart';
import 'package:edutech/utils/app_utils.dart';
import 'package:edutech/utils/device_utils.dart';
import 'package:edutech/utils/validators.dart';
import 'package:edutech/viewmodel/sales/add_sale_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:line_icons/line_icon.dart';
import 'package:stacked/stacked.dart';

class AddSaleView extends StatelessWidget {
  AddSaleView({Key key}) : super(key: key);

  //keys :-----------------------------------------------------------
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AddSaleViewModel>.reactive(
      builder: (context, model, child) => BusyOverlay(
        show: model.busy,
        child: Scaffold(
          body: GestureDetector(
            onTap: (){
              DeviceUtils.hideKeyboard(context);
            },
            child: Form(
              key: formKey,
              child: CustomScrollView(
                slivers: [
                  CustomSliverAppBar(
                    title: 'Add a sale',
                    isDark: model.isDark(),
                    showLeading: true,
                  ),
                  SliverPadding(
                    padding: fieldPadding,
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      verticalSpaceMedium,
                      Divider(),
                      Text(
                        'Payment proof:',
                        style: kBodyStyle,
                      ),
                      model.haveMedia
                          ? Container(
                              width: context.screenWidth(percent: 1),
                              height: context.screenHeight(percent: 0.4),
                              child: Stack(
                                children: [
                                  Image.file(model.attachment),
                                  Positioned(
                                    right: 12,
                                    top: 12,
                                    child: InkWell(
                                      onTap: () => model.clearImage(),
                                      child: CircleAvatar(
                                        radius: 18,
                                        backgroundColor: kBgDark,
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ))
                          : MediaSelector(
                              icon: LineIcon.image(
                                color: kcAccent,
                              ),
                              onTap: () => model.selectImage(),
                            ),
                      Divider(),
                      verticalSpaceMedium,
                      _buildNameInput(model),
                      verticalSpaceSmall,
                      _buildEmailInput(model),
                      verticalSpaceSmall,
                      _buildMobileInput(model),
                      verticalSpaceSmall,
                      _buildRegOfDateInput(context, model),
                      verticalSpaceSmall,
                      _buildCollegeName(model),
                      Divider(),
                      Text(
                        'Year of Study:',
                        style: kBodyStyle,
                      ),
                      _buildYearStudy(model),
                      Divider(),
                      Text(
                        'Registered for:',
                        style: kBodyStyle,
                      ),
                      _buildRegisterType(model),
                      Divider(),
                      Text(
                        'Lead Source:',
                        style: kBodyStyle,
                      ),
                      _buildLeadSource(model),
                      Divider(),
                      verticalSpaceSmall,
                      _buildPointOfContact(model),
                      verticalSpaceSmall,
                      _buildPaidAmountInput(context, model),
                      verticalSpaceSmall,
                      _buildCourseFeeInput(context, model),
                      verticalSpaceSmall,
                      BoxButtonWidget(
                        buttonText: 'Submit',
                        isLoading: model.busy,
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            model.addPost();
                          }
                        },
                      ),
                      verticalSpaceSmall,
                    ])),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      viewModelBuilder: () => AddSaleViewModel(),
    );
  }

  Widget _buildNameInput(AddSaleViewModel model) => AppTextField(
        controller: model.studentNameController,
        isDark: model.isDark(),
        fillColor: Colors.transparent,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        hintText: 'Student Name',
        validator: (value) {
          if (value.isEmpty) {
            return 'Name can not be empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildPointOfContact(AddSaleViewModel model) => AppTextField(
        controller: model.pointContactController,
        isDark: model.isDark(),
        fillColor: Colors.transparent,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        hintText: 'Point of contact',
        validator: (value) {
          if (value.isEmpty) {
            return 'Contact can not be empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildMobileInput(AddSaleViewModel model) => AppTextField(
        controller: model.mobileController,
        isDark: model.isDark(),
        isMoney: true,
        maxLength: 15,
        fillColor: Colors.transparent,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        hintText: 'Mobile number',
        validator: (value) {
          if (value.isEmpty) {
            return 'Mobile number can not empty';
          } else {
            return null;
          }
        },
      );

  Widget _buildEmailInput(AddSaleViewModel model) => AppTextField(
        isEmail: true,
        isCapitalize: false,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        isDark: model.isDark(),
        maxLength: 100,
        controller: model.emailController,
        hintText: 'Student Email',
        validator: (value) {
          if (Validator.isEmail(value)) {
            return null;
          } else if (value.isEmpty) {
            return 'We need an email here';
          } else {
            return 'Use a valid email';
          }
        },
      );

  Widget _buildCollegeName(AddSaleViewModel model) => AppTextField(
        isCapitalize: true,
        borderColor: kcPrimaryColor.withOpacity(0.4),
        fillColor: Colors.transparent,
        isDark: model.isDark(),
        maxLength: 200,
        controller: model.collegeController,
        hintText: 'College name',
        validator: (value) {
          if (value.isEmpty) {
            return 'We need an college name here';
          } else {
            return null;
          }
        },
      );

  Widget _buildYearStudy(AddSaleViewModel model) => Wrap(
        spacing: 4,
        children: List.generate(
            YEAR_STUDY.length,
            (index) => ChoiceChip(
                label: Text(YEAR_STUDY[index]),
                onSelected: (selected) {
                  selected ? model.setYearStudy(YEAR_STUDY[index]) : null;
                },
                selected: model.isYearSelected(YEAR_STUDY[index]))),
      );

  Widget _buildRegisterType(AddSaleViewModel model) => Wrap(
        spacing: 4,
        children: List.generate(
            RegisterType.values.length,
            (index) => ChoiceChip(
                label: Text(RegisterType.values[index].toShortString()),
                onSelected: (selected) {
                  selected
                      ? model.setRegType(RegisterType.values[index])
                      : null;
                },
                selected: model.isRegSelected(RegisterType.values[index]))),
      );

  Widget _buildLeadSource(AddSaleViewModel model) => Wrap(
        spacing: 4,
        children: List.generate(
            RegisterType.values.length,
            (index) => ChoiceChip(
                label: Text(LeadSource.values[index].toShortString()),
                onSelected: (selected) {
                  selected
                      ? model.setLeadSource(LeadSource.values[index])
                      : null;
                },
                selected: model.isLeadSelected(LeadSource.values[index]))),
      );

  Future<Null> _selectDate(BuildContext context, AddSaleViewModel model) async {
    final DateTime picked = await DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime.now(),
        maxTime: DateTime(2030, 1, 1));

    if (picked != null) {
      model.setBirthDate(picked);
    }
  }

  Widget _buildRegOfDateInput(BuildContext context, AddSaleViewModel model) =>
      InkWell(
        onTap: () async {
          DeviceUtils.hideKeyboard(context);
          await _selectDate(context, model);
        },
        child: AppTextField(
          isEnabled: false,
          controller: model.dateRegController,
          maxLength: 3,
          borderColor: kcPrimaryColor.withOpacity(0.4),
          prefixIcon: Icon(Icons.calendar_today_rounded),
          isDark: model.isDark(),
          fillColor: Colors.transparent,
          hintText: 'Date of registration',
          validator: (value) {
            if (value.isEmpty) {
              return 'We need the date of registration';
            } else {
              return null;
            }
          },
        ),
      );

  Widget _buildPaidAmountInput(context, AddSaleViewModel model) {
    return AppTextField(
      validator: (value) {
        if (value.isNotEmpty) {
          return null;
        } else if (value.isEmpty) {
          return 'Paid amount can not be empty';
        }
      },
      prefixIcon: IconButton(
        icon: Icon(Icons.add_circle_outline_sharp),
        onPressed: () {
          DeviceUtils.hideKeyboard(context);
          _showAvlAmounts(context, model);
        },
      ),
      controller: model.amountPaidController,
      hintText: 'Amount Paid ? Fill Carefully',
      isMoney: true,
      isDark: model.isDark(),
      fillColor: Colors.transparent,
      borderColor: kcPrimaryColor.withOpacity(0.4),
    );
  }

  Future<void> _showAvlAmounts(context, AddSaleViewModel model) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Amounts'),
          message: Text('Select paid amount'),
          actions: List.generate(
              AMOUNT_PAID.length,
              (index) => CupertinoActionSheetAction(
                  onPressed: () {
                    model.setAmountPaid(AMOUNT_PAID[index].toString());
                  },
                  child: Text('${formatCurrency.format(AMOUNT_PAID[index])}'))),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  Widget _buildCourseFeeInput(context, AddSaleViewModel model) {
    return AppTextField(
      validator: (value) {
        if (value.isNotEmpty) {
          return null;
        } else if (value.isEmpty) {
          return 'Fee can not be empty';
        }
      },
      prefixIcon: IconButton(
        icon: Icon(Icons.add_circle_outline_sharp),
        onPressed: () {
          DeviceUtils.hideKeyboard(context);
          _showCourseFeesAmounts(context, model);
        },
      ),
      controller: model.courseFeeController,
      hintText: 'Course Fee',
      isMoney: true,
      isDark: model.isDark(),
      fillColor: Colors.transparent,
      borderColor: kcPrimaryColor.withOpacity(0.4),
    );
  }

  Future<void> _showCourseFeesAmounts(context, AddSaleViewModel model) async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text('Amounts'),
          message: Text('Select fee amount'),
          actions: List.generate(
              COURSE_FEE.length,
              (index) => CupertinoActionSheetAction(
                  onPressed: () {
                    model.setCourseFee(COURSE_FEE[index].toString());
                  },
                  child: Text('${formatCurrency.format(COURSE_FEE[index])}'))),
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text('Cancel'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

class MediaSelector extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const MediaSelector({Key key, this.icon, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MaterialButton(
          onPressed: onTap,
          shape: CircleBorder(),
          color: kcPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: icon,
          ),
        ),
        verticalSpaceSmall,
        Text('Select image')
      ],
    );
  }
}
