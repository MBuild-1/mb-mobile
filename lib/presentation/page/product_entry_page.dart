import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/paging_ext.dart';

import '../../controller/product_entry_controller.dart';
import '../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/product/productentry/product_entry_header_content_parameter.dart';
import '../../domain/entity/product/productentry/product_entry_header_content_response.dart';
import '../../domain/usecase/get_product_entry_header_content_use_case.dart';
import '../../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_bundle_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_entry_header_background_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/on_observe_load_product_delegate.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/productentryheaderbackground/asset_product_entry_header_background.dart';
import '../../misc/string_util.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_detail_page.dart';

class ProductEntryPage extends RestorableGetxPage<_ProductEntryPageRestoration> {
  late final ControllerMember<ProductEntryController> _productEntryController = ControllerMember<ProductEntryController>().addToControllerManager(controllerManager);

  final ProductEntryPageParameter productEntryPageParameter;

  ProductEntryPage({Key? key, required this.productEntryPageParameter}) : super(key: key, pageRestorationId: () => "product-entry-page");

  @override
  void onSetController() {
    _productEntryController.controller = GetExtended.put<ProductEntryController>(
      ProductEntryController(
        controllerManager,
        Injector.locator<GetProductEntryWithConditionPagingUseCase>(),
        Injector.locator<GetProductEntryHeaderContentUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _ProductEntryPageRestoration createPageRestoration() => _ProductEntryPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductEntryControllerMediatorWidget(
      productEntryController: _productEntryController.controller,
      productEntryPageParameter: productEntryPageParameter,
    );
  }
}

class _ProductEntryPageRestoration extends MixableGetxPageRestoration with ProductDetailPageRestorationMixin {
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

class ProductEntryPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ProductEntryPageParameter productEntryPageParameter;

  ProductEntryPageGetPageBuilderAssistant({
    required this.productEntryPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductEntryPage(
    productEntryPageParameter: productEntryPageParameter
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    ProductEntryPage(
      productEntryPageParameter: productEntryPageParameter
    )
  ));
}

mixin ProductEntryPageRestorationMixin on MixableGetxPageRestoration {
  late ProductEntryPageRestorableRouteFuture productEntryPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productEntryPageRestorableRouteFuture = ProductEntryPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-bundle-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productEntryPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productEntryPageRestorableRouteFuture.dispose();
  }
}

class ProductEntryPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductEntryPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    ProductEntryPageParameter productEntryPageParameter = arguments.toProductEntryPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ProductEntryPageGetPageBuilderAssistant(
          productEntryPageParameter: productEntryPageParameter
        )
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

class _StatefulProductEntryControllerMediatorWidget extends StatefulWidget {
  final ProductEntryController productEntryController;
  final ProductEntryPageParameter productEntryPageParameter;

  const _StatefulProductEntryControllerMediatorWidget({
    required this.productEntryController,
    required this.productEntryPageParameter
  });

  @override
  State<_StatefulProductEntryControllerMediatorWidget> createState() => _StatefulProductEntryControllerMediatorWidgetState();
}

class _StatefulProductEntryControllerMediatorWidgetState extends State<_StatefulProductEntryControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _productEntryListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productEntryListItemPagingControllerState;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];

  @override
  void initState() {
    super.initState();
    _productEntryListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productEntryController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductBundleAdditionalPagingResultParameterChecker>()
    );
    _productEntryListItemPagingControllerState = PagingControllerState(
      pagingController: _productEntryListItemPagingController,
      isPagingControllerExist: false
    );
    _productEntryListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _productEntryListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productEntryListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productEntryListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    LoadDataResult<PagingDataResult<ProductEntry>> productEntryLoadDataResult = await widget.productEntryController.getProductEntryPaging(
      ProductWithConditionPagingParameter(
        page: pageKey,
        itemEachPageCount: 10,
        withCondition: widget.productEntryPageParameter.productEntryParameterMap
      )
    );
    return productEntryLoadDataResult.map<PagingResult<ListItemControllerState>>((productEntryPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      Iterable<ListItemControllerState> verticalProductListItemControllerStateList = productEntryPaging.map<ListItemControllerState>(
        (productEntry) => VerticalProductListItemControllerState(
          productAppearanceData: productEntry,
          onAddWishlist: (productOrProductEntryId) {},
          onRemoveWishlist: (productOrProductEntryId) {}
        )
      ).itemList;
      int totalItem = productEntryPaging.totalItem;
      if (pageKey == 1) {
        totalItem = 2;
        resultListItemControllerState = [
          componentEntityMediator.mapWithParameter(
            widget.productEntryController.getProductEntryHeader(
              ProductEntryHeaderContentParameter(
                parameterMap: widget.productEntryPageParameter.productEntryParameterMap
              )
            ),
            parameter: carouselParameterizedEntityMediator
          ),
          VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
            childListItemControllerStateList: [
              ...verticalProductListItemControllerStateList
            ]
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(listItemControllerStateList)) {
          VerticalGridPaddingContentSubInterceptorSupportListItemControllerState verticalGridListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(listItemControllerStateList![1]) as VerticalGridPaddingContentSubInterceptorSupportListItemControllerState;
          verticalGridListItemControllerState.childListItemControllerStateList.addAll(
            verticalProductListItemControllerStateList
          );
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: productEntryPaging.page,
        totalPage: productEntryPaging.totalPage,
        totalItem: totalItem
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    OnObserveLoadProductDelegateFactory onObserveLoadProductDelegateFactory = Injector.locator<OnObserveLoadProductDelegateFactory>()
      ..onInjectLoadProductEntryCarouselParameterizedEntity = (
        () => WishlistParameterizedEntityAndListItemControllerStateMediatorParameter(
          onAddWishlist: (productOrProductEntryId) {},
          onRemoveWishlist: (productOrProductEntryId) {},
        )
      )
      ..onInjectLoadProductBundleCarouselParameterizedEntity = (
        () => WishlistParameterizedEntityAndListItemControllerStateMediatorParameter(
          onAddWishlist: (productBundleId) {},
          onRemoveWishlist: (productBundleId) {},
        )
      );
    widget.productEntryController.setProductEntryDelegate(
      ProductEntryDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onObserveLoadProductEntryHeaderContentDirectly: (onObserveLoadProductEntryHeaderContentDirectlyParameter) {
          LoadDataResult<ProductEntryHeaderContentResponse> productEntryHeaderContentResponseLoadDataResult = onObserveLoadProductEntryHeaderContentDirectlyParameter.productEntryHeaderContentResponseLoadDataResult;
          return ProductEntryHeaderLoadDataResultListItemControllerState(
            productEntryHeaderContentResponseLoadDataResult: productEntryHeaderContentResponseLoadDataResult,
            errorProvider: Injector.locator<ErrorProvider>()
          );
        },
      )
    );
    return Scaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productEntryListItemPagingControllerState,
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

class ProductEntryPageParameter {
  Map<String, dynamic> productEntryParameterMap;

  ProductEntryPageParameter({
    required this.productEntryParameterMap
  });
}

extension ProductEntryPageParameterExt on ProductEntryPageParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(productEntryParameterMap);
}

extension ProductEntryPageParameterStringExt on String {
  ProductEntryPageParameter toProductEntryPageParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return ProductEntryPageParameter(productEntryParameterMap: result);
  }
}