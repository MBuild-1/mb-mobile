import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../controller/product_detail_controller.dart';
import '../../domain/entity/location/location.dart';
import '../../domain/entity/product/product.dart';
import '../../domain/entity/product/product_detail_get_other_from_this_brand_parameter.dart';
import '../../domain/entity/product/product_detail_get_other_in_this_category_parameter.dart';
import '../../domain/entity/product/product_detail_parameter.dart';
import '../../domain/usecase/get_product_category_list_use_case.dart';
import '../../domain/usecase/get_product_detail_from_your_search_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_chosen_for_you_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_from_this_brand_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_in_this_category_product_entry_list_use_case.dart';
import '../../domain/usecase/get_product_detail_other_interested_product_brand_list_use_case.dart';
import '../../domain/usecase/get_product_detail_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/product_detail_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/colorful_divider_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/delivery_to_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_brand_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_header_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/product_detail_image_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/on_observe_load_product_delegate.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../widget/modified_divider.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/default_search_app_bar.dart';
import 'getx_page.dart';
import 'product_brand_detail_page.dart';

class ProductDetailPage extends RestorableGetxPage<_ProductDetailPageRestoration> {
  late final ControllerMember<ProductDetailController> _productDetailController = ControllerMember<ProductDetailController>().addToControllerManager(controllerManager);

  final String productId;

  ProductDetailPage({Key? key, required this.productId}) : super(key: key, pageRestorationId: () => "product-detail-page");

  @override
  void onSetController() {
    _productDetailController.controller = GetExtended.put<ProductDetailController>(
      ProductDetailController(
        controllerManager,
        Injector.locator<GetProductDetailUseCase>(),
        Injector.locator<GetProductCategoryListUseCase>(),
        Injector.locator<GetProductDetailOtherChosenForYouProductEntryListUseCase>(),
        Injector.locator<GetProductDetailOtherFromThisBrandProductEntryListUseCase>(),
        Injector.locator<GetProductDetailOtherInThisCategoryProductEntryListUseCase>(),
        Injector.locator<GetProductDetailFromYourSearchProductEntryListUseCase>(),
        Injector.locator<GetProductDetailOtherInterestedProductBrandListUseCase>(),
      ),
      tag: pageName
    );
  }

  @override
  _ProductDetailPageRestoration createPageRestoration() => _ProductDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulProductDetailControllerMediatorWidget(
        productId: productId,
        productDetailController: _productDetailController.controller,
      ),
    );
  }
}

class _ProductDetailPageRestoration extends MixableGetxPageRestoration with ProductDetailPageRestorationMixin, ProductBrandDetailPageRestorationMixin {
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

class ProductDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String productId;

  ProductDetailPageGetPageBuilderAssistant({
    required this.productId
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductDetailPage(productId: productId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductDetailPage(productId: productId)));
}

mixin ProductDetailPageRestorationMixin on MixableGetxPageRestoration {
  late ProductDetailPageRestorableRouteFuture productDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productDetailPageRestorableRouteFuture = ProductDetailPageRestorableRouteFuture(restorationId: restorationIdWithPageName('login-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productDetailPageRestorableRouteFuture.dispose();
  }
}

class ProductDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductDetailPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ProductDetailPageGetPageBuilderAssistant(productId: arguments)),
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

class _StatefulProductDetailControllerMediatorWidget extends StatefulWidget {
  final ProductDetailController productDetailController;
  final String productId;

  const _StatefulProductDetailControllerMediatorWidget({
    required this.productDetailController,
    required this.productId
  });

