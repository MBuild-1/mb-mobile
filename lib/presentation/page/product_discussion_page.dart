import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../controller/product_discussion_controller.dart';
import '../../domain/entity/chat/user_message_response_wrapper.dart';
import '../../domain/entity/discussion/support_discussion.dart';
import '../../domain/entity/discussion/support_discussion_parameter.dart';
import '../../domain/entity/product/product_detail.dart';
import '../../domain/entity/product/product_in_discussion.dart';
import '../../domain/entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_based_user_parameter.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_user.dart';
import '../../domain/entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/create_product_discussion_use_case.dart';
import '../../domain/usecase/get_product_discussion_based_user_use_case.dart';
import '../../domain/usecase/get_product_discussion_use_case.dart';
import '../../domain/usecase/get_support_discussion_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/reply_product_discussion_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/product_discussion_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productdiscussionlistitemcontrollerstate/product_discussion_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/product_discussion_container_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/navigation_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/routeargument/product_discussion_route_argument.dart';
import '../../misc/string_util.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/tap_area.dart';
import 'getx_page.dart';
import 'product_detail_page.dart';

class ProductDiscussionPage extends RestorableGetxPage<_ProductDiscussionPageRestoration> {
  late final ControllerMember<ProductDiscussionController> _productDiscussionController = ControllerMember<ProductDiscussionController>().addToControllerManager(controllerManager);

  final ProductDiscussionPageParameter productDiscussionPageParameter;

  ProductDiscussionPage({
    Key? key,
    required this.productDiscussionPageParameter
  }) : super(
    key: key,
    pageRestorationId: () => "product-discussion-page"
  );

  @override
  void onSetController() {
    _productDiscussionController.controller = GetExtended.put<ProductDiscussionController>(
      ProductDiscussionController(
        controllerManager,
        Injector.locator<GetProductDiscussionUseCase>(),
        Injector.locator<GetProductDiscussionBasedUserUseCase>(),
        Injector.locator<GetSupportDiscussionUseCase>(),
        Injector.locator<CreateProductDiscussionUseCase>(),
        Injector.locator<ReplyProductDiscussionUseCase>(),
        Injector.locator<GetUserUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _ProductDiscussionPageRestoration createPageRestoration() => _ProductDiscussionPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductDiscussionControllerMediatorWidget(
      productDiscussionController: _productDiscussionController.controller,
      productDiscussionPageParameter: productDiscussionPageParameter,
      onGetPageName: () => pageName,
    );
  }
}

class _ProductDiscussionPageRestoration extends ExtendedMixableGetxPageRestoration with ProductDiscussionPageRestorationMixin, ProductDetailPageRestorationMixin {
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

class ProductDiscussionPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ProductDiscussionPageParameter productDiscussionPageParameter;

  ProductDiscussionPageGetPageBuilderAssistant({
    required this.productDiscussionPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductDiscussionPage(productDiscussionPageParameter: productDiscussionPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductDiscussionPage(productDiscussionPageParameter: productDiscussionPageParameter)));
}

mixin ProductDiscussionPageRestorationMixin on MixableGetxPageRestoration {
  late ProductDiscussionPageRestorableRouteFuture productDiscussionPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productDiscussionPageRestorableRouteFuture = ProductDiscussionPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-discussion-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productDiscussionPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productDiscussionPageRestorableRouteFuture.dispose();
  }
}

class ProductDiscussionPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductDiscussionPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw Exception("Arguments must be a string");
    }
    ProductDiscussionPageParameter productDiscussionPageParameter = arguments.toProductDiscussionPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ProductDiscussionPageGetPageBuilderAssistant(productDiscussionPageParameter: productDiscussionPageParameter)
      ),
      arguments: ProductDiscussionRouteArgument(
        isBasedUser: productDiscussionPageParameter.isBasedUser
      )
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

class _StatefulProductDiscussionControllerMediatorWidget extends StatefulWidget {
  final ProductDiscussionController productDiscussionController;
  final ProductDiscussionPageParameter productDiscussionPageParameter;
  final String Function() onGetPageName;

  const _StatefulProductDiscussionControllerMediatorWidget({
    required this.productDiscussionController,
    required this.productDiscussionPageParameter,
    required this.onGetPageName
  });

  @override
  State<_StatefulProductDiscussionControllerMediatorWidget> createState() => _StatefulProductDiscussionControllerMediatorWidgetState();
}

