import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/order_tracking_modal_dialog_controller.dart';
import '../../../domain/entity/order/ordertracking/order_tracking.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/orderlistitemcontrollerstate/order_tracking_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class OrderTrackingModalDialogPage extends ModalDialogPage<OrderTrackingModalDialogController> {
  OrderTrackingModalDialogController get orderTrackingModalDialogController => modalDialogController.controller;

  final OrderTrackingModalDialogPageParameter orderTrackingModalDialogPageParameter;

  OrderTrackingModalDialogPage({
    Key? key,
    required this.orderTrackingModalDialogPageParameter
  }) : super(key: key);

  @override
  OrderTrackingModalDialogController onCreateModalDialogController() {
    return OrderTrackingModalDialogController(
      controllerManager
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulOrderTrackingModalDialogControllerMediatorWidget(
      orderTrackingModalDialogController: orderTrackingModalDialogController,
      orderTrackingModalDialogPageParameter: orderTrackingModalDialogPageParameter
    );
  }
}

class _StatefulOrderTrackingModalDialogControllerMediatorWidget extends StatefulWidget {
  final OrderTrackingModalDialogController orderTrackingModalDialogController;
  final OrderTrackingModalDialogPageParameter orderTrackingModalDialogPageParameter;

  const _StatefulOrderTrackingModalDialogControllerMediatorWidget({
    required this.orderTrackingModalDialogController,
    required this.orderTrackingModalDialogPageParameter
  });

  @override
  State<_StatefulOrderTrackingModalDialogControllerMediatorWidget> createState() => _StatefulOrderTrackingModalDialogControllerMediatorWidgetState();
}

class _StatefulOrderTrackingModalDialogControllerMediatorWidgetState extends State<_StatefulOrderTrackingModalDialogControllerMediatorWidget> {
  late final ScrollController _orderTrackingScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _orderTrackingListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _orderTrackingListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _orderTrackingScrollController = ScrollController();
    _orderTrackingListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.orderTrackingModalDialogController.apiRequestManager,
    );
    _orderTrackingListItemPagingControllerState = PagingControllerState(
      pagingController: _orderTrackingListItemPagingController,
      scrollController: _orderTrackingScrollController,
      isPagingControllerExist: false
    );
    _orderTrackingListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _orderTrackingListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _orderTrackingListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _orderTrackingListItemPagingControllerStateListener(int pageKey) async {
    return SuccessLoadDataResult(
      value: PagingDataResult<ListItemControllerState>(
        itemList: <ListItemControllerState>[
          OrderTrackingListItemControllerState(
            orderTrackingList: widget.orderTrackingModalDialogPageParameter.orderTrackingList,
            errorProvider: () => Injector.locator<ErrorProvider>()
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Order Tracking".tr),
            ],
          ),
          primary: false
        ),
        Flexible(
          child: SizedBox(
            child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              padding: EdgeInsets.zero,
              pagingControllerState: _orderTrackingListItemPagingControllerState,
              onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                pagingControllerState: pagingControllerState!
              ),
              shrinkWrap: true
            ),
          ),
        )
      ]
    );
  }
}

class OrderTrackingModalDialogPageParameter {
  List<OrderTracking> orderTrackingList;

  OrderTrackingModalDialogPageParameter({
    required this.orderTrackingList
  });
}