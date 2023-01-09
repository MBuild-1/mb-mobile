import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/product_detail.dart';
import '../domain/entity/product_detail_parameter.dart';
import '../domain/usecase/get_product_detail.dart';
import '../misc/additionalloadingindicatorchecker/product_detail_paging_result_parameter_checker.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/constant.dart';
import '../misc/controllerstate/listitemcontrollerstate/column_container_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/horizontal_justified_title_and_description_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/product_detail_header_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import 'base_getx_controller.dart';

class ProductDetailController extends BaseGetxController {
  final GetProductDetail getProductDetail;
  final ProductDetailPagingResultParameterChecker productDetailPagingResultParameterChecker;

  late final ModifiedPagingController<int, ListItemControllerState> _productDetailListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productDetailListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> productDetailListItemPagingControllerStateRx;

  bool _hasInitProductDetail = false;

  ProductDetailController(
    super.controllerManager,
    this.getProductDetail,
    this.productDetailPagingResultParameterChecker
  ) {
    _productDetailListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
      additionalPagingResultParameterChecker: productDetailPagingResultParameterChecker
    );
    _productDetailListItemPagingControllerState = PagingControllerState(
      pagingController: _productDetailListItemPagingController,
      isPagingControllerExist: false
    );
    productDetailListItemPagingControllerStateRx = _productDetailListItemPagingControllerState.obs;
  }

  void initProductDetail(String productDetailEndpoint) {
    if (_hasInitProductDetail) {
      return;
    }
    _hasInitProductDetail = true;
    _productDetailListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: (pageKey) => _productDetailPageRequestListener(pageKey, productDetailEndpoint),
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productDetailListItemPagingControllerState.isPagingControllerExist = true;
    _updatePaymentMethodState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productDetailPageRequestListener(int pageKey, String productDetailEndpoint) async {
    return getProductDetail.execute(
      ProductDetailParameter(productDetailEndpoint: productDetailEndpoint)
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'product-detail')).value
    ).map<List<ListItemControllerState>>(
      (result) {
        Widget productInfoDescriptionWidgetInterceptor(String? value, Text textWidget) {
          return Text(value.toStringNonNull, style: const TextStyle(fontWeight: FontWeight.bold));
        }
        return <ListItemControllerState>[
          ProductDetailHeaderListItemControllerState(product: result),
          if (result is ProductDetail)
            ...<ListItemControllerState>[
              TitleAndDescriptionListItemControllerState(
                title: "Description".tr,
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
              ),
              PaddingContainerListItemControllerState(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                paddingChildListItemControllerState: ColumnContainerListItemControllerState(
                  columnChildListItemControllerState: [
                    VirtualSpacingListItemControllerState(),
                    DividerListItemControllerState(),
                    VirtualSpacingListItemControllerState(),
                  ]
                )
              ),
              TitleAndDescriptionListItemControllerState(
                description: result.description,
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
              ),
              VirtualSpacingListItemControllerState(height: 3.h)
            ],
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
              title: "Product Info".tr
            ),
          ),
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: ColumnContainerListItemControllerState(
              columnChildListItemControllerState: [
                VirtualSpacingListItemControllerState(),
                DividerListItemControllerState(),
                VirtualSpacingListItemControllerState(),
              ]
            )
          ),
          CompoundListItemControllerState(
            listItemControllerState: [
              HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                title: "Product Code".tr,
                description: result.productCode,
                descriptionWidgetInterceptor: productInfoDescriptionWidgetInterceptor,
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
              ),
              HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                title: "PLU".tr,
                description: result.productPlu,
                descriptionWidgetInterceptor: productInfoDescriptionWidgetInterceptor,
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
              ),
              HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                title: "SKU".tr,
                description: result.sku,
                descriptionWidgetInterceptor: productInfoDescriptionWidgetInterceptor,
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
              ),
              HorizontalJustifiedTitleAndDescriptionListItemControllerState(
                title: "Unit".tr,
                description: result.unit,
                descriptionWidgetInterceptor: productInfoDescriptionWidgetInterceptor,
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem)
              ),
            ]
          ),
          VirtualSpacingListItemControllerState()
        ];
      }
    ).toPagingResult();
  }

  void _updatePaymentMethodState() {
    productDetailListItemPagingControllerStateRx.valueFromLast((value) => _productDetailListItemPagingControllerState.copy());
    update();
  }
}