  @override
  State<_StatefulProductDetailControllerMediatorWidget> createState() => _StatefulProductDetailControllerMediatorWidgetState();
}

class _StatefulProductDetailControllerMediatorWidgetState extends State<_StatefulProductDetailControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _productDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productDetailListItemPagingControllerState;
  final List<LoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];

  @override
  void initState() {
    super.initState();
    _productDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productDetailController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<ProductDetailAdditionalPagingResultParameterChecker>()
    );
    _productDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _productDetailListItemPagingController,
      isPagingControllerExist: false
    );
    _productDetailListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _productDetailListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productDetailListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productDetailListItemPagingControllerStateListener(int pageKey) async {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    LoadDataResult<Product> productLoadDataResult = await widget.productDetailController.getProductDetail(
      ProductDetailParameter(productId: widget.productId)
    );
    return productLoadDataResult.map((product) {
      return PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          ProductDetailImageListItemControllerState(productAppearanceData: product),
          VirtualSpacingListItemControllerState(height: 2.h),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
              title: product.name,
              verticalSpace: 5,
              titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                if (titleWidget != null) {
                  if (titleWidget is Text) {
                    titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: titleWidget.style?.copyWith(fontWeight: FontWeight.normal));
                  }
                }
                return titleAndDescriptionWidget;
              }
            ),
          ),
          VirtualSpacingListItemControllerState(height: 2.h),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
              title: "Product Detail".tr,
              description: product.description,
              verticalSpace: 25,
              titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                List<List<String>> productDetailContentList = [
                  if (product.productCertificationList.isNotEmpty) <String>["Certification".tr, product.productCertificationList.first.name],
                  //<String>["Contain".tr, product.],
                  <String>["Category".tr, product.productCategory.name],
                  <String>["Province".tr, product.province.name],
                  <String>["Brand".tr, product.productBrand.name],
                ];
                titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                titleAndDescriptionWidgetList.last = Column(
                  children: productDetailContentList.mapIndexed(
                    (index, productDetailContentListValue) {
                      List<Widget> columnResult = [
                        Row(
                          children: [
                            Expanded(
                              child: Text(productDetailContentListValue[0]),
                            ),
                            Expanded(
                              child: Text(productDetailContentListValue[1]),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 5),
                            const ModifiedDivider(),
                            if (index < productDetailContentList.length - 1)
                              const SizedBox(height: 5),
                          ]
                        ),
                      ];
                      return Column(
                        children: columnResult,
                      );
                    }
                  ).toList(),
                );
                return titleAndDescriptionWidget;
              }
            ),
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
              title: "Product Description".tr,
              description: product.description,
              verticalSpace: 25,
              titleAndDescriptionItemInterceptor: (padding, title, titleWidget, description, descriptionWidget, titleAndDescriptionWidget, titleAndDescriptionWidgetList) {
                titleAndDescriptionWidgetList.first = Text(title.toStringNonNull, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold));
                return titleAndDescriptionWidget;
              }
            ),
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
          componentEntityMediator.mapWithParameter(
            widget.productDetailController.getOtherInThisCategory(
              ProductDetailGetOtherInThisCategoryParameter(
                categorySlug: product.productCategory.slug
              )
            ),
            parameter: carouselParameterizedEntityMediator
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
          ProductDetailBrandListItemControllerState(productBrand: product.productBrand),
          VirtualSpacingListItemControllerState(height: 4.h),
          componentEntityMediator.mapWithParameter(
            widget.productDetailController.getOtherFromThisBrand(
              ProductDetailGetOtherFromThisBrandParameter(
                brandSlug: product.productBrand.slug
              )
            ),
            parameter: carouselParameterizedEntityMediator
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
          componentEntityMediator.mapWithParameter(
            widget.productDetailController.getOtherChosenForYou(),
            parameter: carouselParameterizedEntityMediator
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
          componentEntityMediator.mapWithParameter(
            widget.productDetailController.getOtherFromYourSearch(),
            parameter: carouselParameterizedEntityMediator
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
          componentEntityMediator.mapWithParameter(
            widget.productDetailController.getOtherInterestedProductBrand(),
            parameter: carouselParameterizedEntityMediator
          ),
          VirtualSpacingListItemControllerState(height: 4.h),
        ]
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
    widget.productDetailController.setProductDetailMainMenuDelegate(
      ProductDetailMainMenuDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
      )
    );
    return Scaffold(
      appBar: DefaultSearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _productDetailListItemPagingControllerState,
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