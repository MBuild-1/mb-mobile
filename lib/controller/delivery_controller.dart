import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../domain/entity/additionalitem/add_additional_item_response.dart';
import '../domain/entity/additionalitem/additional_item.dart';
import '../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../domain/entity/additionalitem/change_additional_item_response.dart';
import '../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../domain/entity/address/address.dart';
import '../domain/entity/address/current_selected_address_parameter.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/cart/cart_paging_parameter.dart';
import '../domain/entity/cart/cart_summary.dart';
import '../domain/entity/cart/cart_summary_parameter.dart';
import '../domain/entity/coupon/coupon.dart';
import '../domain/entity/order/create_order_parameter.dart';
import '../domain/entity/order/order.dart';
import '../domain/usecase/add_additional_item_use_case.dart';
import '../domain/usecase/change_additional_item_use_case.dart';
import '../domain/usecase/create_order_use_case.dart';
import '../domain/usecase/get_additional_item_use_case.dart';
import '../domain/usecase/get_cart_summary_use_case.dart';
import '../domain/usecase/get_current_selected_address_use_case.dart';
import '../domain/usecase/get_my_cart_use_case.dart';
import '../domain/usecase/remove_additional_item_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnDeliveryBack = void Function();
typedef _OnGetCoupon = Coupon? Function();
typedef _OnShowDeliveryRequestProcessLoadingCallback = Future<void> Function();
typedef _OnDeliveryRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowDeliveryRequestProcessFailedCallback = Future<void> Function(dynamic e);

class DeliveryController extends BaseGetxController {
  final GetMyCartUseCase getMyCartUseCase;
  final GetCartSummaryUseCase getCartSummaryUseCase;
  final GetAdditionalItemUseCase getAdditionalItemUseCase;
  final AddAdditionalItemUseCase addAdditionalItemUseCase;
  final ChangeAdditionalItemUseCase changeAdditionalItemUseCase;
  final RemoveAdditionalItemUseCase removeAdditionalItemUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;
  final CreateOrderUseCase createOrderUseCase;

  DeliveryDelegate? _deliveryDelegate;

  DeliveryController(
    super.controllerManager,
    this.getMyCartUseCase,
    this.getCurrentSelectedAddressUseCase,
    this.getCartSummaryUseCase,
    this.getAdditionalItemUseCase,
    this.addAdditionalItemUseCase,
    this.changeAdditionalItemUseCase,
    this.removeAdditionalItemUseCase,
    this.createOrderUseCase
  );

  Future<LoadDataResult<CartSummary>> getCartSummary(CartSummaryParameter cartSummaryParameter) {
    return getCartSummaryUseCase.execute(cartSummaryParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart-summary").value
    );
  }

  Future<LoadDataResult<List<AdditionalItem>>> getAdditionalItem(AdditionalItemListParameter additionalItemListParameter) {
    return getAdditionalItemUseCase.execute(additionalItemListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("get-additional-item").value
    );
  }

  Future<LoadDataResult<AddAdditionalItemResponse>> addAdditionalItem(AddAdditionalItemParameter addAdditionalItemParameter) {
    return addAdditionalItemUseCase.execute(addAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("add-additional-item").value
    );
  }

  Future<LoadDataResult<ChangeAdditionalItemResponse>> changeAdditionalItem(ChangeAdditionalItemParameter changeAdditionalItemParameter) {
    return changeAdditionalItemUseCase.execute(changeAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("change-additional-item").value
    );
  }
  Future<LoadDataResult<RemoveAdditionalItemResponse>> removeAdditionalItem(RemoveAdditionalItemParameter removeAdditionalItemParameter) {
    return removeAdditionalItemUseCase.execute(removeAdditionalItemParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("remove-additional-item").value
    );
  }

  Future<LoadDataResult<PagingDataResult<Cart>>> getDeliveryCartPaging(CartPagingParameter cartPagingParameter) {
    return getMyCartUseCase.execute(cartPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart-paging").value
    );
  }

  Future<LoadDataResult<Address>> getCurrentSelectedAddress(CurrentSelectedAddressParameter currentSelectedAddressParameter) {
    return getCurrentSelectedAddressUseCase.execute(currentSelectedAddressParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("current-selected-address").value
    ).map<Address>((currentSelectedAddressResponse) {
      return currentSelectedAddressResponse.address;
    });
  }

  DeliveryController setDeliveryDelegate(DeliveryDelegate deliveryDelegate) {
    _deliveryDelegate = deliveryDelegate;
    return this;
  }

  void createOrder() async {
    if (_deliveryDelegate != null) {
      _deliveryDelegate!.onUnfocusAllWidget();
      _deliveryDelegate!.onShowDeliveryRequestProcessLoadingCallback();
      LoadDataResult<Order> createOrderLoadDataResult = await createOrderUseCase.execute(
        CreateOrderParameter(
          cartList: [],
          additionalItemList: [],
          coupon: null,
          address: null
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('order').value
      );
      Get.back();
      if (createOrderLoadDataResult.isSuccess) {
        _deliveryDelegate!.onDeliveryRequestProcessSuccessCallback();
      } else {
        _deliveryDelegate!.onShowDeliveryRequestProcessFailedCallback(createOrderLoadDataResult.resultIfFailed);
      }
    }
  }
}

class DeliveryDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnDeliveryBack onDeliveryBack;
  _OnShowDeliveryRequestProcessLoadingCallback onShowDeliveryRequestProcessLoadingCallback;
  _OnDeliveryRequestProcessSuccessCallback onDeliveryRequestProcessSuccessCallback;
  _OnShowDeliveryRequestProcessFailedCallback onShowDeliveryRequestProcessFailedCallback;
  _OnGetCoupon onGetCoupon;

  DeliveryDelegate({
    required this.onUnfocusAllWidget,
    required this.onDeliveryBack,
    required this.onShowDeliveryRequestProcessLoadingCallback,
    required this.onDeliveryRequestProcessSuccessCallback,
    required this.onShowDeliveryRequestProcessFailedCallback,
    required this.onGetCoupon
  });
}