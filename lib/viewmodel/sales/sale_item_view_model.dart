import 'package:edutech/constants/route_name.dart';
import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/shared/bottom_sheet_type.dart';
import 'package:edutech/ui/sheets/sale_sheet.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class SaleItemViewModel extends BaseModel {
  final _bottomSheetService = locator<BottomSheetService>();
  final _navigationService = locator<NavigationService>();

  bool isPaymentCompleted(Sale sale) => sale.courseFee == sale.amountPaid;

  final saleInfoSheetBuilder = {
    BottomSheetType.floating: (context, sheetRequest, completer) =>
        SaleSheetView(
          completer: completer,
          request: sheetRequest,

        )
  };

  Future showSaleSheet(Sale sale) async {
    _bottomSheetService.setCustomSheetBuilders(saleInfoSheetBuilder);
   var result =  await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.floating,
        isScrollControlled: true,
        customData: sale,
        title: sale.studentName,
        description: currentUser.userId,
        mainButtonTitle: '',
        barrierDismissible: true,
        secondaryButtonTitle: '');

   if(result.confirmed){
     _navigationService.navigateTo(AddSaleViewRoute,arguments: sale);
   }
  }
}
