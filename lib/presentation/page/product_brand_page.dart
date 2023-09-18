import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../controller/product_brand_controller.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbrand/product_brand_paging_parameter.dart';
import '../../domain/usecase/get_product_brand_paging_use_case.dart';
import '../../domain/usecase/get_selected_fashion_brands_paging_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_bundle_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/vertical_product_brand_list_item_controller_state.dart';
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
import '../../misc/string_util.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_entry_page.dart';
import 'search_page.dart';

class ProductBrandPage extends RestorableGetxPage<_ProductBrandPageRestoration> {
  late final ControllerMember<ProductBrandController> _productBrandController = ControllerMember<ProductBrandController>().addToControllerManager(controllerManager);

  final ProductBrandPageParameter productBrandPageParameter;

  ProductBrandPage({
    Key? key,
    required this.productBrandPageParameter
  }) : super(key: key, pageRestorationId: () => "product-brand-page");

  @override
  void onSetController() {
    _productBrandController.controller = GetExtended.put<ProductBrandController>(
      ProductBrandController(
        controllerManager,
        Injector.locator<GetProductBrandPagingUseCase>(),
        Injector.locator<GetSelectedFashionBrandsPagingUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _ProductBrandPageRestoration createPageRestoration() => _ProductBrandPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductBrandControllerMediatorWidget(
      productBrandController: _productBrandController.controller,
      productBrandPageParameter: productBrandPageParameter
    );
  }
}

class _ProductBrandPageRestoration extends MixableGetxPageRestoration with ProductEntryPageRestorationMixin, SearchPageRestorationMixin {
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

class ProductBrandPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ProductBrandPageParameter productBrandPageParameter;

  ProductBrandPageGetPageBuilderAssistant({
    required this.productBrandPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductBrandPage(productBrandPageParameter: productBrandPageParameter));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductBrandPage(productBrandPageParameter: productBrandPageParameter)));
}

mixin ProductBrandPageRestorationMixin on MixableGetxPageRestoration {
  late ProductBrandPageRestorableRouteFuture productBrandPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productBrandPageRestorableRouteFuture = ProductBrandPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-brand-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productBrandPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productBrandPageRestorableRouteFuture.dispose();
  }
}

class ProductBrandPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductBrandPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    ProductBrandPageParameter productBrandPageParameter = arguments.toProductBrandPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ProductBrandPageGetPageBuilderAssistant(productBrandPageParameter: productBrandPageParameter)
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

class _StatefulProductBrandControllerMediatorWidget extends StatefulWidget {
  final ProductBrandController productBrandController;
  final ProductBrandPageParameter productBrandPageParameter;

  const _StatefulProductBrandControllerMediatorWidget({
    required this.productBrandController,
    required this.productBrandPageParameter
  });

  @override
  State<_StatefulProductBrandControllerMediatorWidget> createState() => _StatefulProductBrandControllerMediatorWidgetState();
}

class _StatefulProductBrandControllerMediatorWidgetState extends State<_StatefulProductBrandControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _productBrandListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productBrandListItemPagingControllerState;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];

  @override
  void initState() {
    super.initState();
    _productBrandListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productBrandController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductBundleAdditionalPagingResultParameterChecker>()
    );
    _productBrandListItemPagingControllerState = PagingControllerState(
      pagingController: _productBrandListItemPagingController,
      isPagingControllerExist: false
    );
    _productBrandListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _productBrandListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productBrandListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productBrandListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    late LoadDataResult<PagingDataResult<ProductBrand>> productBrandLoadDataResult;
    ProductBrandPageType productBrandPageType = widget.productBrandPageParameter.productBrandPageType;
    String title = "";
    if (productBrandPageType == ProductBrandPageType.defaultProductDetail) {
      productBrandLoadDataResult = await widget.productBrandController.getProductBrandPaging(
        ProductBrandPagingParameter(
          page: pageKey,
          itemEachPageCount: 10
        )
      );
      title = "Product Brand".tr;
    } else if (productBrandPageType == ProductBrandPageType.selectedFashionBrandProductDetail) {
      productBrandLoadDataResult = await widget.productBrandController.getSelectedFashionBrandsPaging(
        ProductBrandPagingParameter(
          page: pageKey,
          itemEachPageCount: 10
        )
      );
      title = Constant.multiLanguageStringSelectedFashionBrands.toEmptyStringNonNull;
    }
    return productBrandLoadDataResult.map<PagingResult<ListItemControllerState>>((productBrandPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      Iterable<ListItemControllerState> verticalProductBrandListItemControllerStateList = productBrandPaging.map<ListItemControllerState>(
        (productBrand) => VerticalProductBrandListItemControllerState(
          productBrand: productBrand
        )
      ).itemList;
      int totalItem = productBrandPaging.totalItem;
      if (pageKey == 1) {
        totalItem = 2;
        resultListItemControllerState = [
          CompoundListItemControllerState(
            listItemControllerState: [
              VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                  title: title
                ),
              ),
            ]
          ),
          VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
            childListItemControllerStateList: [
              ...verticalProductBrandListItemControllerStateList
            ]
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(listItemControllerStateList)) {
          VerticalGridPaddingContentSubInterceptorSupportListItemControllerState verticalGridListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(
            listItemControllerStateList![1]
          ) as VerticalGridPaddingContentSubInterceptorSupportListItemControllerState;
          verticalGridListItemControllerState.childListItemControllerStateList.addAll(
            verticalProductBrandListItemControllerStateList
          );
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: productBrandPaging.page,
        totalPage: productBrandPaging.totalPage,
        totalItem: totalItem
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productBrandListItemPagingControllerState,
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

enum ProductBrandPageType {
  defaultProductDetail, selectedFashionBrandProductDetail
}

class ProductBrandPageParameter {
  ProductBrandPageType productBrandPageType;

  ProductBrandPageParameter({
    required this.productBrandPageType
  });
}

extension ProductBrandPageParameterExt on ProductBrandPageParameter {
  String toEncodeBase64String() {
    String type = "";
    if (productBrandPageType == ProductBrandPageType.defaultProductDetail) {
      type = "1";
    } else if (productBrandPageType == ProductBrandPageType.selectedFashionBrandProductDetail) {
      type = "2";
    }
    return StringUtil.encodeBase64StringFromJson(
      <String, dynamic>{
        "product_brand_page_type": type,
      }
    );
  }
}

extension ProductBrandPageParameterStringExt on String {
  ProductBrandPageParameter toProductBrandPageParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    late ProductBrandPageType productBrandPageType;
    String type = result["product_brand_page_type"];
    if (type == "1") {
      productBrandPageType = ProductBrandPageType.defaultProductDetail;
    } else if (type == "2") {
      productBrandPageType = ProductBrandPageType.selectedFashionBrandProductDetail;
    }
    return ProductBrandPageParameter(
      productBrandPageType: productBrandPageType
    );
  }
}