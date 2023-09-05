import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../../controller/deliveryreviewcontroller/deliveryreviewsubpagecontroller/waiting_to_be_reviewed_delivery_review_sub_controller.dart';
import '../../../../domain/entity/order/combined_order.dart';
import '../../../../domain/entity/order/order_paging_parameter.dart';
import '../../../../domain/entity/order/shipping_review_order_list_parameter.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_container_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/itemtypelistsubinterceptor/order_item_type_list_sub_interceptor.dart';
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
  final void Function(CombinedOrder) onBuyAgainTap;

  WaitingToBeReviewedDeliveryReviewSubPage({
    Key? key,
    required this.ancestorPageName,
    required this.onAddControllerMember,
    required this.onBuyAgainTap
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
      waitingToBeReviewedDeliveryReviewSubController: _waitingToBeReviewedDeliveryReviewSubController.controller,
      onBuyAgainTap: onBuyAgainTap
    );
  }
}

class _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget extends StatefulWidget {
  final WaitingToBeReviewedDeliveryReviewSubController waitingToBeReviewedDeliveryReviewSubController;
  final void Function(CombinedOrder) onBuyAgainTap;

  const _StatefulWaitingToBeReviewedDeliveryReviewSubControllerMediatorWidget({
    required this.waitingToBeReviewedDeliveryReviewSubController,
    required this.onBuyAgainTap
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

  final DefaultOrderContainerInterceptingActionListItemControllerState _defaultOrderContainerInterceptingActionListItemControllerState = DefaultOrderContainerInterceptingActionListItemControllerState();

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
          onBuyAgainTap: widget.onBuyAgainTap,
          onUpdateState: () => setState(() {}),
          orderTabColorfulChipTabBarController: _orderTabColorfulChipTabBarController,
          orderColorfulChipTabBarDataList: _orderColorfulChipTabBarDataList,
          errorProvider: Injector.locator<ErrorProvider>(),
          orderContainerStateStorageListItemControllerState: DefaultOrderContainerStateStorageListItemControllerState(),
          orderContainerInterceptingActionListItemControllerState: _defaultOrderContainerInterceptingActionListItemControllerState
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
      _updateOrderList(NoLoadDataResult());
      LoadDataResult<List<CombinedOrder>> orderListLoadDataResult = await widget.waitingToBeReviewedDeliveryReviewSubController.getShippingReviewOrderList(
        ShippingReviewOrderListParameter()
      );
      _updateOrderList(orderListLoadDataResult);
      return orderListLoadDataResult.map<PagingResult<ListItemControllerState>>((orderList) {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(orderListItemControllerStateList)) {
          OrderContainerListItemControllerState orderContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(orderListItemControllerStateList![0]) as OrderContainerListItemControllerState;
          orderContainerListItemControllerState.orderList.addAll(orderList);
        }
        return PagingDataResult<ListItemControllerState>(
          itemList: resultListItemControllerState,
          page: 2,
          totalPage: 2,
          totalItem: orderList.length
        );
      });
    }
  }

  void _updateOrderList(LoadDataResult<List<CombinedOrder>> combinedOrderListDataResult) {
    if (_defaultOrderContainerInterceptingActionListItemControllerState.onRefreshCombinedOrderPagingDataResult != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _defaultOrderContainerInterceptingActionListItemControllerState.onRefreshCombinedOrderPagingDataResult!(
          combinedOrderListDataResult.map<PagingDataResult<CombinedOrder>>(
            (value) => PagingDataResult<CombinedOrder>(
              page: 1,
              totalPage: 1,
              totalItem: value.length,
              itemList: value
            )
          )
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