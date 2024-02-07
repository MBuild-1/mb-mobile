import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../../controller/chathistorycontroller/chathistorysubpagecontroller/order_chat_history_sub_controller.dart';
import '../../../../domain/entity/chat/order/get_order_message_by_user_parameter.dart';
import '../../../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/chathistorylistitemcontrollerstate/order_chat_history_list_item_controller_state.dart';
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

class OrderChatHistorySubPage extends DefaultGetxPage {
  late final ControllerMember<OrderChatHistorySubController> _orderChatHistorySubController;
  final String ancestorPageName;
  final ControllerMember<OrderChatHistorySubController> Function() onAddControllerMember;

  OrderChatHistorySubPage({
    Key? key,
    required this.ancestorPageName,
    required this.onAddControllerMember
  }) : super(key: key) {
    _orderChatHistorySubController = onAddControllerMember();
  }

  @override
  void onSetController() {
    _orderChatHistorySubController.controller = Injector.locator<OrderChatHistorySubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulOrderChatHistorySubControllerMediatorWidget(
      orderChatHistorySubController: _orderChatHistorySubController.controller
    );
  }
}

class _StatefulOrderChatHistorySubControllerMediatorWidget extends StatefulWidget {
  final OrderChatHistorySubController orderChatHistorySubController;

  const _StatefulOrderChatHistorySubControllerMediatorWidget({
    required this.orderChatHistorySubController
  });

  @override
  State<_StatefulOrderChatHistorySubControllerMediatorWidget> createState() => _StatefulOrderChatHistorySubControllerMediatorWidgetState();
}

class _StatefulOrderChatHistorySubControllerMediatorWidgetState extends State<_StatefulOrderChatHistorySubControllerMediatorWidget> {
  late final ScrollController _orderChatHistorySubScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _orderChatHistorySubListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _orderChatHistorySubListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _orderChatHistorySubScrollController = ScrollController();
    _orderChatHistorySubListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.orderChatHistorySubController.apiRequestManager,
    );
    _orderChatHistorySubListItemPagingControllerState = PagingControllerState(
      pagingController: _orderChatHistorySubListItemPagingController,
      scrollController: _orderChatHistorySubScrollController,
      isPagingControllerExist: false
    );
    _orderChatHistorySubListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _orderChatHistorySubListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _orderChatHistorySubListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _orderChatHistorySubListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderListItemControllerStateList) async {
    LoadDataResult<GetOrderMessageByUserResponse> getOrderMessageByUserResponseLoadDataResult = await widget.orderChatHistorySubController.getOrderMessageByUserResponse(
      GetOrderMessageByUserParameter()
    );
    return getOrderMessageByUserResponseLoadDataResult.map<PagingResult<ListItemControllerState>>((getOrderMessageByUserResponse) {
      List<ListItemControllerState> resultListItemControllerState = [
        ...getOrderMessageByUserResponse.getOrderMessageByUserResponseMemberList.map<OrderChatHistoryListItemControllerState>(
          (value) => OrderChatHistoryListItemControllerState(
            getOrderMessageByUserResponseMember: value,
            onTap: (getOrderMessageByUserResponse) => PageRestorationHelper.toOrderChatPage(
              getOrderMessageByUserResponse.order.id, context
            )
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
            pagingControllerState: _orderChatHistorySubListItemPagingControllerState,
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