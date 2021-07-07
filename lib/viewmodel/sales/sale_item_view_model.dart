import 'package:edutech/model/sale.dart';
import 'package:edutech/ui/shared/bottom_sheet_type.dart';
import 'package:edutech/ui/sheets/sale_sheet.dart';
import 'package:edutech/viewmodel/base_model.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../locator.dart';

class SaleItemViewModel extends BaseModel {
  final _bottomSheetService = locator<BottomSheetService>();

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
    await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.floating,
        isScrollControlled: true,
        customData: sale,
        title: sale.studentName,
        description: '',
        mainButtonTitle: '',
        barrierDismissible: true,
        secondaryButtonTitle: '');
  }
}
