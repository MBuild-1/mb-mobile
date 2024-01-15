import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/payment_instruction_ext.dart';

import '../../controller/payment_instruction_controller.dart';
import '../../domain/usecase/payment_instruction_use_case.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_divided_container_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/payment_instruction_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/temp_payment_instruction_data_helper.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';

class PaymentInstructionPage extends RestorableGetxPage<_PaymentInstructionPageRestoration> {
  late final ControllerMember<PaymentInstructionController> _paymentInstructionController = ControllerMember<PaymentInstructionController>().addToControllerManager(controllerManager);

  PaymentInstructionPage({Key? key}) : super(
    key: key,
    pageRestorationId: () => "payment-instruction-page"
  );

  @override
  void onSetController() {
    _paymentInstructionController.controller = GetExtended.put<PaymentInstructionController>(
      PaymentInstructionController(
        controllerManager,
        Injector.locator<PaymentInstructionUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _PaymentInstructionPageRestoration createPageRestoration() => _PaymentInstructionPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulPaymentInstructionControllerMediatorWidget(
        paymentInstructionController: _paymentInstructionController.controller
      ),
    );
  }
}

class _PaymentInstructionPageRestoration extends ExtendedMixableGetxPageRestoration with PaymentInstructionPageRestorationMixin {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class PaymentInstructionPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => () => PaymentInstructionPage();

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    PaymentInstructionPage()
  ));
}

mixin PaymentInstructionPageRestorationMixin on MixableGetxPageRestoration {
  late PaymentInstructionPageRestorableRouteFuture paymentInstructionPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    paymentInstructionPageRestorableRouteFuture = PaymentInstructionPageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('payment-instruction-route')
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    paymentInstructionPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    paymentInstructionPageRestorableRouteFuture.dispose();
  }
}

class PaymentInstructionPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  PaymentInstructionPageRestorableRouteFuture({
    required String restorationId
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<String?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      }
    );
  }

  static Route<String?>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<String?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        PaymentInstructionPageGetPageBuilderAssistant()
      ),
    );
  }

  @pragma('vm:entry-point')
  static Route<String?> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulPaymentInstructionControllerMediatorWidget extends StatefulWidget {
  final PaymentInstructionController paymentInstructionController;

  const _StatefulPaymentInstructionControllerMediatorWidget({
    required this.paymentInstructionController
  });

  @override
  State<_StatefulPaymentInstructionControllerMediatorWidget> createState() => _StatefulPaymentInstructionControllerMediatorWidgetState();
}

class _StatefulPaymentInstructionControllerMediatorWidgetState extends State<_StatefulPaymentInstructionControllerMediatorWidget> {
  late final ScrollController _paymentInstructionScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _paymentInstructionListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _paymentInstructionListItemPagingControllerState;
  late PaymentInstructionResponseStateValue _paymentInstructionResponseStateValue;

  @override
  void initState() {
    super.initState();
    _paymentInstructionScrollController = ScrollController();
    _paymentInstructionListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.paymentInstructionController.apiRequestManager,
    );
    _paymentInstructionListItemPagingControllerState = PagingControllerState(
      pagingController: _paymentInstructionListItemPagingController,
      scrollController: _paymentInstructionScrollController,
      isPagingControllerExist: false
    );
    _paymentInstructionListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _paymentInstructionListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _paymentInstructionListItemPagingControllerState.isPagingControllerExist = true;
    _paymentInstructionResponseStateValue = TempPaymentInstructionDataHelper.getTempPaymentInstruction()
      .result
      .toPaymentInstructionResponseFromJsonString()
      .toPaymentInstructionResponseStateValue();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _paymentInstructionListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderDetailListItemControllerStateList) async {
    return SuccessLoadDataResult(
      value: PagingDataResult<ListItemControllerState>(
        itemList: <ListItemControllerState>[
          PaymentInstructionContainerListItemControllerState(
            paymentInstructionResponseStateValue: () => _paymentInstructionResponseStateValue,
            paymentInstructionContainerStorageListItemControllerState: DefaultPaymentInstructionContainerStorageListItemControllerState(),
            onUpdateState: () => setState(() {})
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
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Payment Instruction".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _paymentInstructionListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
          ]
        )
      ),
    );
  }
}