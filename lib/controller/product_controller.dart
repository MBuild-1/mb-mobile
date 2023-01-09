import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../domain/entity/product_list_parameter.dart';
import '../domain/usecase/get_product_detail.dart';
import '../domain/usecase/get_product_list.dart';
import '../misc/additionalloadingindicatorchecker/product_paging_result_parameter_checker.dart';
import '../misc/canceltokenmapkey/page_and_string_cancel_token_map_key.dart';
import '../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../misc/controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../misc/controllerstate/paging_controller_state.dart';
import '../misc/itemtypelistsubinterceptor/verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/modified_paging_controller.dart';
import '../misc/paging/pagingresult/paging_list_result.dart';
import '../misc/paging/pagingresult/paging_result.dart';
import 'base_getx_controller.dart';

class ProductController extends BaseGetxController {
  final GetProductDetail getProductDetail;
  final GetProductList getProductList;
  final ProductPagingResultParameterChecker productPagingResultParameterChecker;

  late final ModifiedPagingController<int, ListItemControllerState> _productListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productListItemPagingControllerState;
  late final Rx<PagingControllerState<int, ListItemControllerState>> productListItemPagingControllerStateRx;

  ProductController(
    super.controllerManager,
    this.getProductDetail,
    this.getProductList,
    this.productPagingResultParameterChecker
  ) {
    _productListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      apiRequestManager: apiRequestManager,
      additionalPagingResultParameterChecker: productPagingResultParameterChecker
    );
    _productListItemPagingControllerState = PagingControllerState(
      pagingController: _productListItemPagingController,
      isPagingControllerExist: false
    );
    productListItemPagingControllerStateRx = _productListItemPagingControllerState.obs;
  }

  @override
  void onInitController() {
    _productListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _homePageRequestListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productListItemPagingControllerState.isPagingControllerExist = true;
    _updatePaymentMethodState();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _homePageRequestListener(int pageKey, List<ListItemControllerState>? itemList) async {
    LoadDataResult<List<ListItemControllerState>> productList = await getProductList.execute(
      ProductListParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPartWithStringKey(PageAndStringCancelTokenMapKey(page: pageKey, key: 'product')).value
    ).map<List<ListItemControllerState>>(
      (result) {
        List<ListItemControllerState> listItemControllerStateList = result.map<ListItemControllerState>(
          (value) => VerticalProductListItemControllerState(product: value)
        ).toList();
        return listItemControllerStateList;
      }
    );
    return productList.map<PagingListResult<ListItemControllerState>>((result) => PagingListResult<ListItemControllerState>(
      itemList: [
        VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
          childListItemControllerStateList: result,
          verticalGridPaddingContentSubInterceptorSupportParameter: VerticalGridPaddingContentSubInterceptorSupportParameter()
        )
      ]
    ));
  }

  void _updatePaymentMethodState() {
    productListItemPagingControllerStateRx.valueFromLast((value) => _productListItemPagingControllerState.copy());
    update();
  }
}