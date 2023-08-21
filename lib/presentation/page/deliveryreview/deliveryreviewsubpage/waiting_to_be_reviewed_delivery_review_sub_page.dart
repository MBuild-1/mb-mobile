import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../../controller/deliveryreviewcontroller/deliveryreviewsubpagecontroller/waiting_to_be_reviewed_delivery_review_sub_controller.dart';
import '../../../../domain/entity/order/combined_order.dart';
import '../../../../domain/entity/order/order_paging_parameter.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/list_item_controller_state_helper.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../widget/colorful_chip_tab_bar.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../getx_page.dart';

class WaitingToBeReviewedDeliveryReviewSubPage extends DefaultGetxPage {
  late final ControllerMember<WaitingToBeReviewedDeliveryReviewSubController> _waitingToBeReviewedDeliveryReviewSubController;
  final String ancestorPageName;
  final ControllerMember<WaitingToBeReviewedDeliveryReviewSubController> Function() onAddControllerMember;

  WaitingToBeReviewedDeliveryReviewSubPage({
    Key? key,
    required this.ancestorPageName,
    required this.onAddControllerMember
  }) : super(key: key) {
    _waitingToBeReviewedDeliveryReviewSubController = onAddControllerMember();
  }

  @override
  void onSetController() {
    _waitingToBeReviewedDeliveryReviewSubController.controller = Injector.locator<WaitingToBeReviewedDeliveryReviewSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget(
      waitingToBeReviewedDeliveryReviewSubController: _waitingToBeReviewedDeliveryReviewSubController.controller
    );
  }
}

class _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget extends StatefulWidget {
  final WaitingToBeReviewedDeliveryReviewSubController waitingToBeReviewedDeliveryReviewSubController;

  const _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget({
    required this.waitingToBeReviewedDeliveryReviewSubController,
  });

  @override
  State<_StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget> createState() => _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidgetState();
}

class _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidgetState extends State<_StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget> {
  late final ScrollController _orderScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _orderListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _orderListItemPagingControllerState;
  late ColorfulChipTabBarController _orderTabColorfulChipTabBarController;
  late List<ColorfulChipTabBarData> _orderColorfulChipTabBarDataList;

  final String _status = "Sampai Tujuan";

  @override
  void initState() {
    super.initState();
    _orderScrollController = ScrollController();
    _orderListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.waitingToBeReviewedDeliveryReviewSubController.apiRequestManager,
    );
    _orderListItemPagingControllerState = PagingControllerState(
      pagingController: _orderListItemPagingController,
      scrollController: _orderScrollController,
      isPagingControllerExist: false
    );
    _orderListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _orderListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _orderListItemPagingControllerState.isPagingControllerExist = true;
    MainRouteObserver.onRefreshDeliveryReview?.onRefreshWaitingToBeReviewedDeliveryReview = () => _orderListItemPagingController.refresh();
    _orderTabColorfulChipTabBarController = ColorfulChipTabBarController(0);
    _orderColorfulChipTabBarDataList = <ColorfulChipTabBarData>[];
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _orderListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderListItemControllerStateList) async {
    List<ListItemControllerState> resultListItemControllerState = [];
    if (pageKey == 1) {
      resultListItemControllerState = [
        OrderContainerListItemControllerState(
          orderList: [],
          onOrderTap: (order) {},
          onBuyAgainTap: (order) {},
          onUpdateState: () => setState(() {}),
          orderTabColorfulChipTabBarController: _orderTabColorfulChipTabBarController,
          orderColorfulChipTabBarDataList: _orderColorfulChipTabBarDataList
        )
      ];
      return SuccessLoadDataResult<PagingDataResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          itemList: resultListItemControllerState,
          page: 1,
          totalPage: 2,
          totalItem: 0
        )
      );
    } else {
      int effectivePageKey = pageKey - 1;
      LoadDataResult<PagingDataResult<CombinedOrder>> orderPagingLoadDataResult = await widget.waitingToBeReviewedDeliveryReviewSubController.getOrderPaging(
        OrderPagingParameter(page: effectivePageKey, status: _status)
      );
      return orderPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((orderPaging) {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(orderListItemControllerStateList)) {
          OrderContainerListItemControllerState orderContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(orderListItemControllerStateList![0]) as OrderContainerListItemControllerState;
          orderContainerListItemControllerState.orderList.addAll(orderPaging.itemList);
        }
        return PagingDataResult<ListItemControllerState>(
          itemList: resultListItemControllerState,
          page: orderPaging.page,
          totalPage: orderPaging.totalPage,
          totalItem: orderPaging.totalItem
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            pagingControllerState: _orderListItemPagingControllerState,
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