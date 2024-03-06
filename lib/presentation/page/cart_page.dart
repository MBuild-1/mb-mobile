import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';

import '../../controller/cart_controller.dart';
import '../../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_list_parameter.dart';
import '../../domain/entity/cart/cart_paging_parameter.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/cart/update_cart_quantity_parameter.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/usecase/add_additional_item_use_case.dart';
import '../../domain/usecase/add_to_cart_use_case.dart';
import '../../domain/usecase/add_wishlist_use_case.dart';
import '../../domain/usecase/change_additional_item_use_case.dart';
import '../../domain/usecase/get_additional_item_use_case.dart';
import '../../domain/usecase/get_cart_list_use_case.dart';
import '../../domain/usecase/get_cart_summary_use_case.dart';
import '../../domain/usecase/get_my_cart_use_case.dart';
import '../../domain/usecase/remove_additional_item_use_case.dart';
import '../../domain/usecase/remove_from_cart_use_case.dart';
import '../../domain/usecase/update_cart_quantity_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/cart_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllercontentdelegate/shared_cart_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/separatedcartcontainerlistitemcontrollerstate/cart_separated_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/separatedcartcontainerlistitemcontrollerstate/separated_cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/separatedcartcontainerlistitemcontrollerstate/warehouse_separated_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/date_util.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/cart_empty_error.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error/warehouse_empty_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/cart_item_type_list_sub_interceptor.dart';
import '../../misc/itemtypelistsubinterceptor/separatedcartitemtypelistsubinterceptor/cart_separated_cart_item_type_list_sub_interceptor.dart';
import '../../misc/itemtypelistsubinterceptor/separatedcartitemtypelistsubinterceptor/warehouse_separated_cart_item_type_list_sub_interceptor.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/string_util.dart';
import '../../misc/toast_helper.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../notifier/product_notifier.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/horizontal_justified_title_and_description.dart';
import '../widget/modified_divider.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/sharedcart/shared_cart_indicator.dart';
import '../widget/solidtab/solid_tab.dart';
import '../widget/solidtab/solid_tab_group.dart';
import 'delivery_page.dart';
import 'getx_page.dart';
import 'modaldialogpage/add_additional_item_modal_dialog_page.dart';
import 'shared_cart_page.dart';

class CartPage extends RestorableGetxPage<_CartPageRestoration> {
  late final ControllerMember<CartController> _cartController = ControllerMember<CartController>().addToControllerManager(controllerManager);

  final CartPageParameter cartPageParameter;

  CartPage({
    Key? key,
    required this.cartPageParameter
  }) : super(
    key: key,
    pageRestorationId: () => "cart-page"
  );

  @override
  void onSetController() {
    _cartController.controller = GetExtended.put<CartController>(
      CartController(
        controllerManager,
        Injector.locator<GetCartListUseCase>(),
        Injector.locator<AddToCartUseCase>(),
        Injector.locator<RemoveFromCartUseCase>(),
        Injector.locator<GetCartSummaryUseCase>(),
        Injector.locator<GetAdditionalItemUseCase>(),
        Injector.locator<AddAdditionalItemUseCase>(),
        Injector.locator<ChangeAdditionalItemUseCase>(),
        Injector.locator<RemoveAdditionalItemUseCase>(),
        Injector.locator<AddWishlistUseCase>(),
        Injector.locator<UpdateCartQuantityUseCase>(),
        Injector.locator<SharedCartControllerContentDelegate>(),
      ),
      tag: pageName
    );
  }

  @override
  _CartPageRestoration createPageRestoration() => _CartPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulCartControllerMediatorWidget(
      cartController: _cartController.controller,
      cartPageParameter: cartPageParameter
    );
  }
}

class _CartPageRestoration extends ExtendedMixableGetxPageRestoration with CartPageRestorationMixin, DeliveryPageRestorationMixin, SharedCartPageRestorationMixin {
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

class CartPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final CartPageParameter cartPageParameter;

