import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/take_friend_cart_controller.dart';
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
import '../../domain/entity/cart/host_cart.dart';
import '../../domain/entity/cart/support_cart.dart';
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
import '../../misc/additionalloadingindicatorchecker/take_friend_cart_additional_paging_result_parameter_checker.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/host_cart_indicator_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/spacing_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/cart_empty_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/cart_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/toast_helper.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'delivery_page.dart';
import 'getx_page.dart';

class TakeFriendCartPage extends RestorableGetxPage<_TakeFriendCartPageRestoration> {
  late final ControllerMember<TakeFriendCartController> _takeFriendCartController = ControllerMember<TakeFriendCartController>().addToControllerManager(controllerManager);

  TakeFriendCartPage({Key? key}) : super(key: key, pageRestorationId: () => "take-friend-cart-page");

  @override
  void onSetController() {
    _takeFriendCartController.controller = GetExtended.put<TakeFriendCartController>(
      TakeFriendCartController(
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
      ), tag: pageName
    );
  }

  @override
  _TakeFriendCartPageRestoration createPageRestoration() => _TakeFriendCartPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulTakeFriendCartControllerMediatorWidget(
        takeFriendCartController: _takeFriendCartController.controller,
      ),
    );
  }
}

class _TakeFriendCartPageRestoration extends MixableGetxPageRestoration with TakeFriendCartPageRestorationMixin {
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

class TakeFriendCartPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => TakeFriendCartPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(TakeFriendCartPage()));
}

