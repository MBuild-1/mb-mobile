import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/purchase_direct_modal_dialog_controller.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import 'modal_dialog_page.dart';

class PurchaseDirectModalDialogPage extends ModalDialogPage<PurchaseDirectModalDialogController> {
  PurchaseDirectModalDialogController get purchaseDirectModalDialogController => modalDialogController.controller;

  final PurchaseDirectModalDialogPageParameter purchaseDirectModalDialogPageParameter;

  PurchaseDirectModalDialogPage({
    Key? key,
    required this.purchaseDirectModalDialogController
  }) : super(key: key);

  @override
  PurchaseDirectModalDialogController onCreateModalDialogController() {
    return PurchaseDirectModalDialogController(
      controllerManager
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulPaymentInstructionModalDialogControllerMediatorWidget(
      paymentInstructionModalDialogController: paymentInstructionModalDialogController,
      paymentInstructionModalDialogPageParameter: paymentInstructionModalDialogPageParameter
    );
  }
}

class _StatefulPurchaseDirectModalDialogControllerMediatorWidget extends StatefulWidget {
  final PurchaseDirectModalDialogController purchaseDirectModalDialogController;
  final PurchaseDirectModalDialogPageParameter purchaseDirectModalDialogPageParameter;

  const _StatefulPurchaseDirectModalDialogControllerMediatorWidget({
    required this.purchaseDirectModalDialogController,
    required this.purchaseDirectModalDialogPageParameter
  });

  @override
  State<_StatefulPurchaseDirectModalDialogControllerMediatorWidget> createState() => _StatefulPurchaseDirectModalDialogControllerMediatorWidgetState();
}

class _StatefulPurchaseDirectModalDialogControllerMediatorWidgetState extends State<_StatefulPurchaseDirectModalDialogControllerMediatorWidget> {
  late final ScrollController _purchaseDirectScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _purchaseDirectListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _purchaseDirectListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _purchaseDirectScrollController = ScrollController();
    _purchaseDirectListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.purchaseDirectModalDialogController.apiRequestManager,
    );
    _purchaseDirectListItemPagingControllerState = PagingControllerState(
      pagingController: _purchaseDirectListItemPagingController,
      scrollController: _purchaseDirectScrollController,
      isPagingControllerExist: false
    );
    _purchaseDirectListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _paymentInstructionListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _purchaseDirectListItemPagingControllerState.isPagingControllerExist = true;
    widget.purchaseDirectModalDialogController.paymentInstructionModalDialogPageDelegate._onRefresh = () => setState(() {});
    widget.purchaseDirectModalDialogController.paymentInstructionModalDialogPageDelegate._onSuccess = () => Get.back();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _paymentInstructionListItemPagingControllerStateListener(int pageKey) async {
    return SuccessLoadDataResult(
      value: PagingDataResult<ListItemControllerState>(
        itemList: <ListItemControllerState>[
          PaymentInstructionDividedContainerListItemControllerState(
            paymentInstructionTransactionSummaryLoadDataResult: widget.paymentInstructionModalDialogPageParameter.paymentInstructionTransactionSummaryLoadDataResult,
            paymentInstructionContainerStorageListItemControllerState: DefaultPaymentInstructionContainerStorageListItemControllerState(),
            onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
            onUpdateState: () => setState(() {}),
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      )
    );
  }
}

class PurchaseDirectModalDialogPageParameter {

}