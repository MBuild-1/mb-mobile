import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:provider/provider.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../../../../domain/entity/cart/support_cart.dart';
import '../../../../domain/entity/wishlist/wishlist.dart';
import '../../../../domain/entity/wishlist/wishlist_list_parameter.dart';
import '../../../../domain/entity/wishlist/wishlist_paging_parameter.dart';
import '../../../../misc/additionalloadingindicatorchecker/wishlist_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/wishlistlistitemcontrollerstate/wishlist_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/error/empty_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/itemtypelistsubinterceptor/wishlist_item_type_list_sub_interceptor.dart';
import '../../../../misc/list_item_controller_state_helper.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/login_helper.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/toast_helper.dart';
import '../../../../misc/widget_helper.dart';
import '../../../notifier/component_notifier.dart';
import '../../../notifier/notification_notifier.dart';
import '../../../notifier/product_notifier.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
import '../../getx_page.dart';

class WishlistMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<WishlistMainMenuSubController> _wishlistMainMenuSubController = ControllerMember<WishlistMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  WishlistMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key, systemUiOverlayStyle: SystemUiOverlayStyle.light);

  @override
  void onSetController() {
    _wishlistMainMenuSubController.controller = Injector.locator<WishlistMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulWishlistMainMenuSubControllerMediatorWidget(
      wishlistMainMenuSubController: _wishlistMainMenuSubController.controller
    );
  }
}

class _StatefulWishlistMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final WishlistMainMenuSubController wishlistMainMenuSubController;

  const _StatefulWishlistMainMenuSubControllerMediatorWidget({
    required this.wishlistMainMenuSubController
  });

  @override
  State<_StatefulWishlistMainMenuSubControllerMediatorWidget> createState() => _StatefulWishlistMainMenuSubControllerMediatorWidgetState();
}

class _StatefulWishlistMainMenuSubControllerMediatorWidgetState extends State<_StatefulWishlistMainMenuSubControllerMediatorWidget> {
  late AssetImage _wishlistAppBarBackgroundAssetImage;
  late final ModifiedPagingController<int, ListItemControllerState> _wishlistMainMenuSubListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _wishlistMainMenuSubListItemPagingControllerState;
  DefaultWishlistContainerInterceptingActionListItemControllerState defaultWishlistContainerInterceptingActionListItemControllerState = DefaultWishlistContainerInterceptingActionListItemControllerState();
  late final ProductNotifier _productNotifier;