mixin TakeFriendCartPageRestorationMixin on MixableGetxPageRestoration {
  late TakeFriendCartPageRestorableRouteFuture takeFriendCartPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    takeFriendCartPageRestorableRouteFuture = TakeFriendCartPageRestorableRouteFuture(restorationId: restorationIdWithPageName('take-friend-cart-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    takeFriendCartPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    takeFriendCartPageRestorableRouteFuture.dispose();
  }
}

class TakeFriendCartPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  TakeFriendCartPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(TakeFriendCartPageGetPageBuilderAssistant()),
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

class _StatefulTakeFriendCartControllerMediatorWidget extends StatefulWidget {
  final TakeFriendCartController takeFriendCartController;

  const _StatefulTakeFriendCartControllerMediatorWidget({
    required this.takeFriendCartController
  });

  @override
  State<_StatefulTakeFriendCartControllerMediatorWidget> createState() => _StatefulTakeFriendCartControllerMediatorWidgetState();
}

class _StatefulTakeFriendCartControllerMediatorWidgetState extends State<_StatefulTakeFriendCartControllerMediatorWidget> {
  late final ScrollController _takeFriendCartScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _takeFriendCartListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _takeFriendCartListItemPagingControllerState;
  int _cartCount = 0;
  late int _selectedCartCount = 0;
  late double _selectedCartShoppingTotal = 0;
  List<AdditionalItem> _additionalItemList = [];
  List<Cart> _selectedCartList = [];
  CartContainerInterceptingActionListItemControllerState _cartContainerInterceptingActionListItemControllerState = DefaultCartContainerInterceptingActionListItemControllerState();

  @override
  void initState() {
    super.initState();
    _takeFriendCartScrollController = ScrollController();
    _takeFriendCartListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.takeFriendCartController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<TakeFriendCartAdditionalPagingResultParameterChecker>()
    );
    _takeFriendCartListItemPagingControllerState = PagingControllerState(
      pagingController: _takeFriendCartListItemPagingController,
      scrollController: _takeFriendCartScrollController,
      isPagingControllerExist: false
    );
    _takeFriendCartListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _takeFriendCartListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _takeFriendCartListItemPagingControllerState.isPagingControllerExist = true;
  }

  void _updateCartInformation() {
    _selectedCartShoppingTotal = 0;
    for (Cart cart in _selectedCartList) {
      SupportCart supportCart = cart.supportCart;
      _selectedCartShoppingTotal += supportCart.cartPrice * cart.quantity.toDouble();
    }
    if (_cartContainerInterceptingActionListItemControllerState.getCartCount != null) {
      _cartCount = _cartContainerInterceptingActionListItemControllerState.getCartCount!();
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _takeFriendCartListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _cartCount = 0);
      Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
      Provider.of<ComponentNotifier>(context, listen: false).updateCart();
    });
    LoadDataResult<List<Cart>> cartListLoadDataResult = await widget.takeFriendCartController.getCartList(
      CartListParameter()
    );
    return cartListLoadDataResult.map<PagingResult<ListItemControllerState>>((cartList) {
      List<CartListItemControllerState> newCartListItemControllerStateList = cartList.map<CartListItemControllerState>(
        (cart) => VerticalCartListItemControllerState(
          isSelected: false,
          cart: cart,
          onChangeQuantity: (oldQuantity, newQuantity) {
            setState(() {
              int effectiveNewQuantity = newQuantity;
              if (effectiveNewQuantity < 1) {
                effectiveNewQuantity = 1;
              }
              cart.quantity = effectiveNewQuantity;
              _updateCartInformation();
            });
          },
          onAddToWishlist: () => widget.takeFriendCartController.addToWishlist(cart.supportCart as SupportWishlist),
          onRemoveCart: () {
            widget.takeFriendCartController.removeCart(cart);
            _updateCartInformation();
          },
        )
      ).toList();
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.all(4.w),
            paddingChildListItemControllerState: HostCartIndicatorListItemControllerState(hostCart: HostCart(username: "test"))
          ),
          SpacingListItemControllerState(),
          CartContainerListItemControllerState(
            cartListItemControllerStateList: newCartListItemControllerStateList,
            onUpdateState: () => setState(() {}),
            onScrollToAdditionalItemsSection: () => _takeFriendCartScrollController.jumpTo(
              _takeFriendCartScrollController.position.maxScrollExtent
            ),
            additionalItemList: _additionalItemList,
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
                _takeFriendCartListItemPagingController.errorFirstPageOuterProcess = CartEmptyError();
              }
            },
            cartContainerStateStorageListItemControllerState: DefaultCartContainerStateStorageListItemControllerState(),
            cartContainerActionListItemControllerState: _DefaultTakeFriendCartContainerActionListItemControllerState(
              getAdditionalItemList: (additionalItemListParameter) => widget.takeFriendCartController.getAdditionalItem(additionalItemListParameter),
              addAdditionalItem: (addAdditionalItemParameter) => widget.takeFriendCartController.addAdditionalItem(addAdditionalItemParameter),
              changeAdditionalItem: (changeAdditionalItemParameter) => widget.takeFriendCartController.changeAdditionalItem(changeAdditionalItemParameter),
              removeAdditionalItem: (removeAdditionalItemParameter) => widget.takeFriendCartController.removeAdditionalItem(removeAdditionalItemParameter),
            ),
            cartContainerInterceptingActionListItemControllerState: _cartContainerInterceptingActionListItemControllerState
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.takeFriendCartController.setTakeFriendCartDelegate(
      TakeFriendCartDelegate(
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
          if (_cartContainerInterceptingActionListItemControllerState.removeCart != null) {
            _cartContainerInterceptingActionListItemControllerState.removeCart!(cart);
            Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
            Provider.of<ComponentNotifier>(context, listen: false).updateCart();
          }
        },
      )
    );
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Shared Cart".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _takeFriendCartListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
            if (_cartCount > 0)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        SizedOutlineGradientButton(
                          onPressed: _selectedCartCount == 0 ? null : () {
                            PageRestorationHelper.toDeliveryPage(
                              context, DeliveryPageParameter(
                                selectedCartIdList: _selectedCartList.map<List<String>>((cart) {
                                  return <String>[cart.id, cart.quantity.toString()];
                                }).toList(),
                                selectedAdditionalItemIdList: _additionalItemList.map<String>((additionalItem) {
                                  return additionalItem.id;
                                }).toList(),
                              )
                            );
                          },
                          width: 120,
                          text: "${"Checkout".tr} ($_selectedCartCount)",
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

class _DefaultTakeFriendCartContainerActionListItemControllerState extends CartContainerActionListItemControllerState {
  final Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter)? _getAdditionalItemList;
  final Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter)? _addAdditionalItem;
  final Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter)? _changeAdditionalItem;
  final Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter)? _removeAdditionalItem;

  _DefaultTakeFriendCartContainerActionListItemControllerState({
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
