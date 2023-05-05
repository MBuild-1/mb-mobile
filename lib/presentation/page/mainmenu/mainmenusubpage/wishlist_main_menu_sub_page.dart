import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/wishlist_main_menu_sub_controller.dart';
import '../../../../domain/entity/product/product_appearance_data.dart';
import '../../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../../domain/entity/wishlist/support_wishlist.dart';
import '../../../../domain/entity/wishlist/wishlist.dart';
import '../../../../domain/entity/wishlist/wishlist_paging_parameter.dart';
import '../../../../misc/additionalloadingindicatorchecker/wishlist_sub_additional_paging_result_parameter_checker.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/vertical_product_bundle_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/error/message_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/widget_helper.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modifiedappbar/default_search_app_bar.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
import '../../getx_page.dart';

class WishlistMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<WishlistMainMenuSubController> _wishlistMainMenuSubController = ControllerMember<WishlistMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  WishlistMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
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
    _wishlistMainMenuSubListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _wishlistMainMenuListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _wishlistMainMenuSubListItemPagingControllerState.isPagingControllerExist = true;
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyWishlistMainMenu] = refreshWishlistMainMenu;
  }

  @override
  void didChangeDependencies() {
    precacheImage(_wishlistAppBarBackgroundAssetImage, context);
    super.didChangeDependencies();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _wishlistMainMenuListItemPagingControllerStateListener(int pageKey) async {
    LoadDataResult<PagingDataResult<Wishlist>> wishlistPagingLoadDataResult = await widget.wishlistMainMenuSubController.getWishlistPaging(
      WishlistPagingParameter(page: pageKey)
    );
    return wishlistPagingLoadDataResult.map<PagingResult<ListItemControllerState>>(
      (wishlistPagingDataResult) => wishlistPagingDataResult.map<ListItemControllerState>(
        (wishlist) {
          SupportWishlist supportWishlist = wishlist.supportWishlist;
          if (supportWishlist is ProductAppearanceData) {
            return VerticalProductListItemControllerState(
              productAppearanceData: supportWishlist as ProductAppearanceData,
              onRemoveWishlist: (productOrProductEntryId) {},
            );
          } else if (supportWishlist is ProductBundle) {
            return VerticalProductBundleListItemControllerState(
              productBundle: supportWishlist,
              onRemoveWishlist: (productOrProductEntryId) {},
            );
          } else {
            throw MessageError(title: "Support wishlist is not valid");
          }
        },
      )
    );
  }

  void refreshWishlistMainMenu() {
    _wishlistMainMenuSubListItemPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundAppBarScaffold(
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
          Injector.locator<ErrorProvider>()
        )
      ),
    );
  }
}