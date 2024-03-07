import '../../domain/entity/coupon/coupon.dart';
import '../../domain/entity/payment/payment_method.dart';
import '../controllerstate/listitemcontrollerstate/couponlistitemcontrollerstate/coupon_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/payment_method_indicator_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/payment_parameter_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/shipping_address_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';

class PaymentParameterItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  PaymentParameterItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is PaymentParameterListItemControllerState) {
      // Select address
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          ShippingAddressListItemControllerState(
            shippingLoadDataResult: oldItemType.onGetCurrentSelectedAddressLoadDataResult(),
            errorProvider: oldItemType.errorProvider,
            onChangeOtherAddress: oldItemType.onSelectAddress
          )
        ),
        oldItemTypeList,
        newItemTypeList
      );

      newItemTypeList.add(
        VirtualSpacingListItemControllerState(
          height: 10.0
        )
      );

      // Select Payment Method
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          PaymentMethodIndicatorListItemControllerState(
            selectedPaymentMethodLoadDataResult: () {
              PaymentMethod? paymentMethod = oldItemType.onGetPaymentMethod();
              if (paymentMethod != null) {
                return SuccessLoadDataResult<PaymentMethod>(
                  value: paymentMethod
                );
              } else {
                return NoLoadDataResult<PaymentMethod>();
              }
            },
            onSelectPaymentMethod: oldItemType.onSelectPaymentMethod,
            onRemovePaymentMethod: oldItemType.onRemovePaymentMethod,
            errorProvider: oldItemType.errorProvider
          )
        ),
        oldItemTypeList,
        newItemTypeList
      );

      // Select Coupon
      if (oldItemType.showSelectCoupon) {
        newItemTypeList.add(
          VirtualSpacingListItemControllerState(
            height: 26.0
          )
        );
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            CouponIndicatorListItemControllerState(
              getSelectedCouponLoadDataResult: oldItemType.onGetCouponLoadDataResult,
              setSelectedCouponLoadDataResult: oldItemType.onSetCouponLoadDataResult,
              errorProvider: oldItemType.errorProvider,
              onUpdateCoupon: (coupon) {},
              onUpdateState: oldItemType.onUpdateState,
              onSelectCoupon: oldItemType.onSelectCoupon
            )
          ),
          oldItemTypeList,
          newItemTypeList
        );
      }

      newItemTypeList.add(
        VirtualSpacingListItemControllerState(
          height: 10.0
        )
      );
      return true;
    }
    return false;
  }
}