  @override
  void initState() {
    super.initState();
    _productNotifier = Provider.of<ProductNotifier>(context, listen: false);
    _wishlistAppBarBackgroundAssetImage = AssetImage(Constant.imagePatternWishlistMainMenuAppBar);
    _wishlistMainMenuSubListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.wishlistMainMenuSubController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<WishlistSubAdditionalPagingResultParameterChecker>()
    );
    _wishlistMainMenuSubListItemPagingControllerState = PagingControllerState(
      pagingController: _wishlistMainMenuSubListItemPagingController,
      isPagingControllerExist: false
    );
    _wishlistMainMenuSubListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _wishlistMainMenuListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _wishlistMainMenuSubListItemPagingControllerState.isPagingControllerExist = true;
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyWishlistMainMenu] = refreshWishlistMainMenu;
    MainRouteObserver.onRefreshWishlistInMainMenu = refreshWishlistMainMenu;
  }

  @override
  void didChangeDependencies() {
    precacheImage(_wishlistAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _wishlistMainMenuListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    bool isLogin = false;
    LoginHelper.checkingLogin(
      context,
      () => isLogin = true,
      resultIfHasNotBeenLogin: () {}
    );
    if (!isLogin) {
      return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          page: 1,
          totalPage: 1,
          totalItem: 1,
          itemList: [NoContentListItemControllerState()]
        )
      );
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productNotifier.loadWishlistListFromData(IsLoadingLoadDataResult<List<Wishlist>>());
    });
    await Future.delayed(const Duration(milliseconds: 50));
    LoadDataResult<List<Wishlist>> wishlistPagingLoadDataResult = await widget.wishlistMainMenuSubController.getWishlistList(
      WishlistListParameter()
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productNotifier.loadWishlistListFromData(wishlistPagingLoadDataResult);
    });
    return wishlistPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((wishlistList) {
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          WishlistContainerListItemControllerState(
            wishlistList: wishlistList,
            onUpdateState: () => setState(() {}),
            afterRemoveWishlist: (wishlistList) {
              if (wishlistList.isEmpty) {
                _wishlistMainMenuSubListItemPagingController.refresh();
              }
            },
            onRemoveWishlistWithWishlist: (wishlist) => widget.wishlistMainMenuSubController.wishlistAndCartControllerContentDelegate.removeFromWishlistDirectly(
              wishlist, () {
                Completer<bool> checkingLoginCompleter = Completer<bool>();
                LoginHelper.checkingLogin(
                  context,
                  () => checkingLoginCompleter.complete(true),
                  resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                  showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                );
                return checkingLoginCompleter.future;
              }
            ),
            onAddProductCart: (productAppearanceData) => widget.wishlistMainMenuSubController.wishlistAndCartControllerContentDelegate.addToCart(
              productAppearanceData as SupportCart, () {
                Completer<bool> checkingLoginCompleter = Completer<bool>();
                LoginHelper.checkingLogin(
                  context,
                  () => checkingLoginCompleter.complete(true),
                  resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                  showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                );
                return checkingLoginCompleter.future;
              }
            ),
            onAddProductBundleCart: (productBundle) => widget.wishlistMainMenuSubController.wishlistAndCartControllerContentDelegate.addToCart(
              productBundle, () {
                Completer<bool> checkingLoginCompleter = Completer<bool>();
                LoginHelper.checkingLogin(
                  context,
                  () => checkingLoginCompleter.complete(true),
                  resultIfHasNotBeenLogin: () => checkingLoginCompleter.complete(false),
                  showLoginPageWhenHasCallbackIfHasNotBeenLogin: true
                );
                return checkingLoginCompleter.future;
              }
            ),
            wishlistContainerInterceptingActionListItemControllerState: defaultWishlistContainerInterceptingActionListItemControllerState
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: wishlistList.length
      );
    });
  }

  void refreshWishlistMainMenu() {
    if (MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyWishlistMainMenu] != true) {
      _productNotifier.loadWishlistList();
    }
    setState(() {});
    _wishlistMainMenuSubListItemPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    widget.wishlistMainMenuSubController.wishlistAndCartControllerContentDelegate.setWishlistAndCartDelegate(
      Injector.locator<WishlistAndCartDelegateFactory>().generateWishlistAndCartDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onRemoveFromWishlistRequestProcessSuccessCallback: (wishlist) async {
          if (defaultWishlistContainerInterceptingActionListItemControllerState.removeWishlist != null) {
            defaultWishlistContainerInterceptingActionListItemControllerState.removeWishlist!(wishlist);
          }
          context.read<ComponentNotifier>().updateWishlist(withRefreshWishlistInMainMenu: false);
        },
        onRemoveFromWishlistRequestProcessFailedCallback: (e) async {
          ErrorProvider errorProvider = Injector.locator<ErrorProvider>();
          ErrorProviderResult errorProviderResult = errorProvider.onGetErrorProviderResult(e).toErrorProviderResultNonNull();
          ToastHelper.showToast(errorProviderResult.message);
          context.read<ComponentNotifier>().updateWishlist(withRefreshWishlistInMainMenu: false);
        },
        onAddCartRequestProcessSuccessCallback: () async {
          context.read<ComponentNotifier>().updateCart();
          context.read<NotificationNotifier>().loadCartLoadDataResult();
          context.read<ProductNotifier>().loadCartList();
        },
      )
    );
    return WidgetHelper.checkVisibility(
      MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyWishlistMainMenu],
      () => BackgroundAppBarScaffold(
        backgroundAppBarImage: _wishlistAppBarBackgroundAssetImage,
        appBar: MainMenuSearchAppBar(value: 0.0),
        body: Expanded(
          child: WidgetHelper.checkingLogin(
            context,
            () => ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              pagingControllerState: _wishlistMainMenuSubListItemPagingControllerState,
              onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                pagingControllerState: pagingControllerState!
              ),
              pullToRefresh: true
            ),
            Injector.locator<ErrorProvider>(),
            withIndexedStack: true
          )
        ),
      )
    );
  }
}