class _StatefulProductDiscussionControllerMediatorWidgetState extends State<_StatefulProductDiscussionControllerMediatorWidget> {
  late final ScrollController _productDiscussionScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _productDiscussionListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productDiscussionListItemPagingControllerState;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  LoadDataResult<SupportDiscussion> _supportDiscussionLoadDataResult = NoLoadDataResult<SupportDiscussion>();
  Map<String, LoadDataResult<SupportDiscussion>> _supportDiscussionForEachDiscussionIdLoadDataResult = {};
  final TextEditingController _productDiscussionTextEditingController = TextEditingController();
  final FocusNode _productDiscussionTextFocusNode = FocusNode();
  User? _loggedUser;
  final DefaultProductDiscussionContainerInterceptingActionListItemControllerState _defaultProductDiscussionContainerInterceptingActionListItemControllerState = DefaultProductDiscussionContainerInterceptingActionListItemControllerState();
  ProductDiscussionListItemValue? _productDiscussionListItemValue;
  ProductDiscussionDialog? _selectedReplyProductDiscussionDialog;
  final ValueNotifier<dynamic> _fillerErrorValueNotifier = ValueNotifier(null);

  void _scrollToDown() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productDiscussionScrollController.jumpTo(
        _productDiscussionScrollController.position.maxScrollExtent
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _productDiscussionScrollController = ScrollController();
    _productDiscussionListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productDiscussionController.apiRequestManager,
      fillerErrorValueNotifier: _fillerErrorValueNotifier
    );
    _productDiscussionListItemPagingControllerState = PagingControllerState(
      scrollController: _productDiscussionScrollController,
      pagingController: _productDiscussionListItemPagingController,
      isPagingControllerExist: false
    );
    _productDiscussionListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _productDiscussionListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productDiscussionListItemPagingControllerState.isPagingControllerExist = true;
  }

  String get _productOrBundleId {
    return widget.productDiscussionPageParameter.productId ?? widget.productDiscussionPageParameter.bundleId ?? "";
  }

  void _loadSupportDiscussion() async {
    _supportDiscussionLoadDataResult = IsLoadingLoadDataResult<SupportDiscussion>();
    setState(() {});
    _supportDiscussionLoadDataResult = await widget.productDiscussionController.getSupportDiscussion(
      SupportDiscussionParameter(
        productId: widget.productDiscussionPageParameter.productId,
        bundleId: widget.productDiscussionPageParameter.bundleId
      )
    );
    setState(() {});
  }

  void _loadSupportDiscussionForEachDiscussionId({
    required String? productId,
    required String? bundleId,
    required String discussionId,
  }) async {
    _supportDiscussionForEachDiscussionIdLoadDataResult[discussionId] = IsLoadingLoadDataResult<SupportDiscussion>();
    setState(() {});
    _supportDiscussionForEachDiscussionIdLoadDataResult[discussionId] = await widget.productDiscussionController.getSupportDiscussionForEachDiscussionId(
      SupportDiscussionParameter(
        productId: productId,
        bundleId: bundleId
      )
    );
    setState(() {});
  }

  Future<UserMessageResponseWrapper<ProductDiscussion>> getProductDiscussion() async {
    LoadDataResult<User> getUserLoadDataResult = await widget.productDiscussionController.getUser(
      GetUserParameter()
    ).map<User>((value) => value.user);
    if (getUserLoadDataResult.isFailed) {
      Future<LoadDataResult<ProductDiscussion>> returnUserLoadFailed() async {
        return getUserLoadDataResult.map<ProductDiscussion>(
          // This is for required argument purposes only, not will be used for further process
          (_) => ProductDiscussion(
            productDiscussionDialogList: []
          )
        );
      }
      return UserMessageResponseWrapper(
        userLoadDataResult: getUserLoadDataResult,
        valueLoadDataResult: await returnUserLoadFailed()
      );
    }
    return UserMessageResponseWrapper(
      userLoadDataResult: getUserLoadDataResult,
      valueLoadDataResult: await () async {
        if (widget.productDiscussionPageParameter.isBasedUser) {
          return await widget.productDiscussionController.getProductDiscussionBasedUser(
            ProductDiscussionBasedUserParameter()
          );
        } else {
          return await widget.productDiscussionController.getProductDiscussion(
            ProductDiscussionParameter(productId: _productOrBundleId)
          );
        }
      }()
    );
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productDiscussionListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fillerErrorValueNotifier.value = null;
    });
    UserMessageResponseWrapper<ProductDiscussion> productDiscussionLoadDataResult = await getProductDiscussion();
    User user = productDiscussionLoadDataResult.userLoadDataResult.resultIfSuccess!;
    _loggedUser = user;
    if (!widget.productDiscussionPageParameter.isBasedUser) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _loadSupportDiscussion();
      });
    } else {
      if (productDiscussionLoadDataResult.valueLoadDataResult.isSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ProductDiscussion productDiscussion = productDiscussionLoadDataResult.valueLoadDataResult.resultIfSuccess!;
          for (ProductDiscussionDialog productDiscussionDialog in productDiscussion.productDiscussionDialogList) {
            _loadSupportDiscussionForEachDiscussionId(
              productId: productDiscussionDialog.productId,
              bundleId: productDiscussionDialog.bundleId,
              discussionId: productDiscussionDialog.id
            );
          }
        });
      }
    }
    if (productDiscussionLoadDataResult.valueLoadDataResult.isSuccess) {
      Future<void> subscribeDiscussionChannel() async {
        try {
          await PusherHelper.unsubscribeDiscussionPusherChannel(
            pusherChannelsFlutter: _pusher,
            discussionPusherChannelType: DiscussionPusherChannelType.discussion,
            productDiscussionId: widget.productDiscussionPageParameter.productId.toEmptyStringNonNull
          );
        } catch (e) {
          // No action something
        }
        await PusherHelper.subscribeDiscussionPusherChannel(
          pusherChannelsFlutter: _pusher,
          onEvent: _onEvent,
          discussionPusherChannelType: DiscussionPusherChannelType.discussion,
          productDiscussionId: widget.productDiscussionPageParameter.productId.toEmptyStringNonNull,
        );
      }
      if (_productDiscussionRouteCount == 1) {
        if (!widget.productDiscussionPageParameter.isBasedUser) {
          await subscribeDiscussionChannel();
        }
      } else {
        if (_isPreviousRouteHasIsBasedUserTrueValue) {
          await subscribeDiscussionChannel();
        }
      }
      MainRouteObserver.onRefreshProductDiscussion[getRouteMapKey(widget.onGetPageName())] = _refreshProductDiscussion;
      ProductDiscussion productDiscussion = productDiscussionLoadDataResult.valueLoadDataResult.resultIfSuccess!;
      _productDiscussionListItemValue = ProductDiscussionListItemValue(
        productDiscussionDetailListItemValue: productDiscussion.toProductDiscussionDetailListItemValue(),
        isExpanded: true
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _checkDiscussionEmpty();
      });
    }
    return productDiscussionLoadDataResult.valueLoadDataResult.map<PagingResult<ListItemControllerState>>((productDiscussion) {
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          ProductDiscussionContainerListItemControllerState(
            productDiscussionListItemValue: _productDiscussionListItemValue!,
            onGetSupportDiscussion: () => _supportDiscussionLoadDataResult,
            onGetSupportDiscussionBasedDiscussionId: () => _supportDiscussionForEachDiscussionIdLoadDataResult,
            onGetIsBasedUser: () => widget.productDiscussionPageParameter.isBasedUser,
            onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
            onUpdateState: () => setState(() {}),
            onReplyProductDiscussionDialog: (productDiscussionDialog) {
              setState(() => _selectedReplyProductDiscussionDialog = productDiscussionDialog);
            },
            onGotoReplyProductDiscussionPage: (productDiscussionDialog) {
              if (widget.productDiscussionPageParameter.isBasedUser) {
                PageRestorationHelper.toProductDiscussionPage(
                  context, ProductDiscussionPageParameter(
                    productId: productDiscussionDialog.productId,
                    bundleId: null,
                    discussionProductId: null
                  )
                );
              } else {
                PageRestorationHelper.toProductDiscussionPage(
                  context, ProductDiscussionPageParameter(
                    productId: widget.productDiscussionPageParameter.productId,
                    bundleId: null,
                    discussionProductId: productDiscussionDialog.id
                  )
                );
              }
            },
            onGetDiscussionProductId: () => widget.productDiscussionPageParameter.discussionProductId,
            productDiscussionContainerInterceptingActionListItemControllerState: _defaultProductDiscussionContainerInterceptingActionListItemControllerState,
            onTapProductDiscussionHeader: (supportDiscussionLoadDataResult) {
              if (supportDiscussionLoadDataResult.isSuccess) {
                SupportDiscussion supportDiscussion = supportDiscussionLoadDataResult.resultIfSuccess!;
                if (supportDiscussion is ProductDetail) {
                  NavigationHelper.navigationToProductDetailFromProductDiscussion(
                    context, DefaultProductDetailPageParameter(
                      productId: supportDiscussion.productId,
                      productEntryId: ""
                    )
                  );
                }
              }
            }
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: productDiscussion.productDiscussionDialogList.length
      );
    });
  }

  Future<void> _refreshProductDiscussion() async {
    var productDiscussionResponse = await getProductDiscussion();
    if (productDiscussionResponse.valueLoadDataResult.isSuccess) {
      _productDiscussionListItemValue = ProductDiscussionListItemValue(
        productDiscussionDetailListItemValue: productDiscussionResponse.valueLoadDataResult.resultIfSuccess!.toProductDiscussionDetailListItemValue(),
        isExpanded: true
      );
      if (_defaultProductDiscussionContainerInterceptingActionListItemControllerState.onUpdateProductDiscussionListItemValue != null) {
        _defaultProductDiscussionContainerInterceptingActionListItemControllerState.onUpdateProductDiscussionListItemValue!(
          _productDiscussionListItemValue!
        );
      }
    }
    _checkDiscussionEmpty();
  }

  dynamic _getEmptyError() {
    return FailedLoadDataResult.throwException(() {
      throw ErrorHelper.generateMultiLanguageDioError(
        MultiLanguageMessageError(
          title: MultiLanguageString({
            Constant.textEnUsLanguageKey: "Discussion Is Empty",
            Constant.textInIdLanguageKey: "Diskusi Kosong",
          }),
          message: MultiLanguageString({
            Constant.textEnUsLanguageKey: "In the future, discussion will appear here.",
            Constant.textInIdLanguageKey: "Kedepannya, diskusi bakal muncul disini."
          }),
        )
      );
    })!.e;
  }

  dynamic _onEvent(dynamic event) {
    try {
      var functionList = MainRouteObserver.onRefreshProductDiscussion.values.toList();
      for (int i = functionList.length - 1; i >= 0; i--) {
        if (functionList[i] != null) {
          functionList[i]!();
        }
      }
    } catch (e) {
      // No error exception
    }
  }

  @override
  void dispose() {
    MainRouteObserver.onRefreshProductDiscussion.remove(getRouteMapKey(widget.onGetPageName()));
    _fillerErrorValueNotifier.dispose();
    _productDiscussionTextFocusNode.dispose();
    _productDiscussionTextEditingController.dispose();
    super.dispose();
  }

  int get _productDiscussionRouteCount {
    int productDiscussionRouteCount = 0;
    for (var routeWrapper in MainRouteObserver.routeMap.values) {
      var routeArguments = routeWrapper?.route?.settings.arguments;
      if (routeArguments is ProductDiscussionRouteArgument) {
        productDiscussionRouteCount += 1;
      }
    }
    return productDiscussionRouteCount;
  }

  bool get _isPreviousRouteHasIsBasedUserTrueValue {
    if (MainRouteObserver.routeMap.values.isNotEmpty) {
      int maxIndex = MainRouteObserver.routeMap.values.length - 1;
      int previousMaxIndex = maxIndex - 1;
      if (previousMaxIndex < 0) {
        return false;
      }
      RouteWrapper? previousLastRouteWrapper = MainRouteObserver.routeMap.values.toList()[previousMaxIndex];
      if (previousLastRouteWrapper != null) {
        dynamic argument = previousLastRouteWrapper.route?.settings.arguments;
        if (argument is ProductDiscussionRouteArgument) {
          return argument.isBasedUser;
        }
      }
    }
    return false;
  }

  bool get _isRouteHasIsBasedUserTrueValue {
    if (MainRouteObserver.routeMap.values.isNotEmpty) {
      int maxIndex = MainRouteObserver.routeMap.values.length - 1;
      if (maxIndex < 0) {
        return false;
      }
      RouteWrapper? previousLastRouteWrapper = MainRouteObserver.routeMap.values.toList()[maxIndex];
      if (previousLastRouteWrapper != null) {
        dynamic argument = previousLastRouteWrapper.route?.settings.arguments;
        if (argument is ProductDiscussionRouteArgument) {
          return argument.isBasedUser;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool hasUnsubscribe = false;
        if (_isPreviousRouteHasIsBasedUserTrueValue) {
          hasUnsubscribe = true;
        } else {
          if (_productDiscussionRouteCount == 1) {
            if (!_isRouteHasIsBasedUserTrueValue) {
              hasUnsubscribe = true;
            }
          }
        }
        if (hasUnsubscribe) {
          PusherHelper.unsubscribeDiscussionPusherChannel(
            pusherChannelsFlutter: _pusher,
            discussionPusherChannelType: DiscussionPusherChannelType.discussion,
            productDiscussionId: widget.productDiscussionPageParameter.productId.toEmptyStringNonNull
          );
        }
        Get.back();
        return false;
      },
      child: ModifiedScaffold(
        appBar: ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text(widget.productDiscussionPageParameter.discussionProductId == null ? "Product Discussion".tr : "Reply Product Discussion".tr),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: _productDiscussionListItemPagingControllerState,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true,
                  onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
                ),
              ),
              if (!widget.productDiscussionPageParameter.isBasedUser) ...[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedReplyProductDiscussionDialog != null) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                          decoration: BoxDecoration(
                            color: Constant.colorGrey5
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      MultiLanguageString({
                                        Constant.textEnUsLanguageKey: "Reply ${_selectedReplyProductDiscussionDialog!.productDiscussionUser.name}",
                                        Constant.textInIdLanguageKey: "Membalas ${_selectedReplyProductDiscussionDialog!.productDiscussionUser.name}"
                                      }).toEmptyStringNonNull,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    const SizedBox(height: 5.0),
                                    Text(
                                      _selectedReplyProductDiscussionDialog!.discussion
                                    ),
                                  ],
                                ),
                              ),
                              TapArea(
                                onTap: () => setState(() => _selectedReplyProductDiscussionDialog = null),
                                child: const Icon(
                                  Icons.close,
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 7.0),
                      ],
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Constant.colorGrey4
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                focusNode: _productDiscussionTextFocusNode,
                                controller: _productDiscussionTextEditingController,
                                decoration: InputDecoration.collapsed(
                                  hintText: widget.productDiscussionPageParameter.discussionProductId != null ? "Type Reply Product Discussion".tr : "Type Product Discussion".tr,
                                ),
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                minLines: 1,
                                maxLines: 5
                              ),
                            ),
                            SizedBox(
                              width: 23,
                              height: 23,
                              child: TapArea(
                                onTap: () async {
                                  String productDiscussionText = "";
                                  if (_productDiscussionListItemValue != null) {
                                    ProductDiscussionDialogListItemValue productDiscussionDialogListItemValue = ProductDiscussionDialog(
                                      id: "",
                                      productId: widget.productDiscussionPageParameter.productId,
                                      bundleId: widget.productDiscussionPageParameter.bundleId,
                                      userId: (_loggedUser?.id).toEmptyStringNonNull,
                                      discussion: _productDiscussionTextEditingController.text,
                                      discussionDate: DateTime.now(),
                                      productDiscussionUser: ProductDiscussionUser(
                                        id: (_loggedUser?.id).toEmptyStringNonNull,
                                        name: (_loggedUser?.name).toEmptyStringNonNull,
                                        role: (_loggedUser?.role) ?? 0,
                                        email: (_loggedUser?.email).toEmptyStringNonNull,
                                        avatar: (_loggedUser?.userProfile)?.avatar
                                      ),
                                      productInDiscussion: ProductInDiscussion(
                                        id: "",
                                        userId: "",
                                        productBrandId: "",
                                        name: "",
                                        slug: "",
                                        description: "",
                                        productCategoryId: "",
                                        provinceId: ""
                                      ),
                                    ).toProductDiscussionDialogListItemValue()..isLoading = true;
                                    if (widget.productDiscussionPageParameter.discussionProductId == null) {
                                      _productDiscussionListItemValue!.productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList.add(
                                        productDiscussionDialogListItemValue
                                      );
                                    } else {
                                      var productDiscussionDialogListItemValueList = _productDiscussionListItemValue!.productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList;
                                      var selectedProductDiscussionDialogListItemValueList = productDiscussionDialogListItemValueList.where((value) => value.productDiscussionDialogContainsListItemValue.id == widget.productDiscussionPageParameter.discussionProductId);
                                      if (selectedProductDiscussionDialogListItemValueList.isNotEmpty) {
                                        var selectedProductDiscussionDialogListItemValue = selectedProductDiscussionDialogListItemValueList.first;
                                        selectedProductDiscussionDialogListItemValue.replyProductDiscussionDialogListItemValueList.add(productDiscussionDialogListItemValue);
                                      }
                                    }
                                    if (_defaultProductDiscussionContainerInterceptingActionListItemControllerState.onUpdateProductDiscussionListItemValue != null) {
                                      _defaultProductDiscussionContainerInterceptingActionListItemControllerState.onUpdateProductDiscussionListItemValue!(
                                        _productDiscussionListItemValue!
                                      );
                                    }
                                    _checkDiscussionEmpty();
                                    productDiscussionText = _productDiscussionTextEditingController.text;
                                    _productDiscussionTextEditingController.clear();
                                    _scrollToDown();
                                  }
                                  if (widget.productDiscussionPageParameter.discussionProductId != null) {
                                    await widget.productDiscussionController.replyProductDiscussion(
                                      ReplyProductDiscussionParameter(
                                        discussionProductId: widget.productDiscussionPageParameter.discussionProductId!,
                                        message: productDiscussionText
                                      )
                                    );
                                  } else {
                                    await widget.productDiscussionController.createProductDiscussion(
                                      CreateProductDiscussionParameter(
                                        productId: widget.productDiscussionPageParameter.productId,
                                        bundleId: widget.productDiscussionPageParameter.bundleId,
                                        message: productDiscussionText
                                      )
                                    );
                                  }
                                  await _refreshProductDiscussion();
                                },
                                child: ModifiedSvgPicture.asset(Constant.vectorSendMessage, overrideDefaultColorWithSingleColor: false),
                              )
                            )
                          ],
                        )
                      ),
                    ]
                  )
                )
              ]
            ]
          )
        ),
      ),
    );
  }

  void _checkDiscussionEmpty() {
    if (widget.productDiscussionPageParameter.discussionProductId == null) {
      if (_productDiscussionListItemValue!.productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList.isEmpty) {
        _fillerErrorValueNotifier.value = _getEmptyError();
      } else {
        _fillerErrorValueNotifier.value = null;
      }
    } else {
      var productDiscussionDialogListItemValueList = _productDiscussionListItemValue!.productDiscussionDetailListItemValue.productDiscussionDialogListItemValueList;
      var selectedProductDiscussionDialogListItemValueList = productDiscussionDialogListItemValueList.where((value) => value.productDiscussionDialogContainsListItemValue.id == widget.productDiscussionPageParameter.discussionProductId);
      if (selectedProductDiscussionDialogListItemValueList.isNotEmpty) {
        var selectedProductDiscussionDialogListItemValue = selectedProductDiscussionDialogListItemValueList.first;
        if (selectedProductDiscussionDialogListItemValue.replyProductDiscussionDialogListItemValueList.isEmpty) {
          _fillerErrorValueNotifier.value = _getEmptyError();
        } else {
          _fillerErrorValueNotifier.value = null;
        }
      }
    }
  }
}

class ProductDiscussionPageParameter {
  String? productId;
  String? bundleId;
  String? discussionProductId;
  bool isBasedUser;

  ProductDiscussionPageParameter({
    required this.productId,
    required this.bundleId,
    required this.discussionProductId,
    this.isBasedUser = false
  });
}

extension ProductDiscussionPageParameterExt on ProductDiscussionPageParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    <String, dynamic>{
      "product_id": productId,
      "bundle_id": bundleId,
      "discussion_product_id": discussionProductId,
      "is_based_user": isBasedUser ? "1" : "0"
    }
  );
}

extension ProductDiscussionPageParameterStringExt on String {
  ProductDiscussionPageParameter toProductDiscussionPageParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return ProductDiscussionPageParameter(
      productId: result["product_id"],
      bundleId: result["bundle_id"],
      discussionProductId: result["discussion_product_id"],
      isBasedUser: result["is_based_user"] == "1" ? true : false
    );
  }
}