  CartPageGetPageBuilderAssistant({
    required this.cartPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => CartPage(cartPageParameter: cartPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(CartPage(cartPageParameter: cartPageParameter)));
}

mixin CartPageRestorationMixin on MixableGetxPageRestoration {
  late CartPageRestorableRouteFuture cartPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    cartPageRestorableRouteFuture = CartPageRestorableRouteFuture(restorationId: restorationIdWithPageName('cart-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    cartPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    cartPageRestorableRouteFuture.dispose();
  }
}

class CartPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  CartPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    CartPageParameter cartPageParameter = arguments.toCartPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        CartPageGetPageBuilderAssistant(cartPageParameter: cartPageParameter)
      ),
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

class _StatefulCartControllerMediatorWidget extends StatefulWidget {
  final CartController cartController;
  final CartPageParameter cartPageParameter;

  const _StatefulCartControllerMediatorWidget({
    required this.cartController,
    required this.cartPageParameter
  });

  @override
  State<_StatefulCartControllerMediatorWidget> createState() => _StatefulCartControllerMediatorWidgetState();
}

class _StatefulCartControllerMediatorWidgetState extends State<_StatefulCartControllerMediatorWidget> {
  late final ScrollController _cartScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _cartListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _cartListItemPagingControllerState;
  late final ScrollController _warehouseScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _warehouseListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _warehouseListItemPagingControllerState;
  int _cartCount = 0;
  late int _selectedCartCount = 0;
  late double _selectedCartShoppingTotal = 0;
  final List<AdditionalItem> _additionalItemList = [];
  List<Cart> _selectedCartList = [];
  int _additionalItemCount = 0;
  late int _selectedAdditionalItemCount = 0;
  late double _selectedAdditionalItemTotal = 0;
  List<AdditionalItem> _selectedAdditionalItemList = [];
  bool _isLoadingUpdateCartQuantity = false;
  List<WarehouseAdditionalItemStateValue>? _lastWarehouseAdditionalItemStateValueList;
  final CartSeparatedCartContainerInterceptingActionListItemControllerState _cartSeparatedCartContainerInterceptingActionListItemControllerState = DefaultCartSeparatedCartContainerInterceptingActionListItemControllerState();
  final WarehouseSeparatedCartContainerStateStorageListItemControllerState _warehouseSeparatedCartContainerStateStorageListItemControllerState = DefaultWarehouseSeparatedCartContainerStateStorageListItemControllerState();
  final WarehouseSeparatedCartContainerInterceptingActionListItemControllerState _warehouseSeparatedCartContainerInterceptingActionListItemControllerState = DefaultWarehouseSeparatedCartContainerInterceptingActionListItemControllerState();
  final Map<String, Timer> _updateCartQuantityTimerMap = {};
  final Map<String, CancelToken> _updateCartQuantityCancelTokenMap = {};
  final Map<String, bool> _isLoadingUpdatingCartQuantityMap = {};
  late final ProductNotifier _productNotifier;
  final List<SolidTabValue> _solidTabValueList = [
    SolidTabValue(
      text: MultiLanguageString(
        TrMultiLanguageStringValue(text: "Cart")
      ),
      value: "cart"
    ),
    SolidTabValue(
      text: MultiLanguageString(
        TrMultiLanguageStringValue(text: "Personal Stuffs")
      ),
      value: "personal stuffs"
    )
  ];
  int _selectedSolidTabIndex = 0;
  String _selectedSolidTabValue = "";
  bool _isCartLoading = false;
  bool _isWarehouseLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedSolidTabValue = () {
      CartPageParameter cartPageParameter = widget.cartPageParameter;
      if (cartPageParameter is TabRedirectionCartPageParameter) {
        if (cartPageParameter.tabRedirectionCartType == TabRedirectionCartType.warehouse) {
          return _solidTabValueList[1].value;
        }
      }
      return _solidTabValueList[0].value;
    }();
    _selectedSolidTabIndex = _getSelectedSolidTabIndexBasedSelectedSolidTabValue(_selectedSolidTabValue);
    _productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    _cartScrollController = ScrollController();
    _cartListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.cartController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<CartAdditionalPagingResultParameterChecker>()
    );
    _cartListItemPagingControllerState = PagingControllerState(
      pagingController: _cartListItemPagingController,
      scrollController: _cartScrollController,
      isPagingControllerExist: false
    );
    _cartListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _cartListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _cartListItemPagingControllerState.isPagingControllerExist = true;
    _warehouseScrollController = ScrollController();
    _warehouseListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.cartController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<CartAdditionalPagingResultParameterChecker>()
    );
    _warehouseListItemPagingControllerState = PagingControllerState(
      pagingController: _warehouseListItemPagingController,
      scrollController: _warehouseScrollController,
      isPagingControllerExist: false
    );
    _warehouseListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _warehouseListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _warehouseListItemPagingControllerState.isPagingControllerExist = true;
  }

  void _updateCartInformation() {
    _selectedCartShoppingTotal = 0;
    for (Cart cart in _selectedCartList) {
      SupportCart supportCart = cart.supportCart;
      _selectedCartShoppingTotal += supportCart.cartPrice * cart.quantity.toDouble();
    }
    if (_cartSeparatedCartContainerInterceptingActionListItemControllerState.getCartCount != null) {
      _cartCount = _cartSeparatedCartContainerInterceptingActionListItemControllerState.getCartCount!();
    }
  }

  void _updateWarehouseInformation() {
    if (_warehouseSeparatedCartContainerInterceptingActionListItemControllerState.getWarehouseAdditionalItemCount != null) {
      _additionalItemCount = _warehouseSeparatedCartContainerInterceptingActionListItemControllerState.getWarehouseAdditionalItemCount!();
    }
  }

  void _updateIsLoadingUpdateCartQuantity() {
    _isLoadingUpdateCartQuantity = _isLoadingUpdatingCartQuantityMap.isNotEmpty;
    setState(() {});
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _cartListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _cartCount = 0);
      Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
      Provider.of<ComponentNotifier>(context, listen: false).updateCart();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _isCartLoading = true);
      _productNotifier.loadCartListFromData(IsLoadingLoadDataResult<List<Cart>>());
    });
    await Future.delayed(const Duration(milliseconds: 50));
    LoadDataResult<List<Cart>> cartListLoadDataResult = await widget.cartController.getCartList(
      CartListParameter()
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _isCartLoading = false);
      _productNotifier.loadCartListFromData(cartListLoadDataResult);
    });
    return cartListLoadDataResult.map<PagingResult<ListItemControllerState>>((cartList) {
      List<CartListItemControllerState> newCartListItemControllerStateList = cartList.map<CartListItemControllerState>(
        (cart) => VerticalCartListItemControllerState(
          isSelected: false,
          cart: cart,
          onChangeQuantity: (oldQuantity, newQuantity) {
            int effectiveNewQuantity = newQuantity;
            if (effectiveNewQuantity < 1) {
              effectiveNewQuantity = 1;
              return;
            }
            if (_updateCartQuantityTimerMap[cart.id] != null) {
              _updateCartQuantityTimerMap[cart.id]?.cancel();
            }
            CancelToken? cancelToken = _updateCartQuantityCancelTokenMap[cart.id];
            if (cancelToken != null) {
              cancelToken.cancel();
            }
            cart.quantity = effectiveNewQuantity;
            _updateCartInformation();
            _isLoadingUpdatingCartQuantityMap[cart.id] = true;
            _updateIsLoadingUpdateCartQuantity();
            setState(() {});
            _updateCartQuantityTimerMap[cart.id] = Timer(
              const Duration(milliseconds: 500),
              () {
                widget.cartController.updateCartQuantity(
                  UpdateCartQuantityParameter(
                    cartId: cart.id,
                    quantity: newQuantity
                  ),
                  cart,
                  (cancelToken) => _updateCartQuantityCancelTokenMap[cart.id] = cancelToken
                );
              }
            );
          },
          onAddToWishlist: () => widget.cartController.addToWishlist(cart.supportCart as SupportWishlist),
          onRemoveCart: () {
            if (_updateCartQuantityTimerMap[cart.id] != null) {
              _updateCartQuantityTimerMap[cart.id]?.cancel();
            }
            CancelToken? cancelToken = _updateCartQuantityCancelTokenMap[cart.id];
            if (cancelToken != null) {
              cancelToken.cancel();
            }
            _isLoadingUpdatingCartQuantityMap.remove(cart.id);
            widget.cartController.removeCart(cart);
            _updateCartInformation();
            _updateIsLoadingUpdateCartQuantity();
            setState(() {});
          },
        )
      ).toList();
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          CartSeparatedCartContainerListItemControllerState(
            cartListItemControllerStateList: newCartListItemControllerStateList,
            onUpdateState: () => setState(() {}),
            onChangeSelected: (cartList) {
              setState(() {
                _selectedCartList = cartList;
                _selectedCartCount = cartList.length;
                _updateCartInformation();
              });
            },
            onCartChange: () {
              setState(() => _updateCartInformation());
              if (_cartCount == 0) {
                _cartListItemPagingController.errorFirstPageOuterProcess = CartEmptyError();
              }
            },
            cartSeparatedCartContainerStateStorageListItemControllerState: DefaultCartSeparatedCartContainerStateStorageListItemControllerState(),
            cartSeparatedCartContainerInterceptingActionListItemControllerState: _cartSeparatedCartContainerInterceptingActionListItemControllerState
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _warehouseListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? warehouseListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _isWarehouseLoading = true);
    });
    LoadDataResult<List<AdditionalItem>> additionalListLoadDataResult = await widget.cartController.getAdditionalItem(
      AdditionalItemListParameter()
    );
    if (additionalListLoadDataResult.isFailed) {
      dynamic e = additionalListLoadDataResult.resultIfFailed;
      if (e is WarehouseEmptyError) {
        _selectedAdditionalItemList = [];
        _selectedAdditionalItemCount = _selectedAdditionalItemList.length;
        _selectedAdditionalItemTotal = 0;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _isWarehouseLoading = false);
    });
    return additionalListLoadDataResult.map<PagingResult<ListItemControllerState>>((additionalItemList) {
      List<WarehouseAdditionalItemStateValue> warehouseAdditionalItemStateValueList = additionalItemList.map<WarehouseAdditionalItemStateValue>(
        (additionalItem) => WarehouseAdditionalItemStateValue(
          additionalItem: additionalItem,
          isSelected: () {
            if (_lastWarehouseAdditionalItemStateValueList == null) {
              return false;
            }
            Iterable<WarehouseAdditionalItemStateValue> warehouseAdditionalItemStateValueIterable = _lastWarehouseAdditionalItemStateValueList!.where(
              (lastAdditionalItemStateValue) => additionalItem.id == lastAdditionalItemStateValue.additionalItem.id
            );
            if (warehouseAdditionalItemStateValueIterable.isNotEmpty) {
              return warehouseAdditionalItemStateValueIterable.first.isSelected;
            }
            return false;
          }()
        )
      ).toList();
      _lastWarehouseAdditionalItemStateValueList = List.of(warehouseAdditionalItemStateValueList);
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          WarehouseSeparatedCartContainerListItemControllerState(
            warehouseAdditionalItemStateValueList: warehouseAdditionalItemStateValueList,
            onUpdateState: () => setState(() {}),
            onChangeSelected: (additionalItemList) {
              setState(() {
                _selectedAdditionalItemList = additionalItemList;
                _selectedAdditionalItemCount = additionalItemList.length;
                _updateWarehouseInformation();
              });
            },
            onWarehouseAdditionalItemChange: () {
              setState(() => _updateWarehouseInformation());
              if (_additionalItemCount == 0) {
                _warehouseListItemPagingController.errorFirstPageOuterProcess = WarehouseEmptyError();
              }
            },
            warehouseSeparatedCartContainerStateStorageListItemControllerState: _warehouseSeparatedCartContainerStateStorageListItemControllerState,
            warehouseSeparatedCartContainerInterceptingActionListItemControllerState: _warehouseSeparatedCartContainerInterceptingActionListItemControllerState,
            onRemoveWarehouseAdditionalItem: widget.cartController.removeWarehouseAdditionalItem,
            onLoadWarehouseAdditionalItem: _warehouseListItemPagingController.refresh,
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  int _getSelectedSolidTabIndexBasedSelectedSolidTabValue(String selectedValue) {
    int i = 0;
    while (i < _solidTabValueList.length) {
      if (_solidTabValueList[i].value == selectedValue) {
        return i;
      }
      i++;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    widget.cartController.setCartDelegate(
      CartDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onCartBack: () => Get.back(),
        onShowAddToWishlistRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowAddToWishlistRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onAddToWishlistRequestProcessSuccessCallback: () async {
          ToastHelper.showToast("${"Success add to wishlist".tr}.");
        },
        onShowRemoveCartRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowRemoveCartRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onRemoveCartRequestProcessSuccessCallback: (cart) async {
          if (_cartSeparatedCartContainerInterceptingActionListItemControllerState.removeCart != null) {
            _cartSeparatedCartContainerInterceptingActionListItemControllerState.removeCart!(cart);
            Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
            Provider.of<ComponentNotifier>(context, listen: false).updateCart();
            Provider.of<ProductNotifier>(context, listen: false).loadCartList();
          }
        },
        onShowUpdateCartQuantityRequestProcessLoadingCallback: () async {
          return false;
        },
        onShowUpdateCartQuantityRequestProcessFailedCallback: (e, cart) async {
          _isLoadingUpdatingCartQuantityMap.remove(cart.id);
          _updateIsLoadingUpdateCartQuantity();
          ToastHelper.showToast(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "Failed to update many items. Please try adding/removing more items.",
              Constant.textInIdLanguageKey: "Gagal update banyak barang. Silahkan coba tambahkan/kurangi banyak barang lagi."
            }).toStringNonNull
          );
        },
        onUpdateCartQuantityRequestProcessSuccessCallback: (response, cart) async {
          _isLoadingUpdatingCartQuantityMap.remove(cart.id);
          _updateIsLoadingUpdateCartQuantity();
        },
        onShowRemoveWarehouseRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onRemoveWarehouseRequestProcessSuccessCallback: () async => _warehouseListItemPagingController.refresh(),
        onShowRemoveWarehouseRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        )
      )
    );
    widget.cartController.sharedCartControllerContentDelegate.setSharedCartDelegate(
      Injector.locator<SharedCartDelegateFactory>().generateSharedCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>()
      )
    );
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Cart".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SolidTabGroup(
              solidTabValueList: _solidTabValueList,
              selectedValue: _selectedSolidTabValue,
              onSelectTab: (value) {
                setState(() {
                  _selectedSolidTabValue = value;
                  _selectedSolidTabIndex = _getSelectedSolidTabIndexBasedSelectedSolidTabValue(_selectedSolidTabValue);
                });
              }
            ),
            const ModifiedDivider(),
            Expanded(
              child: IndexedStack(
                index: _selectedSolidTabIndex,
                children: [
                  ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                    pagingControllerState: _cartListItemPagingControllerState,
                    onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                      pagingControllerState: pagingControllerState!
                    ),
                    pullToRefresh: true
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child:  SizedOutlineGradientButton(
                          onPressed: () async {
                            dynamic result = await DialogHelper.showModalDialogPage<String, String>(
                              context: context,
                              modalDialogPageBuilder: (context, parameter) => AddAdditionalItemModalDialogPage(),
                            );
                            if (result != null) {
                              _warehouseListItemPagingController.refresh();
                            }
                          },
                          text: "+ ${"Add Item".tr}",
                          outlineGradientButtonType: OutlineGradientButtonType.solid,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                        ),
                      ),
                      Expanded(
                        child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                          pagingControllerState: _warehouseListItemPagingControllerState,
                          onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                            pagingControllerState: pagingControllerState!
                          ),
                          pullToRefresh: true
                        ),
                      ),
                    ],
                  ),
                ]
              )
            ),
            if (!_isCartLoading && !_isWarehouseLoading)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SharedCartIndicator(
                      onTap: () => widget.cartController.sharedCartControllerContentDelegate.checkSharedCart(),
                    ),
                    const SizedBox(height: 16),
                    HorizontalJustifiedTitleAndDescription(
                      title: MultiLanguageString({
                        Constant.textEnUsLanguageKey: "Selected cart",
                        Constant.textInIdLanguageKey: "Keranjang yang dipilih"
                      }).toEmptyStringNonNull,
                      description: "$_selectedCartCount item",
                      titleWidgetInterceptor: (title, widget) => Text(
                        title.toStringNonNull,
                      ),
                      descriptionWidgetInterceptor: (description, widget) => Text(
                        description.toStringNonNull,
                      ),
                    ),
                    const SizedBox(height: 4),
                    HorizontalJustifiedTitleAndDescription(
                      title: MultiLanguageString({
                        Constant.textEnUsLanguageKey: "Selected personal stuffs",
                        Constant.textInIdLanguageKey: "Barang pribadi yang dipilih"
                      }).toEmptyStringNonNull,
                      description: "$_selectedAdditionalItemCount item",
                      titleWidgetInterceptor: (title, widget) => Text(
                        title.toStringNonNull,
                      ),
                      descriptionWidgetInterceptor: (description, widget) => Text(
                        description.toStringNonNull,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Shopping Total".tr),
                                const SizedBox(height: 4),
                                Text(_selectedCartShoppingTotal.toRupiah(withFreeTextIfZero: false), style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                )),
                              ]
                            ),
                          ],
                        ),
                        const Expanded(
                          child: SizedBox()
                        ),
                        Builder(
                          builder: (context) {
                            int count = _selectedCartCount + _selectedAdditionalItemCount;
                            return SizedOutlineGradientButton(
                              onPressed: count == 0 ? null : (
                                _isLoadingUpdateCartQuantity ? null : () {
                                  PageRestorationHelper.toDeliveryPage(
                                    context, DeliveryPageParameter(
                                      selectedCartIdList: _selectedCartList.map<List<String>>((cart) {
                                        return <String>[cart.id, cart.quantity.toString()];
                                      }).toList(),
                                      selectedAdditionalItemIdList: _selectedAdditionalItemList.map<String>((additionalItem) {
                                        return additionalItem.id;
                                      }).toList(),
                                    )
                                  );
                                }
                              ),
                              width: 120,
                              text: _isLoadingUpdateCartQuantity ? "${"Loading".tr}..." : "${"Checkout".tr} ($count)",
                              outlineGradientButtonType: OutlineGradientButtonType.solid,
                              outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                            );
                          }
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
    for (var timerEntry in _updateCartQuantityTimerMap.entries) {
      timerEntry.value.cancel();
    }
    super.dispose();
  }
}

