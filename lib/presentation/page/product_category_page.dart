import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';

import '../../controller/product_category_controller.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../../domain/entity/product/productcategory/product_category_paging_parameter.dart';
import '../../domain/usecase/get_product_category_paging_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_bundle_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/product_category_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/vertical_product_category_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_entry_page.dart';
import 'search_page.dart';

class ProductCategoryPage extends RestorableGetxPage<_ProductCategoryPageRestoration> {
  late final ControllerMember<ProductCategoryController> _productCategoryController = ControllerMember<ProductCategoryController>().addToControllerManager(controllerManager);

  ProductCategoryPage({
    Key? key,
  }) : super(key: key, pageRestorationId: () => "product-category-page");

  @override
  void onSetController() {
    _productCategoryController.controller = GetExtended.put<ProductCategoryController>(
      ProductCategoryController(
        controllerManager,
        Injector.locator<GetProductCategoryPagingUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _ProductCategoryPageRestoration createPageRestoration() => _ProductCategoryPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductCategoryControllerMediatorWidget(
      productCategoryController: _productCategoryController.controller
    );
  }
}

class _ProductCategoryPageRestoration extends ExtendedMixableGetxPageRestoration with ProductEntryPageRestorationMixin, SearchPageRestorationMixin {
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

class ProductCategoryPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => ProductCategoryPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductCategoryPage()));
}

mixin ProductCategoryPageRestorationMixin on MixableGetxPageRestoration {
  late ProductCategoryPageRestorableRouteFuture productCategoryPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productCategoryPageRestorableRouteFuture = ProductCategoryPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-category-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productCategoryPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productCategoryPageRestorableRouteFuture.dispose();
  }
}

class ProductCategoryPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductCategoryPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ProductCategoryPageGetPageBuilderAssistant()
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

class _StatefulProductCategoryControllerMediatorWidget extends StatefulWidget {
  final ProductCategoryController productCategoryController;

  const _StatefulProductCategoryControllerMediatorWidget({
    required this.productCategoryController,
  });

  @override
  State<_StatefulProductCategoryControllerMediatorWidget> createState() => _StatefulProductCategoryControllerMediatorWidgetState();
}

class _StatefulProductCategoryControllerMediatorWidgetState extends State<_StatefulProductCategoryControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _productCategoryListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productCategoryListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _productCategoryListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productCategoryController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductBundleAdditionalPagingResultParameterChecker>()
    );
    _productCategoryListItemPagingControllerState = PagingControllerState(
      pagingController: _productCategoryListItemPagingController,
      isPagingControllerExist: false
    );
    _productCategoryListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _productCategoryListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productCategoryListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productCategoryListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    LoadDataResult<PagingDataResult<ProductCategory>> productCategoryLoadDataResult = await widget.productCategoryController.getProductCategoryPaging(
      ProductCategoryPagingParameter(
        page: pageKey,
        itemEachPageCount: 10
      )
    );
    return productCategoryLoadDataResult.map<PagingResult<ListItemControllerState>>((productCategoryPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      int totalItem = productCategoryPaging.totalItem;
      if (pageKey == 1) {
        totalItem = 2;
        resultListItemControllerState = [
          ProductCategoryContainerListItemControllerState(
            productCategoryList: productCategoryPaging.itemList
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(listItemControllerStateList)) {
          ProductCategoryContainerListItemControllerState productCategoryContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(
            listItemControllerStateList![0]
          ) as ProductCategoryContainerListItemControllerState;
          productCategoryContainerListItemControllerState.productCategoryList.addAll(
            productCategoryPaging.itemList
          );
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: productCategoryPaging.page,
        totalPage: productCategoryPaging.totalPage,
        totalItem: totalItem
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModifiedScaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productCategoryListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
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