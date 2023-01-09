import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';
import 'package:masterbagasi/misc/itemtypelistsubinterceptor/verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';

import '../domain/entity/product.dart';
import '../domain/entity/product_list_parameter.dart';
import '../domain/usecase/get_most_discount_product_from_cached_product_list.dart';
import '../domain/usecase/get_product_detail.dart';
import '../domain/usecase/get_product_list.dart';
import '../misc/additionalloadingindicatorchecker/home_paging_result_parameter_checker.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/constant.dart';
import '../misc/controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/load_data_result.dart';
import '../misc/page_restoration_helper.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_list_result.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import 'base_getx_controller.dart';

class HomeController extends BaseGetxController {
  final GetProductDetail getProductDetail;
  final GetProductList getProductList;
  final GetMostDiscountProductFromCachedProductList getMostDiscountProductFromCachedProductList;
  final HomePagingResultParameterChecker homePagingResultParameterChecker;

  late final ModifiedPagingController<int, ListItemControllerState> _homeListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _homeListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> homeListItemPagingControllerStateRx;

  HomeController(
    super.controllerManager,
    this.getProductDetail,
    this.getProductList,
    this.getMostDiscountProductFromCachedProductList,
    this.homePagingResultParameterChecker
  ) {
    _homeListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
      additionalPagingResultParameterChecker: homePagingResultParameterChecker
    );
    _homeListItemPagingControllerState = PagingControllerState(
      pagingController: _homeListItemPagingController,
      isPagingControllerExist: false
    );
    homeListItemPagingControllerStateRx = _homeListItemPagingControllerState.obs;
  }

  @override
  void onInitController() {
    _homeListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _homePageRequestListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _homeListItemPagingControllerState.isPagingControllerExist = true;
    _updatePaymentMethodState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _homePageRequestListener(int pageKey, List<ListItemControllerState>? itemList) async {
    return getProductList.execute(
      ProductListParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'product')).value
    ).map<PagingListResult<ListItemControllerState>>(
      (result) {
        return PagingListResult<ListItemControllerState>(
          itemList: [
            CarouselListItemControllerState(
              item: getMostDiscountProductFromCachedProductList.execute(result, 3),
              title: "Most Discount".tr,
              description: "${"See top 3 most discount".tr}."
            ),
            VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
            TitleAndDescriptionListItemControllerState(
              padding: EdgeInsets.only(
                left: Constant.paddingListItem,
                right: Constant.paddingListItem,
              ),
              title: "Other Product".tr,
              description: "${"Discover our other product in SuperIndo".tr}.",
              verticalSpace: 0.3.h,
            ),
            VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
              childListItemControllerStateList: result.take(4).map<ListItemControllerState>(
                (product) => VerticalProductListItemControllerState(product: product)
              ).toList()
            ),
            WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                child: SizedBox(
                  width: double.infinity,
                  height: 5.h,
                  child: TextButton(
                    onPressed: () => PageRestorationHelper.toProductPage(context),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      foregroundColor: Colors.white,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                    child: Text("More".tr),
                  )
                ),
              ),
            ),
            VirtualSpacingListItemControllerState(
              height: Constant.paddingListItem
            )
          ]
        );
      }
    );
  }

  void _updatePaymentMethodState() {
    homeListItemPagingControllerStateRx.valueFromLast((value) => _homeListItemPagingControllerState.copy());
    update();
  }
}