class _DefaultCartContainerActionListItemControllerState extends CartContainerActionListItemControllerState {
  final Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter)? _getAdditionalItemList;
  final Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter)? _addAdditionalItem;
  final Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter)? _changeAdditionalItem;
  final Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter)? _removeAdditionalItem;

  _DefaultCartContainerActionListItemControllerState({
    required Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter) getAdditionalItemList,
    required Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter) addAdditionalItem,
    required Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter) changeAdditionalItem,
    required Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter) removeAdditionalItem,
  }) : _getAdditionalItemList = getAdditionalItemList,
      _addAdditionalItem = addAdditionalItem,
      _changeAdditionalItem = changeAdditionalItem,
      _removeAdditionalItem = removeAdditionalItem;

  @override
  Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter) get getAdditionalItemList => _getAdditionalItemList ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter) get addAdditionalItem => _addAdditionalItem ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter) get changeAdditionalItem => _changeAdditionalItem ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter) get removeAdditionalItem => _removeAdditionalItem ?? (throw UnimplementedError());
}

abstract class CartPageParameter {}

class DefaultCartPageParameter extends CartPageParameter {}

class TabRedirectionCartPageParameter extends CartPageParameter {
  TabRedirectionCartType tabRedirectionCartType;

  TabRedirectionCartPageParameter({
    required this.tabRedirectionCartType
  });
}

