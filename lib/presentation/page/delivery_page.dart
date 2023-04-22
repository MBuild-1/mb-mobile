import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/delivery_controller.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_paging_parameter.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/usecase/get_current_selected_address_use_case.dart';
import '../../domain/usecase/get_my_cart_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/cart_additional_paging_result_parameter_checker.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/deliverycartlistitemcontrollerstate/delivery_cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/cart_item_type_list_sub_interceptor.dart';
import '../../misc/itemtypelistsubinterceptor/delivery_cart_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';

class DeliveryPage extends RestorableGetxPage<_DeliveryPageRestoration> {
  late final ControllerMember<DeliveryController> _deliveryController = ControllerMember<DeliveryController>().addToControllerManager(controllerManager);

  DeliveryPage({Key? key}) : super(key: key, pageRestorationId: () => "delivery-page");

  @override
  void onSetController() {
    _deliveryController.controller = GetExtended.put<DeliveryController>(
      DeliveryController(
        controllerManager,
        Injector.locator<GetMyCartUseCase>(),
        Injector.locator<GetCurrentSelectedAddressUseCase>()
      ), tag: pageName
    );
  }

  @override
  _DeliveryPageRestoration createPageRestoration() => _DeliveryPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulDeliveryControllerMediatorWidget(
        deliveryController: _deliveryController.controller,
      ),
    );
  }
}

class _DeliveryPageRestoration extends MixableGetxPageRestoration with DeliveryPageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class DeliveryPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => DeliveryPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(DeliveryPage()));
}

mixin DeliveryPageRestorationMixin on MixableGetxPageRestoration {
  late DeliveryPageRestorableRouteFuture deliveryPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    deliveryPageRestorableRouteFuture = DeliveryPageRestorableRouteFuture(restorationId: restorationIdWithPageName('delivery-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    deliveryPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    deliveryPageRestorableRouteFuture.dispose();
  }
}

class DeliveryPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  DeliveryPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(DeliveryPageGetPageBuilderAssistant()),
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulDeliveryControllerMediatorWidget extends StatefulWidget {
  final DeliveryController deliveryController;

  const _StatefulDeliveryControllerMediatorWidget({
    required this.deliveryController
  });

  @override
  State<_StatefulDeliveryControllerMediatorWidget> createState() => _StatefulDeliveryControllerMediatorWidgetState();
}

class _StatefulDeliveryControllerMediatorWidgetState extends State<_StatefulDeliveryControllerMediatorWidget> {
  late final ScrollController _deliveryScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _deliveryListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _deliveryListItemPagingControllerState;
  late int _selectedCartCount = 0;
  late double _selectedCartShoppingTotal = 0;
  List<AdditionalItem> _additionalItemList = [];

  @override
  void initState() {
    super.initState();
    _deliveryScrollController = ScrollController();
    _deliveryListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.deliveryController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<CartAdditionalPagingResultParameterChecker>()
    );
    _deliveryListItemPagingControllerState = PagingControllerState(
      pagingController: _deliveryListItemPagingController,
      scrollController: _deliveryScrollController,
      isPagingControllerExist: false
    );
    _deliveryListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _deliveryListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _deliveryListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _deliveryListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    LoadDataResult<PagingDataResult<Cart>> cartPagingLoadDataResult = await widget.deliveryController.getDeliveryCartPaging(
      CartPagingParameter(page: pageKey)
    );
    return cartPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((cartPaging) {
      List<CartListItemControllerState> newCartListItemControllerStateList = cartPaging.itemList.map<CartListItemControllerState>(
        (cart) => VerticalCartListItemControllerState(
          isSelected: false,
          cart: cart
        )
      ).toList();
      if (pageKey == 1) {
        return PagingDataResult<ListItemControllerState>(
          itemList: [
            DeliveryCartContainerListItemControllerState(
              cartListItemControllerStateList: newCartListItemControllerStateList,
              onUpdateState: () => setState(() {}),
              onScrollToAdditionalItemsSection: () => _deliveryScrollController.jumpTo(
                _deliveryScrollController.position.maxScrollExtent
              ),
              additionalItemList: _additionalItemList,
              onChangeSelected: (cartList) {
                setState(() {
                  _selectedCartCount = cartList.length;
                  _selectedCartShoppingTotal = 0;
                  for (Cart cart in cartList) {
                    SupportCart supportCart = cart.supportCart;
                    _selectedCartShoppingTotal += supportCart.cartPrice * cart.quantity.toDouble();
                  }
                });
              },
              deliveryCartContainerStateStorageListItemControllerState: DefaultDeliveryCartContainerStateStorageListItemControllerState()
            )
          ],
          page: cartPaging.page,
          totalPage: cartPaging.totalPage,
          totalItem: 1
        );
      } else {
        if (cartListItemControllerStateList != null) {
          if (cartListItemControllerStateList.isNotEmpty) {
            ListItemControllerState cartListItemControllerState = cartListItemControllerStateList.first;
            if (cartListItemControllerState is PageKeyedListItemControllerState) {
              if (cartListItemControllerState.listItemControllerState != null) {
                cartListItemControllerState = cartListItemControllerState.listItemControllerState!;
              }
            }
            if (cartListItemControllerState is CartContainerListItemControllerState) {
              cartListItemControllerState.cartListItemControllerStateList.addAll(
                newCartListItemControllerStateList
              );
            }
          }
        }
        return PagingDataResult<ListItemControllerState>(
          itemList: [],
          page: cartPaging.page,
          totalPage: cartPaging.totalPage,
          totalItem: 0
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Delivery".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _deliveryListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shopping Total".tr),
                            const SizedBox(height: 4),
                            Text(_selectedCartShoppingTotal.toRupiah(), style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )),
                          ]
                        )
                      ),
                      SizedOutlineGradientButton(
                        onPressed: _selectedCartCount == 0 ? null : () {},
                        width: 120,
                        text: "${"Pay".tr} ($_selectedCartCount)",
                        outlineGradientButtonType: OutlineGradientButtonType.solid,
                        outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                      )
                    ],
                  )
                ]
              ),
            )
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}