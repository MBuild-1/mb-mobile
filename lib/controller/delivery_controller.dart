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
import '../domain/entity/address/current_selected_address_response.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/cart/cart_list_parameter.dart';
import '../domain/entity/cart/cart_paging_parameter.dart';
import '../domain/entity/cart/cart_summary.dart';
import '../domain/entity/cart/cart_summary_parameter.dart';
import '../domain/entity/coupon/coupon.dart';
import '../domain/entity/coupon/coupon_detail_parameter.dart';
import '../domain/entity/order/create_order_parameter.dart';
import '../domain/entity/order/create_order_version_1_point_1_parameter.dart';
import '../domain/entity/order/create_order_version_1_point_1_response.dart';
import '../domain/entity/order/order.dart';
import '../domain/usecase/add_additional_item_use_case.dart';
import '../domain/usecase/change_additional_item_use_case.dart';
import '../domain/usecase/create_order_use_case.dart';
import '../domain/usecase/create_order_version_1_point_1_use_case.dart';
import '../domain/usecase/get_additional_item_use_case.dart';
import '../domain/usecase/get_cart_list_use_case.dart';
import '../domain/usecase/get_cart_summary_use_case.dart';
import '../domain/usecase/get_coupon_detail_use_case.dart';
import '../domain/usecase/get_current_selected_address_use_case.dart';
import '../domain/usecase/get_my_cart_use_case.dart';
import '../domain/usecase/remove_additional_item_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnDeliveryBack = void Function();
typedef _OnGetCouponId = String? Function();
typedef _OnGetCoupon = Coupon? Function();
typedef _OnGetCartList = List<Cart> Function();
typedef _OnGetSettlingId = String? Function();
typedef _OnGetAdditionalList = List<AdditionalItem> Function();
typedef _OnShowDeliveryRequestProcessLoadingCallback = Future<void> Function();
typedef _OnDeliveryRequestProcessSuccessCallback = Future<void> Function(Order);
typedef _OnDeliveryRequestVersion1Point1ProcessSuccessCallback = Future<void> Function(CreateOrderVersion1Point1Response);
typedef _OnShowDeliveryRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowCartSummaryProcessCallback = Future<void> Function(LoadDataResult<CartSummary>);

class DeliveryController extends BaseGetxController {
  final GetCartListUseCase getCartListUseCase;
  final GetCartSummaryUseCase getCartSummaryUseCase;
  final GetAdditionalItemUseCase getAdditionalItemUseCase;
  final AddAdditionalItemUseCase addAdditionalItemUseCase;
  final ChangeAdditionalItemUseCase changeAdditionalItemUseCase;
  final RemoveAdditionalItemUseCase removeAdditionalItemUseCase;
  final GetCurrentSelectedAddressUseCase getCurrentSelectedAddressUseCase;
  final GetCouponDetailUseCase getCouponDetailUseCase;
  final CreateOrderUseCase createOrderUseCase;
  final CreateOrderVersion1Point1UseCase createOrderVersion1Point1UseCase;
  bool _hasGetCartSummary = false;

  DeliveryDelegate? _deliveryDelegate;

  DeliveryController(
    super.controllerManager,
    this.getCartListUseCase,
    this.getCurrentSelectedAddressUseCase,
    this.getCartSummaryUseCase,
    this.getAdditionalItemUseCase,
    this.addAdditionalItemUseCase,
    this.changeAdditionalItemUseCase,
    this.removeAdditionalItemUseCase,
    this.getCouponDetailUseCase,
    this.createOrderUseCase,
    this.createOrderVersion1Point1UseCase
  );

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

