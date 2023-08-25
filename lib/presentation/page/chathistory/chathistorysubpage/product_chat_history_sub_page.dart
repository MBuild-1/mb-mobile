import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../controller/chathistorycontroller/chathistorysubpagecontroller/product_chat_history_sub_controller.dart';
import '../../../../domain/entity/chat/product/get_product_message_by_user_parameter.dart';
import '../../../../domain/entity/chat/product/get_product_message_by_user_response.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/chathistorylistitemcontrollerstate/product_chat_history_list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/page_restoration_helper.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../getx_page.dart';

class ProductChatHistorySubPage extends DefaultGetxPage {
  late final ControllerMember<ProductChatHistorySubController> _productChatHistorySubController;
  final String ancestorPageName;
  final ControllerMember<ProductChatHistorySubController> Function() onAddControllerMember;

  ProductChatHistorySubPage({
    Key? key,
    required this.ancestorPageName,
    required this.onAddControllerMember
  }) : super(key: key) {
    _productChatHistorySubController = onAddControllerMember();
  }

  @override
  void onSetController() {
    _productChatHistorySubController.controller = Injector.locator<ProductChatHistorySubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulProductChatHistorySubControllerMediatorWidget(
      productChatHistorySubController: _productChatHistorySubController.controller
    );
  }
}

class _StatefulProductChatHistorySubControllerMediatorWidget extends StatefulWidget {
  final ProductChatHistorySubController productChatHistorySubController;

  const _StatefulProductChatHistorySubControllerMediatorWidget({
    required this.productChatHistorySubController
  });

  @override
  State<_StatefulProductChatHistorySubControllerMediatorWidget> createState() => _StatefulProductChatHistorySubControllerMediatorWidgetState();
}

class _StatefulProductChatHistorySubControllerMediatorWidgetState extends State<_StatefulProductChatHistorySubControllerMediatorWidget> {
  late final ScrollController _productChatHistorySubScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _productChatHistorySubListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productChatHistorySubListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _productChatHistorySubScrollController = ScrollController();
    _productChatHistorySubListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productChatHistorySubController.apiRequestManager,
    );
    _productChatHistorySubListItemPagingControllerState = PagingControllerState(
      pagingController: _productChatHistorySubListItemPagingController,
      scrollController: _productChatHistorySubScrollController,
      isPagingControllerExist: false
    );
    _productChatHistorySubListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _productChatHistorySubListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productChatHistorySubListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _productChatHistorySubListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? productListItemControllerStateList) async {
    LoadDataResult<GetProductMessageByUserResponse> getOrderMessageByUserResponseLoadDataResult = await widget.productChatHistorySubController.getProductMessageByUserResponse(
      GetProductMessageByUserParameter()
    );
    return getOrderMessageByUserResponseLoadDataResult.map<PagingResult<ListItemControllerState>>((getProductMessageByUserResponse) {
      List<ListItemControllerState> resultListItemControllerState = [
        ...getProductMessageByUserResponse.getProductMessageByUserResponseMemberList.map<ProductChatHistoryListItemControllerState>(
          (value) => ProductChatHistoryListItemControllerState(
            getProductMessageByUserResponseMember: value,
            onTap: (getProductMessageByUserResponse) {
              print("HAAAA");
              print(getProductMessageByUserResponse.id);
              PageRestorationHelper.toProductChatPage(
                getProductMessageByUserResponse.productId.toEmptyStringNonNull, context
              );
            }
          )
        )
      ];
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            pagingControllerState: _productChatHistorySubListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            pullToRefresh: true
          ),
        ),
      ]
    );
  }
}