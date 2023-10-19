import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
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
import '../../domain/entity/cart/cart_summary.dart';
import '../../domain/entity/cart/host_cart.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/summaryvalue/summary_value.dart';
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
import '../../domain/usecase/get_shared_cart_summary_use_case.dart';
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
import '../../misc/constant.dart';
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
import '../../misc/navigation_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/toast_helper.dart';
import '../notifier/component_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_shimmer.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/tap_area.dart';
import 'delivery_page.dart';
import 'getx_page.dart';
import 'dart:math' as math;

import 'modaldialogpage/cart_summary_cart_modal_dialog_page.dart';

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
        Injector.locator<GetSharedCartSummaryUseCase>(),
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
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();
  int _cartCount = 0;
  late int _selectedCartCount = 0;
  late double _selectedCartShoppingTotal = 0;
  List<AdditionalItem> _additionalItemList = [];
  List<Cart> _selectedCartList = [];
  LoadDataResult<User> _userLoadDataResult = NoLoadDataResult<User>();
  LoadDataResult<Bucket> _bucketLoadDataResult = NoLoadDataResult<Bucket>();
  LoadDataResult<BucketMember> _bucketMemberLoadDataResult = NoLoadDataResult<BucketMember>();
  LoadDataResult<List<Cart>> _cartListLoadDataResult = NoLoadDataResult<List<Cart>>();
  LoadDataResult<CartSummary> _sharedCartSummaryLoadDataResult = NoLoadDataResult<CartSummary>();
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

  Future<void> _updateSharedCartData({bool generateErrorWhileInitOrRefresh = false}) async {
    int milliseconds = 10;

    _userLoadDataResult = await widget.sharedCartController.getUser();
    if (_userLoadDataResult.isFailed) {
      if (!_userLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _sharedCartListItemPagingController.errorFirstPageOuterProcess = _userLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    _bucketLoadDataResult = (await widget.sharedCartController.showBucketByLoggedUserId()).map<Bucket>(
      (value) => value.bucket
    );
    if (_bucketLoadDataResult.isFailed) {
      if (!_bucketLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _sharedCartListItemPagingController.errorFirstPageOuterProcess = _bucketLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    _bucketMemberLoadDataResult = await widget.sharedCartController.getBucketMember(
      bucketLoadDataResult: _bucketLoadDataResult,
      parameterUserLoadDataResult: _userLoadDataResult,
    );
    if (_bucketMemberLoadDataResult.isFailed) {
      if (!_bucketMemberLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _sharedCartListItemPagingController.errorFirstPageOuterProcess = _bucketMemberLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    _cartListLoadDataResult = await widget.sharedCartController.getSharedCartList(
      bucketMemberParameterLoadDataResult: _bucketMemberLoadDataResult
    );
    if (_cartListLoadDataResult.isFailed) {
      if (!_cartListLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _sharedCartListItemPagingController.errorFirstPageOuterProcess = _cartListLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    if (!generateErrorWhileInitOrRefresh) {
      _sharedCartListItemPagingController.errorFirstPageOuterProcess = null;
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _sharedCartListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _cartCount = 0);
      Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
      Provider.of<ComponentNotifier>(context, listen: false).updateCart();
    });
    await _updateSharedCartData(generateErrorWhileInitOrRefresh: true);
    Bucket bucket = _bucketLoadDataResult.resultIfSuccess!;
    _bucketId = bucket.id;
    try {
      await _pusher.disconnect();
    } catch (e) {
      // No action something
    }
    await PusherHelper.connectSharedCartPusherChannel(
      pusherChannelsFlutter: _pusher,
      onEvent: _onEvent,
      bucketId: _bucketId!,
    );
    return SuccessLoadDataResult(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
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
            cartListItemControllerStateList: [],
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
              widget.sharedCartController.getSharedCartSummary(_bucketId!);
            },
            onCartChange: () {
              setState(() => _updateCartInformation());
              widget.sharedCartController.getSharedCartSummary(_bucketId!);
            },
            onExpandBucketMemberRequest: (bucketMember) {
              setState(() => _expandedBucketMember = bucketMember);
            },
            onUnExpandBucketMemberRequest: () {
              setState(() => _expandedBucketMember = null);
            },
            onGetBucketMember: () => _expandedBucketMember,
            onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
            onRemoveSharedCartMember: (bucketMember) {
              widget.sharedCartController.removeMemberBucket(
                RemoveMemberBucketParameter(
                  userId: bucketMember.userId
                )
              );
            },
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
          NavigationHelper.navigationAfterPurchaseProcess(context, checkoutBucketResponse.order);
        },
        onShowApproveOrRejectRequestBucketProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowApproveOrRejectRequestBucketProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onApproveOrRejectRequestBucketProcessSuccessCallback: (approveOrRejectRequestBucketResponse) async {
          _updateSharedCartDataAndState();
        },
        onShowRemoveMemberRequestBucketProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowRemoveMemberRequestBucketProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onRemoveMemberRequestBucketProcessSuccessCallback: (removeMemberBucketResponse) async {
          _updateSharedCartDataAndState();
        },
        onShowTriggerBucketReadyProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowTriggerBucketReadyProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onTriggerBucketReadyProcessSuccessCallback: (removeMemberBucketResponse) async {
          ToastHelper.showToast("${"Success mark this cart to be checkout by host".tr}.");
          _updateSharedCartDataAndState();
        },
        onShowSharedCartSummaryProcessCallback: (cartSummaryLoadDataResult) async {
          setState(() {
            _sharedCartSummaryLoadDataResult = cartSummaryLoadDataResult;
          });
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
                        Expanded(
                          child: LoadDataResultImplementerDirectly<CartSummary>(
                            loadDataResult: _sharedCartSummaryLoadDataResult,
                            errorProvider: Injector.locator<ErrorProvider>(),
                            onImplementLoadDataResultDirectly: (cartSummaryLoadDataResult, errorProviderOutput) {
                              bool hasLoadingShimmer = cartSummaryLoadDataResult.isNotLoading || cartSummaryLoadDataResult.isLoading;
                              Widget result = Wrap(
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Shopping Total".tr,
                                        style: TextStyle(
                                          backgroundColor: hasLoadingShimmer ? Colors.grey : null
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Builder(
                                        builder: (context) {
                                          String text = "No Loading";
                                          if (cartSummaryLoadDataResult.isLoading) {
                                            text = "Is Loading";
                                          } else if (cartSummaryLoadDataResult.isSuccess) {
                                            SummaryValue finalCartSummaryValue = cartSummaryLoadDataResult.resultIfSuccess!.finalSummaryValue.first;
                                            if (finalCartSummaryValue.type == "currency") {
                                              if (finalCartSummaryValue.value is num) {
                                                text = (finalCartSummaryValue.value as num).toRupiah(withFreeTextIfZero: false);
                                              } else {
                                                text = double.parse(finalCartSummaryValue.value as String).toRupiah(withFreeTextIfZero: false);
                                              }
                                            } else {
                                              text = finalCartSummaryValue.value;
                                            }
                                          } else if (cartSummaryLoadDataResult.isFailed) {
                                            text = errorProviderOutput.onGetErrorProviderResult(
                                              cartSummaryLoadDataResult.resultIfFailed!
                                            ).toErrorProviderResultNonNull().message;
                                          }
                                          return Text(
                                            text,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              backgroundColor: hasLoadingShimmer ? Colors.grey : null
                                            )
                                          );
                                        }
                                      ),
                                    ]
                                  ),
                                  if (cartSummaryLoadDataResult.isSuccess) ...[
                                    TapArea(
                                      onTap: cartSummaryLoadDataResult.isSuccess ? () => DialogHelper.showModalBottomDialogPage<bool, CartSummary>(
                                        context: context,
                                        modalDialogPageBuilder: (context, parameter) => CartSummaryCartModalDialogPage(
                                          cartSummary: parameter!
                                        ),
                                        parameter: cartSummaryLoadDataResult.resultIfSuccess!
                                      ) : null,
                                      child: SizedBox(
                                        width: 40,
                                        height: 30,
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Transform.rotate(
                                                angle: math.pi / 2,
                                                child: SizedBox(
                                                  child: ModifiedSvgPicture.asset(
                                                    Constant.vectorArrow,
                                                    height: 15,
                                                  ),
                                                )
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ]
                                ]
                              );
                              return hasLoadingShimmer ? ModifiedShimmer.fromColors(
                                child: result
                              ) : result;
                            }
                          ),
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         Text("Shopping Total".tr),
                        //         const SizedBox(height: 4),
                        //         Text(_selectedCartShoppingTotal.toRupiah(withFreeTextIfZero: false), style: const TextStyle(
                        //           fontSize: 20,
                        //           fontWeight: FontWeight.bold
                        //         )),
                        //       ]
                        //     ),
                        //   ],
                        // ),
                        // const Expanded(
                        //   child: SizedBox()
                        // ),
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

  void _onEvent(PusherEvent event) {
    _updateSharedCartDataAndState();
  }

  void _updateSharedCartDataAndState() async {
    await _updateSharedCartData();
    setState(() {});
  }

  @override
  void dispose() {
    _pusher.disconnect();
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