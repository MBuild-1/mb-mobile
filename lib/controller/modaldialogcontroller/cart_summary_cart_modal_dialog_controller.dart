import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../../domain/entity/cart/cart_summary.dart';
import '../../domain/entity/cart/cart_summary_parameter.dart';
import '../../domain/usecase/get_cart_summary_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import 'modal_dialog_controller.dart';

class CartSummaryCartModalDialogController extends ModalDialogController {
  final GetCartSummaryUseCase getCartSummaryUseCase;

  LoadDataResult<CartSummary> _cartSummaryLoadDataResult = NoLoadDataResult<CartSummary>();
  late Rx<LoadDataResultWrapper<CartSummary>> cartSummaryLoadDataResultWrapperRx;
  bool _hasInitCartSummary = false;

  CartSummaryCartModalDialogController(
    ControllerManager? controllerManager,
    this.getCartSummaryUseCase
  ) : super(controllerManager) {
    cartSummaryLoadDataResultWrapperRx = LoadDataResultWrapper<CartSummary>(_cartSummaryLoadDataResult).obs;
  }

  void initCartSummary() async {
    if (_hasInitCartSummary) {
      return;
    }
    _hasInitCartSummary = true;
    _cartSummaryLoadDataResult = IsLoadingLoadDataResult<CartSummary>();
    _updateCartSummaryState();
    _cartSummaryLoadDataResult = await getCartSummaryUseCase.execute(
      CartSummaryParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart('cart-summary').value
    );
    _updateCartSummaryState();
  }

  void _updateCartSummaryState() {
    cartSummaryLoadDataResultWrapperRx.valueFromLast(
      (value) => LoadDataResultWrapper<CartSummary>(_cartSummaryLoadDataResult)
    );
    update();
  }
}