  Future<LoadDataResult<List<Cart>>> getDeliveryCartList(CartListParameter cartListParameter) {
    return getCartListUseCase.execute(cartListParameter).future(
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

  Future<LoadDataResult<Coupon>> getCouponDetail(CouponDetailParameter couponDetailParameter) {
    return getCouponDetailUseCase.execute(couponDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("coupon-detail").value
    );
  }

  DeliveryController setDeliveryDelegate(DeliveryDelegate deliveryDelegate) {
    _deliveryDelegate = deliveryDelegate;
    return this;
  }

  void createOrder() async {
    if (_deliveryDelegate != null) {
      _deliveryDelegate!.onUnfocusAllWidget();
      _deliveryDelegate!.onShowDeliveryRequestProcessLoadingCallback();
      LoadDataResult<CurrentSelectedAddressResponse> currentAddressLoadDataResult = await getCurrentSelectedAddressUseCase.execute(
        CurrentSelectedAddressParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("address").value
      );
      if (currentAddressLoadDataResult.isSuccess) {
        LoadDataResult<Order> createOrderLoadDataResult = await createOrderUseCase.execute(
          CreateOrderParameter(
            cartList: _deliveryDelegate!.onGetCartList(),
            additionalItemList: _deliveryDelegate!.onGetAdditionalList(),
            couponId: _deliveryDelegate!.onGetCouponId(),
            address: currentAddressLoadDataResult.resultIfSuccess!.address
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('order').value
        );
        _deliveryDelegate!.onDeliveryBack();
        if (createOrderLoadDataResult.isSuccess) {
          _deliveryDelegate!.onDeliveryRequestProcessSuccessCallback(createOrderLoadDataResult.resultIfSuccess!);
        } else {
          _deliveryDelegate!.onShowDeliveryRequestProcessFailedCallback(createOrderLoadDataResult.resultIfFailed);
        }
      } else {
        _deliveryDelegate!.onShowDeliveryRequestProcessFailedCallback(currentAddressLoadDataResult.resultIfFailed);
      }
    }
  }

  void createOrderVersion1Point1() async {
    if (_deliveryDelegate != null) {
      _deliveryDelegate!.onUnfocusAllWidget();
      _deliveryDelegate!.onShowDeliveryRequestProcessLoadingCallback();
      LoadDataResult<CurrentSelectedAddressResponse> currentAddressLoadDataResult = await getCurrentSelectedAddressUseCase.execute(
        CurrentSelectedAddressParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("address").value
      );
      if (currentAddressLoadDataResult.isSuccess) {
        LoadDataResult<CreateOrderVersion1Point1Response> createOrderVersion1Point1LoadDataResult = await createOrderVersion1Point1UseCase.execute(
          CreateOrderVersion1Point1Parameter(
            cartList: _deliveryDelegate!.onGetCartList(),
            additionalItemList: _deliveryDelegate!.onGetAdditionalList(),
            couponId: _deliveryDelegate!.onGetCouponId(),
            address: currentAddressLoadDataResult.resultIfSuccess!.address,
            settlingId: _deliveryDelegate!.onGetSettlingId()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('order').value
        );
        _deliveryDelegate!.onDeliveryBack();
        if (createOrderVersion1Point1LoadDataResult.isSuccess) {
          _deliveryDelegate!.onDeliveryRequestVersion1Point1ProcessSuccessCallback(createOrderVersion1Point1LoadDataResult.resultIfSuccess!);
        } else {
          _deliveryDelegate!.onShowDeliveryRequestProcessFailedCallback(createOrderVersion1Point1LoadDataResult.resultIfFailed);
        }
      } else {
        _deliveryDelegate!.onShowDeliveryRequestProcessFailedCallback(currentAddressLoadDataResult.resultIfFailed);
      }
    }
  }

  void getCartSummary() async {
    if (_deliveryDelegate != null) {
      _deliveryDelegate!.onShowCartSummaryProcessCallback(IsLoadingLoadDataResult<CartSummary>());
      LoadDataResult<CurrentSelectedAddressResponse> currentAddressLoadDataResult = await getCurrentSelectedAddressUseCase.execute(
        CurrentSelectedAddressParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("address-for-cart-summary").value
      );
      if (currentAddressLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      Address? address;
      if (currentAddressLoadDataResult.isSuccess) {
        address = currentAddressLoadDataResult.resultIfSuccess!.address;
      }
      LoadDataResult<CartSummary> cartSummaryLoadDataResult = await getCartSummaryUseCase.execute(
        CartSummaryParameter(
          cartList: _deliveryDelegate!.onGetCartList(),
          settlingId: _deliveryDelegate!.onGetSettlingId(),
          additionalItemList: _deliveryDelegate!.onGetAdditionalList(),
          couponId: _deliveryDelegate!.onGetCouponId(),
          address: address
        )
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart("cart-summary").value
      );
      _deliveryDelegate!.onShowCartSummaryProcessCallback(cartSummaryLoadDataResult);
    }
  }
}

class DeliveryDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnDeliveryBack onDeliveryBack;
  _OnShowDeliveryRequestProcessLoadingCallback onShowDeliveryRequestProcessLoadingCallback;
  _OnDeliveryRequestProcessSuccessCallback onDeliveryRequestProcessSuccessCallback;
  _OnDeliveryRequestVersion1Point1ProcessSuccessCallback onDeliveryRequestVersion1Point1ProcessSuccessCallback;
  _OnShowDeliveryRequestProcessFailedCallback onShowDeliveryRequestProcessFailedCallback;
  _OnShowCartSummaryProcessCallback onShowCartSummaryProcessCallback;
  _OnGetCouponId onGetCouponId;
  _OnGetCartList onGetCartList;
  _OnGetAdditionalList onGetAdditionalList;
  _OnGetSettlingId onGetSettlingId;

  DeliveryDelegate({
    required this.onUnfocusAllWidget,
    required this.onDeliveryBack,
    required this.onShowDeliveryRequestProcessLoadingCallback,
    required this.onDeliveryRequestProcessSuccessCallback,
    required this.onDeliveryRequestVersion1Point1ProcessSuccessCallback,
    required this.onShowDeliveryRequestProcessFailedCallback,
    required this.onShowCartSummaryProcessCallback,
    required this.onGetCouponId,
    required this.onGetCartList,
    required this.onGetAdditionalList,
    required this.onGetSettlingId
  });
}