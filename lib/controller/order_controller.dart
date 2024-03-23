import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/cart/cart.dart';
import '../domain/entity/componententity/dynamic_item_carousel_component_entity.dart';
import '../domain/entity/componententity/i_dynamic_item_carousel_component_entity.dart';
import '../domain/entity/order/combined_order.dart';
import '../domain/entity/order/order_paging_parameter.dart';
import '../domain/usecase/arrived_order_use_case.dart';
import '../domain/usecase/get_order_paging_use_case.dart';
import '../domain/usecase/get_short_my_cart_use_case.dart';
import '../misc/constant.dart';
import '../misc/controllercontentdelegate/arrived_order_controller_content_delegate.dart';
import '../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../misc/error/message_error.dart';
import '../misc/load_data_result.dart';
import '../misc/multi_language_string.dart';
import '../misc/on_observe_load_product_delegate.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class OrderController extends BaseGetxController {
  final GetOrderPagingUseCase getOrderPagingUseCase;
  final ArrivedOrderUseCase arrivedOrderUseCase;
  final GetShortMyCartUseCase getShortMyCartUseCase;
  final RepurchaseControllerContentDelegate repurchaseControllerContentDelegate;
  final ArrivedOrderControllerContentDelegate arrivedOrderControllerContentDelegate;

  OrderDelegate? _orderDelegate;

  OrderController(
    super.controllerManager,
    this.getOrderPagingUseCase,
    this.arrivedOrderUseCase,
    this.getShortMyCartUseCase,
    this.repurchaseControllerContentDelegate,
    this.arrivedOrderControllerContentDelegate
  ) {
    repurchaseControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
    arrivedOrderControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  void setOrderDelegate(OrderDelegate orderDelegate) {
    _orderDelegate = orderDelegate;
  }

  IDynamicItemCarouselComponentEntity getMyCart() {
    RepeatableDynamicItemCarouselAdditionalParameter repeatableDynamicItemCarouselAdditionalParameter = RepeatableDynamicItemCarouselAdditionalParameter();
    return DynamicItemCarouselComponentEntity(
      title: MultiLanguageString({
        Constant.textEnUsLanguageKey: "My Cart",
        Constant.textInIdLanguageKey: "Keranjang Saya"
      }),
      onDynamicItemAction: (title, description, observer) async {
        observer(title, description, IsLoadingLoadDataResult<List<Cart>>());
        LoadDataResult<List<Cart>> cartPagingLoadDataResult = await getShortMyCartUseCase.execute().future(
          parameter: apiRequestManager.addRequestToCancellationPart("short-my-cart").value
        );
        if (cartPagingLoadDataResult.isFailedBecauseCancellation) {
          return;
        }
        observer(title, description, cartPagingLoadDataResult);
      },
      onObserveLoadingDynamicItemActionState: (title, description, loadDataResult) {
        if (_orderDelegate != null) {
          return _orderDelegate!.onObserveLoadProductDelegate.onObserveLoadingLoadCartCarousel(
            OnObserveLoadingLoadCartCarouselParameter(
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        }
      },
      onObserveSuccessDynamicItemActionState: (title, description, loadDataResult) {
        List<Cart> cartList = loadDataResult.resultIfSuccess!;
        if (_orderDelegate != null) {
          return _orderDelegate!.onObserveLoadProductDelegate.onObserveSuccessLoadCartCarousel(
            OnObserveSuccessLoadCartCarouselParameter(
              title: title,
              description: description,
              cartList: cartList,
              data: Constant.carouselKeyShortMyCart,
              elevation: 3,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        }
        throw MessageError(title: "My cart delegate must be initialized");
      },
      onObserveFailedDynamicItemActionState: (title, description, loadDataResult) {
        if (_orderDelegate != null) {
          return _orderDelegate!.onObserveLoadProductDelegate.onObserveFailedLoadCartCarousel(
            OnObserveFailedLoadCartCarouselParameter(
              e: (loadDataResult as FailedLoadDataResult).e,
              repeatableDynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter
            )
          );
        }
        throw MessageError(title: "My cart delegate must be initialized");
      },
      dynamicItemCarouselAdditionalParameter: repeatableDynamicItemCarouselAdditionalParameter,
    );
  }

  Future<LoadDataResult<PagingDataResult<CombinedOrder>>> getOrderPaging(OrderPagingParameter orderPagingParameter) {
    return getOrderPagingUseCase.execute(orderPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("cart").value
    );
  }
}

class OrderDelegate {
  OnObserveLoadProductDelegate onObserveLoadProductDelegate;

  OrderDelegate({
    required this.onObserveLoadProductDelegate,
  });
}