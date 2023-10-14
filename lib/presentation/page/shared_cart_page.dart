import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/host_cart_controller.dart';
import '../../controller/shared_cart_controller.dart';
import '../../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../../domain/entity/bucket/bucket.dart';
import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_list_parameter.dart';
import '../../domain/entity/cart/host_cart.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/usecase/add_additional_item_use_case.dart';
import '../../domain/usecase/add_to_cart_use_case.dart';
import '../../domain/usecase/add_wishlist_use_case.dart';
import '../../domain/usecase/approve_or_reject_request_bucket_use_case.dart';
import '../../domain/usecase/change_additional_item_use_case.dart';
import '../../domain/usecase/check_bucket_use_case.dart';
import '../../domain/usecase/checkout_bucket_use_case.dart';
import '../../domain/usecase/create_bucket_use_case.dart';
import '../../domain/usecase/get_additional_item_use_case.dart';
import '../../domain/usecase/get_cart_list_use_case.dart';
import '../../domain/usecase/get_cart_summary_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/remove_additional_item_use_case.dart';
import '../../domain/usecase/remove_from_cart_use_case.dart';
import '../../domain/usecase/remove_member_bucket_use_case.dart';
import '../../domain/usecase/request_join_bucket_use_case.dart';
import '../../domain/usecase/show_bucket_by_id_use_case.dart';
import '../../domain/usecase/trigger_bucket_ready_use_case.dart';
import '../../misc/acceptordeclinesharedcartmemberparameter/accept_shared_cart_member_parameter.dart';
import '../../misc/acceptordeclinesharedcartmemberparameter/decline_shared_cart_member_parameter.dart';
import '../../misc/additionalloadingindicatorchecker/host_cart_additional_paging_result_parameter_checker.dart';
import '../../misc/additionalloadingindicatorchecker/shared_cart_additional_paging_result_parameter_checker.dart';
import '../../misc/controllercontentdelegate/shared_cart_controller_content_delegate.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shared_cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/host_cart_indicator_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
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

class SharedCartPage extends RestorableGetxPage<_SharedCartPageRestoration> {
  late final ControllerMember<SharedCartController> _sharedCartController = ControllerMember<SharedCartController>().addToControllerManager(controllerManager);

  SharedCartPage({Key? key}) : super(key: key, pageRestorationId: () => "shared-cart-page");

  @override
  void onSetController() {
    _sharedCartController.controller = GetExtended.put<SharedCartController>(
      SharedCartController(
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
        Injector.locator<CreateBucketUseCase>(),
        Injector.locator<RequestJoinBucketUseCase>(),
        Injector.locator<CheckBucketUseCase>(),
        Injector.locator<ShowBucketByIdUseCase>(),
        Injector.locator<GetUserUseCase>(),
        Injector.locator<ApproveOrRejectRequestBucketUseCase>(),
        Injector.locator<RemoveMemberBucketUseCase>(),
        Injector.locator<TriggerBucketReadyUseCase>(),
        Injector.locator<CheckoutBucketUseCase>(),
      ), tag: pageName
    );
  }

  @override
  _SharedCartPageRestoration createPageRestoration() => _SharedCartPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulSharedCartControllerMediatorWidget(
        sharedCartController: _sharedCartController.controller,
      ),
    );
  }
}

class _SharedCartPageRestoration extends MixableGetxPageRestoration {
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

class SharedCartPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => SharedCartPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(SharedCartPage()));
}

