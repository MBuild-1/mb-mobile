import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/double_ext.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../controller/shared_cart_controller.dart';
import '../../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/bucket/approveorrejectrequestbucket/approve_or_reject_request_bucket_parameter.dart';
import '../../domain/entity/bucket/bucket.dart';
import '../../domain/entity/bucket/bucket_member.dart';
import '../../domain/entity/bucket/removememberbucket/remove_member_bucket_parameter.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_summary.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/entity/payment/payment_method.dart';
import '../../domain/entity/summaryvalue/summary_value.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/add_additional_item_use_case.dart';
import '../../domain/usecase/add_to_cart_use_case.dart';
import '../../domain/usecase/add_wishlist_use_case.dart';
import '../../domain/usecase/approve_or_reject_request_bucket_use_case.dart';
import '../../domain/usecase/change_additional_item_use_case.dart';
import '../../domain/usecase/check_bucket_use_case.dart';
import '../../domain/usecase/checkout_bucket_use_case.dart';
import '../../domain/usecase/checkout_bucket_version_1_point_1_use_case.dart';
import '../../domain/usecase/create_bucket_use_case.dart';
import '../../domain/usecase/destroy_bucket_use_case.dart';
import '../../domain/usecase/get_additional_item_use_case.dart';
import '../../domain/usecase/get_cart_list_use_case.dart';
import '../../domain/usecase/get_current_selected_address_use_case.dart';
import '../../domain/usecase/get_shared_cart_summary_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/leave_bucket_use_case.dart';
import '../../domain/usecase/remove_additional_item_use_case.dart';
import '../../domain/usecase/remove_from_cart_use_case.dart';
import '../../domain/usecase/remove_member_bucket_use_case.dart';
import '../../domain/usecase/request_join_bucket_use_case.dart';
import '../../domain/usecase/show_bucket_by_id_use_case.dart';
import '../../domain/usecase/trigger_bucket_ready_use_case.dart';
import '../../misc/acceptordeclinesharedcartmemberparameter/accept_shared_cart_member_parameter.dart';
import '../../misc/acceptordeclinesharedcartmemberparameter/decline_shared_cart_member_parameter.dart';
import '../../misc/additionalloadingindicatorchecker/shared_cart_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shared_cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/cart_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
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
import '../widget/app_bar_icon_area.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modified_shimmer.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/tap_area.dart';
import 'address_page.dart';
import 'getx_page.dart';
import 'dart:math' as math;

import 'modaldialogpage/cart_summary_cart_modal_dialog_page.dart';
import 'payment_method_page.dart';