enum TabRedirectionCartType {
  cart, warehouse
}

extension CartPageParameterExt on CartPageParameter {
  String toJsonString() => StringUtil.encodeJson(
    () {
      if (this is TabRedirectionCartPageParameter) {
        TabRedirectionCartPageParameter tabRedirectionCartPageParameter = this as TabRedirectionCartPageParameter;
        return <String, dynamic>{
          "type": "tab-redirection-page-parameter",
          "value": <String, dynamic>{
            "tab_redirection_cart_page_type": () {
              TabRedirectionCartType tabRedirectionCartType = tabRedirectionCartPageParameter.tabRedirectionCartType;
              if (tabRedirectionCartType == TabRedirectionCartType.cart) {
                return "cart";
              } else if (tabRedirectionCartType == TabRedirectionCartType.warehouse) {
                return "personal stuffs";
              }
              throw MessageError(title: "Tab redirection cart page type is not suitable");
            }()
          }
        };
      } else {
        return <String, dynamic>{
          "type": "default-cart-page-parameter"
        };
      }
    }()
  );
}

extension CartPageParameterStringExt on String {
  CartPageParameter toCartPageParameter() {
    Map<String, dynamic> result = StringUtil.decodeJson(this);
    String? type = result["type"];
    if (type == "tab-redirection-page-parameter") {
      return TabRedirectionCartPageParameter(
        tabRedirectionCartType: () {
          dynamic value = result["value"];
          if (value is Map<String, dynamic>) {
            if (value.containsKey("tab_redirection_cart_page_type")) {
              String? tabRedirectionCartPageType = value["tab_redirection_cart_page_type"];
              if (tabRedirectionCartPageType == "cart") {
                return TabRedirectionCartType.cart;
              } else if (tabRedirectionCartPageType == "personal stuffs") {
                return TabRedirectionCartType.warehouse;
              } else {
                throw MessageError(title: "Tab redirection cart page type is not suitable");
              }
            } else {
              throw MessageError(title: "Tab redirection cart page type field is not exist");
            }
          } else {
            throw MessageError(title: "Type must be Map");
          }
        }()
      );
    } else {
      return DefaultCartPageParameter();
    }
  }
}