mixin SharedCartPageRestorationMixin on MixableGetxPageRestoration {
  late SharedCartPageRestorableRouteFuture sharedCartPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    sharedCartPageRestorableRouteFuture = SharedCartPageRestorableRouteFuture(restorationId: restorationIdWithPageName('shared-cart-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    sharedCartPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    sharedCartPageRestorableRouteFuture.dispose();
  }
}

class SharedCartPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  SharedCartPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(SharedCartPageGetPageBuilderAssistant()),
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

class _StatefulSharedCartControllerMediatorWidget extends StatefulWidget {
  final SharedCartController sharedCartController;

  const _StatefulSharedCartControllerMediatorWidget({
    required this.sharedCartController
  });

  @override
  State<_StatefulSharedCartControllerMediatorWidget> createState() => _StatefulSharedCartControllerMediatorWidgetState();
}

class _StatefulSharedCartControllerMediatorWidgetState extends State<_StatefulSharedCartControllerMediatorWidget> {
  late final ScrollController _sharedCartScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _sharedCartListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _sharedCartListItemPagingControllerState;
  int _cartCount = 0;
  late int _selectedCartCount = 0;
  late double _selectedCartShoppingTotal = 0;
  List<AdditionalItem> _additionalItemList = [];
  List<Cart> _selectedCartList = [];
  LoadDataResult<User> _userLoadDataResult = NoLoadDataResult<User>();
  LoadDataResult<Bucket> _bucketLoadDataResult = NoLoadDataResult<Bucket>();
  LoadDataResult<BucketMember> _bucketMemberLoadDataResult = NoLoadDataResult<BucketMember>();
  LoadDataResult<List<Cart>> _cartListLoadDataResult = NoLoadDataResult<List<Cart>>();
  CartContainerInterceptingActionListItemControllerState _cartContainerInterceptingActionListItemControllerState = DefaultCartContainerInterceptingActionListItemControllerState();
  String? _bucketId;
  BucketMember? _expandedBucketMember;

  @override
  void initState() {
    super.initState();
    _sharedCartScrollController = ScrollController();
    _sharedCartListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.sharedCartController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<SharedCartAdditionalPagingResultParameterChecker>()
    );
    _sharedCartListItemPagingControllerState = PagingControllerState(
      pagingController: _sharedCartListItemPagingController,
      scrollController: _sharedCartScrollController,
      isPagingControllerExist: false
    );
    _sharedCartListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _sharedCartListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _sharedCartListItemPagingControllerState.isPagingControllerExist = true;
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

  Future<void> _updateSharedCartData() async {
    _userLoadDataResult = await widget.sharedCartController.getUser();
    _bucketLoadDataResult = (await widget.sharedCartController.showBucketByLoggedUserId()).map<Bucket>(
      (value) => value.bucket
    );
    _bucketMemberLoadDataResult = await widget.sharedCartController.getBucketMember(
      bucketLoadDataResult: _bucketLoadDataResult,
      parameterUserLoadDataResult: _userLoadDataResult,
    );
    _cartListLoadDataResult = await widget.sharedCartController.getSharedCartList(
      bucketMemberParameterLoadDataResult: _bucketMemberLoadDataResult
    );
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _sharedCartListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _cartCount = 0);
      Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
      Provider.of<ComponentNotifier>(context, listen: false).updateCart();
    });
    await _updateSharedCartData();
    Bucket bucket = _bucketLoadDataResult.resultIfSuccess!;
    _bucketId = bucket.id;
    List<CartListItemControllerState> newCartListItemControllerStateList = _cartListLoadDataResult.isSuccess ? _cartListLoadDataResult.resultIfSuccess!.map<CartListItemControllerState>(
      (cart) => VerticalCartListItemControllerState(
        isSelected: false,
        cart: cart,
        onChangeQuantity: (quantity) {
          setState(() {
            int newQuantity = quantity;
            if (newQuantity < 1) {
              newQuantity = 1;
            }
            cart.quantity = newQuantity;
            _updateCartInformation();
          });
        },
        onAddToWishlist: () => widget.sharedCartController.addToWishlist(cart.supportCart as SupportWishlist),
        onRemoveCart: () {
          widget.sharedCartController.removeCart(cart);
          _updateCartInformation();
        },
      )
    ).toList() : [];
    return SuccessLoadDataResult(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.all(4.w),
            paddingChildListItemControllerState: HostCartIndicatorListItemControllerState(
              hostCart: HostCart(username: bucket.bucketUsername)
            )
          ),
          SpacingListItemControllerState(),
          SharedCartContainerListItemControllerState(
            bucketLoadDataResult: () => _bucketLoadDataResult,
            bucketMemberLoadDataResult: () => _bucketMemberLoadDataResult,
            cartListLoadDataResult: () => _cartListLoadDataResult,
            userLoadDataResult: () => _userLoadDataResult,
            onAcceptOrDeclineSharedCart: (parameter) {
              int type = 0;
              String userId = "";
              String bucketId = "";
              if (parameter is AcceptSharedCartMemberParameter) {
                type = 1;
                userId = parameter.bucketMember.userId;
                bucketId = parameter.bucketMember.bucketId;
              } else if (parameter is DeclineSharedCartMemberParameter) {
                type = 0;
                userId = parameter.bucketMember.userId;
                bucketId = parameter.bucketMember.bucketId;
              }
              widget.sharedCartController.approveOrRejectRequestBucket(
                ApproveOrRejectRequestBucketParameter(
                  type: type,
                  userId: userId,
                  bucketId: bucketId
                )
              );
            },
            cartListItemControllerStateList: newCartListItemControllerStateList,
            onUpdateState: () => setState(() {}),
            onScrollToAdditionalItemsSection: () => _sharedCartScrollController.jumpTo(
              _sharedCartScrollController.position.maxScrollExtent
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
                _sharedCartListItemPagingController.errorFirstPageOuterProcess = CartEmptyError();
              }
            },
            onExpandBucketMemberRequest: (bucketMember) {
              setState(() => _expandedBucketMember = bucketMember);
            },
            onUnExpandBucketMemberRequest: () {
              setState(() => _expandedBucketMember = null);
            },
            onGetBucketMember: () => _expandedBucketMember,
            onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
            onRemoveSharedCartMember: (bucketMember) => widget.sharedCartController.removeMemberBucket(
              RemoveMemberBucketParameter(
                bucketId: bucketMember.id
              )
            ),
            cartContainerStateStorageListItemControllerState: DefaultCartContainerStateStorageListItemControllerState(),
            cartContainerActionListItemControllerState: _DefaultSharedCartContainerActionListItemControllerState(
              getAdditionalItemList: (additionalItemListParameter) => widget.sharedCartController.getAdditionalItem(additionalItemListParameter),
              addAdditionalItem: (addAdditionalItemParameter) => widget.sharedCartController.addAdditionalItem(addAdditionalItemParameter),
              changeAdditionalItem: (changeAdditionalItemParameter) => widget.sharedCartController.changeAdditionalItem(changeAdditionalItemParameter),
              removeAdditionalItem: (removeAdditionalItemParameter) => widget.sharedCartController.removeAdditionalItem(removeAdditionalItemParameter),
            ),
            cartContainerInterceptingActionListItemControllerState: _cartContainerInterceptingActionListItemControllerState
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.sharedCartController.setMainSharedCartDelegate(
      MainSharedCartDelegate(
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
        onShowCheckoutBucketRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowCheckoutBucketRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onCheckoutBucketRequestProcessSuccessCallback: (checkoutBucketResponse) async {
          ToastHelper.showToast("${"Success shared cart transaction".tr}.");
        },
        onShowApproveOrRejectRequestBucketProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowApproveOrRejectRequestBucketProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onApproveOrRejectRequestBucketProcessSuccessCallback: (approveOrRejectRequestBucketResponse) async {
          await _updateSharedCartData();
          setState(() {});
        },
        onShowRemoveMemberRequestBucketProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowRemoveMemberRequestBucketProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onRemoveMemberRequestBucketProcessSuccessCallback: (removeMemberBucketResponse) async {
          await _updateSharedCartData();
          setState(() {});
        },
        onShowTriggerBucketReadyProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowTriggerBucketReadyProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onTriggerBucketReadyProcessSuccessCallback: (removeMemberBucketResponse) async {
          ToastHelper.showToast("${"Success mark this cart to be checkout by host".tr}.");
          await _updateSharedCartData();
          setState(() {});
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
                pagingControllerState: _sharedCartListItemPagingControllerState,
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
                            if (_bucketId != null) {
                              widget.sharedCartController.createOrder(_bucketId!);
                            }
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

class _DefaultSharedCartContainerActionListItemControllerState extends CartContainerActionListItemControllerState {
  final Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter)? _getAdditionalItemList;
  final Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter)? _addAdditionalItem;
  final Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter)? _changeAdditionalItem;
  final Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter)? _removeAdditionalItem;

  _DefaultSharedCartContainerActionListItemControllerState({
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