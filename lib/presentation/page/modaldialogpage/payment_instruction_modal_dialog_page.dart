import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/payment_instruction_ext.dart';

import '../../../controller/modaldialogcontroller/payment_instruction_modal_dialog_controller.dart';
import '../../../domain/entity/payment/paymentinstruction/payment_instruction_group.dart';
import '../../../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_divided_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/itemtypelistsubinterceptor/payment_instruction_item_type_list_sub_interceptor.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class PaymentInstructionModalDialogPage extends ModalDialogPage<PaymentInstructionModalDialogController> {
  PaymentInstructionModalDialogController get paymentInstructionModalDialogController => modalDialogController.controller;

  final PaymentInstructionModalDialogPageParameter paymentInstructionModalDialogPageParameter;

  PaymentInstructionModalDialogPage({
    Key? key,
    required this.paymentInstructionModalDialogPageParameter
  }) : super(key: key);

  @override
  PaymentInstructionModalDialogController onCreateModalDialogController() {
    return PaymentInstructionModalDialogController(
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

class _StatefulPaymentInstructionModalDialogControllerMediatorWidget extends StatefulWidget {
  final PaymentInstructionModalDialogController paymentInstructionModalDialogController;
  final PaymentInstructionModalDialogPageParameter paymentInstructionModalDialogPageParameter;

  const _StatefulPaymentInstructionModalDialogControllerMediatorWidget({
    required this.paymentInstructionModalDialogController,
    required this.paymentInstructionModalDialogPageParameter
  });

  @override
  State<_StatefulPaymentInstructionModalDialogControllerMediatorWidget> createState() => _StatefulPaymentInstructionModalDialogControllerMediatorWidgetState();
}

class _StatefulPaymentInstructionModalDialogControllerMediatorWidgetState extends State<_StatefulPaymentInstructionModalDialogControllerMediatorWidget> {
  late final ScrollController _paymentInstructionScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _paymentInstructionListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _paymentInstructionListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _paymentInstructionScrollController = ScrollController();
    _paymentInstructionListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.paymentInstructionModalDialogController.apiRequestManager,
    );
    _paymentInstructionListItemPagingControllerState = PagingControllerState(
      pagingController: _paymentInstructionListItemPagingController,
      scrollController: _paymentInstructionScrollController,
      isPagingControllerExist: false
    );
    _paymentInstructionListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _paymentInstructionListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _paymentInstructionListItemPagingControllerState.isPagingControllerExist = true;
    widget.paymentInstructionModalDialogPageParameter.paymentInstructionModalDialogPageDelegate._onRefresh = () => setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Payment Instruction".tr),
            ],
          ),
          primary: false
        ),
        Flexible(
          child: SizedBox(
            child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              padding: EdgeInsets.zero,
              pagingControllerState: _paymentInstructionListItemPagingControllerState,
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

  @override
  void dispose() {
    widget.paymentInstructionModalDialogPageParameter.paymentInstructionModalDialogPageDelegate._onRefresh = null;
    super.dispose();
  }
}

class PaymentInstructionModalDialogPageParameter {
  PaymentInstructionModalDialogPageDelegate paymentInstructionModalDialogPageDelegate;
  LoadDataResult<PaymentInstructionTransactionSummary> Function() paymentInstructionTransactionSummaryLoadDataResult;
  ErrorProvider Function() onGetErrorProvider;

  PaymentInstructionModalDialogPageParameter({
    required this.paymentInstructionModalDialogPageDelegate,
    required this.paymentInstructionTransactionSummaryLoadDataResult,
    required this.onGetErrorProvider
  });
}

class PaymentInstructionModalDialogPageDelegate {
  void Function()? _onRefresh;

  void Function() get onRefresh => () {
    if (_onRefresh != null) {
      _onRefresh!();
    }
  };
}