class SharedCartPage extends RestorableGetxPage<_SharedCartPageRestoration> {
  late final ControllerMember<SharedCartController> _sharedCartController = ControllerMember<SharedCartController>().addToControllerManager(controllerManager);
  final _StatefulSharedCartControllerMediatorWidgetDelegate _statefulSharedCartControllerMediatorWidgetDelegate = _StatefulSharedCartControllerMediatorWidgetDelegate();

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
        Injector.locator<CheckoutBucketVersion1Point1UseCase>(),
        Injector.locator<LeaveBucketUseCase>(),
        Injector.locator<DestroyBucketUseCase>(),
        Injector.locator<GetCurrentSelectedAddressUseCase>()
      ), tag: pageName
    );
  }

  @override
  _SharedCartPageRestoration createPageRestoration() => _SharedCartPageRestoration(
    onCompleteSelectAddress: (result) {
      if (result != null) {
        if (result) {
          if (_statefulSharedCartControllerMediatorWidgetDelegate.onRefreshAddress != null) {
            _statefulSharedCartControllerMediatorWidgetDelegate.onRefreshAddress!();
          }
        }
      }
    },
    onCompleteSelectPaymentMethod: (result) {
      if (result != null) {
        if (_statefulSharedCartControllerMediatorWidgetDelegate.onRefreshPaymentMethod != null) {
          _statefulSharedCartControllerMediatorWidgetDelegate.onRefreshPaymentMethod!(result.toPaymentMethodPageResponse().paymentMethod);
        }
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSharedCartControllerMediatorWidget(
      sharedCartController: _sharedCartController.controller,
      statefulSharedCartControllerMediatorWidgetDelegate: _statefulSharedCartControllerMediatorWidgetDelegate
    );
  }
}

class _SharedCartPageRestoration extends ExtendedMixableGetxPageRestoration with PaymentMethodPageRestorationMixin, AddressPageRestorationMixin {
  final RouteCompletionCallback<bool?>? _onCompleteSelectAddress;
  final RouteCompletionCallback<String?>? _onCompleteSelectPaymentMethod;

  _SharedCartPageRestoration({
    RouteCompletionCallback<bool?>? onCompleteSelectAddress,
    RouteCompletionCallback<String?>? onCompleteSelectPaymentMethod
  }) : _onCompleteSelectAddress = onCompleteSelectAddress,
      _onCompleteSelectPaymentMethod = onCompleteSelectPaymentMethod;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSelectAddress = _onCompleteSelectAddress;
    onCompleteSelectPaymentMethod = _onCompleteSelectPaymentMethod;
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

class _StatefulSharedCartControllerMediatorWidgetDelegate {
  void Function()? onRefreshAddress;
  void Function(PaymentMethod)? onRefreshPaymentMethod;
}

class _StatefulSharedCartControllerMediatorWidget extends StatefulWidget {
  final SharedCartController sharedCartController;
  final _StatefulSharedCartControllerMediatorWidgetDelegate statefulSharedCartControllerMediatorWidgetDelegate;

  const _StatefulSharedCartControllerMediatorWidget({
    required this.sharedCartController,
    required this.statefulSharedCartControllerMediatorWidgetDelegate
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
  LoadDataResult<User> _fetchedUserLoadDataResult = NoLoadDataResult<User>();
  LoadDataResult<User> _userLoadDataResult = NoLoadDataResult<User>();
  LoadDataResult<Address> _fetchedAddressLoadDataResult = NoLoadDataResult<Address>();
  LoadDataResult<Address> _addressLoadDataResult = NoLoadDataResult<Address>();
  LoadDataResult<Bucket> _fetchedBucketLoadDataResult = NoLoadDataResult<Bucket>();
  LoadDataResult<Bucket> _bucketLoadDataResult = NoLoadDataResult<Bucket>();
  LoadDataResult<BucketMember> _fetchedBucketMemberLoadDataResult = NoLoadDataResult<BucketMember>();
  LoadDataResult<BucketMember> _bucketMemberLoadDataResult = NoLoadDataResult<BucketMember>();
  LoadDataResult<List<Cart>> _fetchedCartListLoadDataResult = NoLoadDataResult<List<Cart>>();
  LoadDataResult<List<Cart>> _cartListLoadDataResult = NoLoadDataResult<List<Cart>>();
  LoadDataResult<CartSummary> _sharedCartSummaryLoadDataResult = NoLoadDataResult<CartSummary>();
  LoadDataResult<PaymentMethod> _selectedPaymentMethodLoadDataResult = NoLoadDataResult<PaymentMethod>();
  CartContainerInterceptingActionListItemControllerState _cartContainerInterceptingActionListItemControllerState = DefaultCartContainerInterceptingActionListItemControllerState();
  String? _bucketId;
  BucketMember? _expandedBucketMember;
  bool _hasExitFromBucket = false;
  final ValueNotifier<dynamic> _fillerErrorValueNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _sharedCartScrollController = ScrollController();
    _sharedCartListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.sharedCartController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<SharedCartAdditionalPagingResultParameterChecker>(),
      fillerErrorValueNotifier: _fillerErrorValueNotifier
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
    widget.statefulSharedCartControllerMediatorWidgetDelegate.onRefreshPaymentMethod = (paymentMethod) {
      _selectedPaymentMethodLoadDataResult = SuccessLoadDataResult<PaymentMethod>(value: paymentMethod);
      setState(() {});
      widget.sharedCartController.getSharedCartSummary(_bucketId!);
    };
    widget.statefulSharedCartControllerMediatorWidgetDelegate.onRefreshAddress = () async {
      _addressLoadDataResult = IsLoadingLoadDataResult<Address>();
      setState(() {});
      await _updateSharedCartDataAndState();
      _addressLoadDataResult = _fetchedAddressLoadDataResult;
      setState(() {});
    };
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
    int milliseconds = 0;

    _fetchedUserLoadDataResult = await widget.sharedCartController.getUser();
    if (_fetchedUserLoadDataResult.isFailed) {
      if (!_fetchedUserLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _fillerErrorValueNotifier.value = _fetchedUserLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    _fetchedAddressLoadDataResult = await widget.sharedCartController.getCurrentSelectedAddress();
    _fetchedBucketLoadDataResult = (await widget.sharedCartController.showBucketByLoggedUserId()).map<Bucket>(
      (value) => value.bucket
    );
    if (_fetchedBucketLoadDataResult.isFailed) {
      if (!_fetchedBucketLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _fillerErrorValueNotifier.value = _fetchedBucketLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    _fetchedBucketMemberLoadDataResult = await widget.sharedCartController.getBucketMember(
      bucketLoadDataResult: _fetchedBucketLoadDataResult,
      parameterUserLoadDataResult: _fetchedUserLoadDataResult,
    );
    if (_fetchedBucketMemberLoadDataResult.isFailed) {
      if (!_fetchedBucketMemberLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _fillerErrorValueNotifier.value = _fetchedBucketMemberLoadDataResult.resultIfFailed;
        }
        if (generateErrorWhileInitOrRefresh) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) => setError());
        } else {
          setError();
        }
        return;
      }
    }
    _fetchedCartListLoadDataResult = await widget.sharedCartController.getSharedCartList(
      bucketMemberParameterLoadDataResult: _fetchedBucketMemberLoadDataResult
    );
    if (_fetchedCartListLoadDataResult.isFailed) {
      if (!_fetchedCartListLoadDataResult.isFailedBecauseCancellation) {
        void setError() async {
          await Future.delayed(Duration(milliseconds: milliseconds));
          _fillerErrorValueNotifier.value = _fetchedCartListLoadDataResult.resultIfFailed;
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
      _fillerErrorValueNotifier.value = null;
    }
    // Address is not mandatory to be success (because address will only as appearance object)
    if (_fetchedUserLoadDataResult.isSuccess && _fetchedBucketLoadDataResult.isSuccess
      && _fetchedBucketMemberLoadDataResult.isSuccess
      && _fetchedCartListLoadDataResult.isSuccess) {
      _userLoadDataResult = _fetchedUserLoadDataResult;
      _addressLoadDataResult = _fetchedAddressLoadDataResult;
      _bucketLoadDataResult = _fetchedBucketLoadDataResult;
      _bucketMemberLoadDataResult = _fetchedBucketMemberLoadDataResult;
      _cartListLoadDataResult = _fetchedCartListLoadDataResult;
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _sharedCartListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() => _cartCount = 0);
      Provider.of<NotificationNotifier>(context, listen: false).loadCartLoadDataResult();
      Provider.of<ComponentNotifier>(context, listen: false).updateCart();
    });
    await _updateSharedCartData(generateErrorWhileInitOrRefresh: true);
    bool allSuccessLoadData = _userLoadDataResult.isSuccess
        && _bucketLoadDataResult.isSuccess
        && _bucketMemberLoadDataResult.isSuccess
        && _cartListLoadDataResult.isSuccess;
    if (!allSuccessLoadData) {
      return SuccessLoadDataResult(
        value: PagingDataResult<ListItemControllerState>(
          itemList: [
            NoContentListItemControllerState()
          ],
          page: 1,
          totalPage: 1,
          totalItem: 1
        ),
      );
    }
    Bucket bucket = _bucketLoadDataResult.resultIfSuccess!;
    _bucketId = bucket.id;
    try {
      await PusherHelper.unsubscribeSharedCartPusherChannel(
        pusherChannelsFlutter: _pusher,
        bucketId: _bucketId!
      );
    } catch (e) {
      // No action something
    }
    await PusherHelper.subscribeSharedCartPusherChannel(
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
            addressLoadDataResult: () => _addressLoadDataResult,
            userLoadDataResult: () => _userLoadDataResult,
            selectedPaymentMethodLoadDataResult: () => _selectedPaymentMethodLoadDataResult,
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
            onTriggerReady: (bucketMember) {
              widget.sharedCartController.triggerBucketReady();
            },
            cartContainerStateStorageListItemControllerState: DefaultCartContainerStateStorageListItemControllerState(),
            cartContainerActionListItemControllerState: _DefaultSharedCartContainerActionListItemControllerState(
              getAdditionalItemList: (additionalItemListParameter) => widget.sharedCartController.getAdditionalItem(additionalItemListParameter),
              addAdditionalItem: (addAdditionalItemParameter) => widget.sharedCartController.addAdditionalItem(addAdditionalItemParameter),
              changeAdditionalItem: (changeAdditionalItemParameter) => widget.sharedCartController.changeAdditionalItem(changeAdditionalItemParameter),
              removeAdditionalItem: (removeAdditionalItemParameter) => widget.sharedCartController.removeAdditionalItem(removeAdditionalItemParameter),
            ),
            cartContainerInterceptingActionListItemControllerState: _cartContainerInterceptingActionListItemControllerState,
            onSelectPaymentMethod: () {
              PaymentMethod? selectedPaymentMethod;
              if (_selectedPaymentMethodLoadDataResult.isSuccess) {
                selectedPaymentMethod = _selectedPaymentMethodLoadDataResult.resultIfSuccess;
              }
              PageRestorationHelper.toPaymentMethodPage(context, selectedPaymentMethod?.settlingId);
            },
            onRemovePaymentMethod: () {
              setState(() => _selectedPaymentMethodLoadDataResult = NoLoadDataResult<PaymentMethod>());
              widget.sharedCartController.getSharedCartSummary(_bucketId!);
            },
            errorProvider: () => Injector.locator<ErrorProvider>(),
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
        onGetSettlingId: () => _selectedPaymentMethodLoadDataResult.resultIfSuccess?.settlingId,
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
        onCheckoutBucketVersion1Point1RequestProcessSuccessCallback: (checkoutBucketVersion1Point1Response) async {
          NavigationHelper.navigationAfterPurchaseProcessWithCombinedOrderIdParameter(context, checkoutBucketVersion1Point1Response.combinedOrderId);
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
        onSharedCartInfoSuccessCallback: (showBucketByIdResponse) async => Share.share(
          MultiLanguageString({
            Constant.textEnUsLanguageKey: "Bucket username: ${showBucketByIdResponse.bucket.bucketUsername}\r\nBucket password: ${showBucketByIdResponse.bucket.bucketPassword}",
            Constant.textInIdLanguageKey: "Username keranjang: ${showBucketByIdResponse.bucket.bucketUsername}\r\nKata sandi keranjang: ${showBucketByIdResponse.bucket.bucketPassword}"
          }).toEmptyStringNonNull
        ),
        onSharedCartInfoFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onSharedCartInfoLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onLeaveBucketProcessSuccessCallback: (leaveBucketProcess) async {
          ToastHelper.showToast(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "You have left this bucket.",
              Constant.textInIdLanguageKey: "Anda telah meninggalkan bucket ini."
            }).toEmptyStringNonNull
          );
          _hasExitFromBucket = true;
          Get.back();
        },
        onLeaveBucketProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onLeaveBucketProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onDestroyBucketProcessSuccessCallback: (destroyBucketSuccess) async {
          ToastHelper.showToast(
            MultiLanguageString({
              Constant.textEnUsLanguageKey: "You have destroy this bucket.",
              Constant.textInIdLanguageKey: "Anda telah menghapus bucket ini."
            }).toEmptyStringNonNull
          );
          _hasExitFromBucket = true;
          Get.back();
        },
        onDestroyBucketProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onDestroyBucketProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
      )
    );
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptorWithAdditionalParameter: (context, title, titleInterceptorAdditionalParameter) {
          Size preferredSize = titleInterceptorAdditionalParameter.appBarPreferredSize;
          bool showLeaveCartIcon = false;
          bool showDestroyCartIcon = false;
          if (_userLoadDataResult.isSuccess && _bucketLoadDataResult.isSuccess) {
            Bucket bucket = _bucketLoadDataResult.resultIfSuccess!;
            User user = _userLoadDataResult.resultIfSuccess!;
            Iterable<BucketMember> bucketMemberIterable = bucket.bucketMemberList.where(
              (bucketMember) => bucketMember.userId == user.id && bucketMember.hostBucket == 1
            );
            if (bucketMemberIterable.isNotEmpty) {
              showDestroyCartIcon = true;
            } else {
              showLeaveCartIcon = true;
            }
          }
          return Row(
            children: [
              Expanded(
                child: Text("Shared Cart".tr)
              ),
              Tooltip(
                message: "Share",
                child: AppBarIconArea(
                  onTap: widget.sharedCartController.shareCartInfo,
                  height: preferredSize.height,
                  child: Icon(
                    Icons.share,
                    color: Theme.of(context).colorScheme.primary,
                    size: 30
                  )
                ),
              ),
              if (showLeaveCartIcon) ...[
                Tooltip(
                  message: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Leave Bucket",
                    Constant.textInIdLanguageKey: "Tinggalkan Bucket"
                  }).toEmptyStringNonNull,
                  child: AppBarIconArea(
                    onTap: () => DialogHelper.showLeaveBucketPrompt(context, widget.sharedCartController.leaveBucket),
                    height: preferredSize.height,
                    child: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30
                    )
                  ),
                )
              ],
              if (showDestroyCartIcon) ...[
                Tooltip(
                  message: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Destroy Bucket",
                    Constant.textInIdLanguageKey: "Hapus Bucket"
                  }).toEmptyStringNonNull,
                  child: AppBarIconArea(
                    onTap: () => DialogHelper.showDestroyBucketPrompt(context, widget.sharedCartController.destroyBucket),
                    height: preferredSize.height,
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30
                    )
                  ),
                )
              ]
            ],
          );
        },
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
                pullToRefresh: false,
                onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
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
                                                text = (finalCartSummaryValue.value as String).parseDoubleWithAdditionalChecking().toRupiah(withFreeTextIfZero: false);
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
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Transform.rotate(
                                                    angle: math.pi / 2,
                                                    child: SizedBox(
                                                      child: ModifiedSvgPicture.asset(
                                                        Constant.vectorArrow,
                                                        height: 15,
                                                      ),
                                                    )
                                                  ),
                                                  const SizedBox(height: 4)
                                                ],
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
                        Builder(
                          builder: (context) {
                            if (_bucketMemberLoadDataResult.isSuccess) {
                              BucketMember loggedUserBucketMember = _bucketMemberLoadDataResult.resultIfSuccess!;
                              if (loggedUserBucketMember.hostBucket == 1) {
                                void Function()? onPressed;
                                if (_selectedCartCount > 0 && _selectedPaymentMethodLoadDataResult.isSuccess && _bucketId != null) {
                                  onPressed = () {
                                    if (_bucketId != null) {
                                      widget.sharedCartController.createOrderVersion1Point1(_bucketId!);
                                    }
                                  };
                                }
                                return SizedOutlineGradientButton(
                                  onPressed: onPressed,
                                  width: 120,
                                  text: "${"Checkout".tr} ($_selectedCartCount)",
                                  outlineGradientButtonType: OutlineGradientButtonType.solid,
                                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                                );
                              }
                            }
                            return const SizedBox();
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

  dynamic _onEvent(dynamic event) {
    _updateSharedCartDataAndState();
  }

  Future<void> _updateSharedCartDataAndState() async {
    await _updateSharedCartData();
    setState(() {});
    widget.sharedCartController.getSharedCartSummary(_bucketId!);
    if (!_hasExitFromBucket) {
      if (_fetchedBucketLoadDataResult.isFailed) {
        dynamic e = _fetchedBucketLoadDataResult.resultIfFailed;
        if (e is DioError) {
          dynamic data = e.response?.data;
          if (data is Map<String, dynamic>) {
            String message = (data["meta"]["message"] as String).toLowerCase();
            if (message.contains("you need join or create bucket")) {
              _hasExitFromBucket = true;
              Get.back();
              return;
            }
          }
        }
      }
    }
  }

  @override
  void dispose() {
    PusherHelper.unsubscribeSharedCartPusherChannel(
      pusherChannelsFlutter: _pusher,
      bucketId: _bucketId!
    );
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