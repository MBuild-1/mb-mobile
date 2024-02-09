import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/payment_parameter_modal_dialog_controller.dart';
import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/coupon/coupon_detail_parameter.dart';
import '../../../domain/entity/payment/payment_method.dart';
import '../../../domain/usecase/get_coupon_detail_use_case.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/payment_parameter_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class PaymentParameterModalDialogPage extends ModalDialogPage<PaymentParameterModalDialogController> {
  PaymentParameterModalDialogController get paymentParameterModalDialogController => modalDialogController.controller;

  final PaymentParameterModalDialogPageParameter paymentParameterModalDialogPageParameter;

  PaymentParameterModalDialogPage({
    Key? key,
    required this.paymentParameterModalDialogPageParameter
  }) : super(key: key);

  @override
  PaymentParameterModalDialogController onCreateModalDialogController() {
    return PaymentParameterModalDialogController(
      controllerManager,
      Injector.locator<GetCouponDetailUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulPaymentParameterModalDialogControllerMediatorWidget(
      paymentParameterModalDialogController: paymentParameterModalDialogController,
      paymentParameterModalDialogPageParameter: paymentParameterModalDialogPageParameter,
    );
  }
}

class _StatefulPaymentParameterModalDialogControllerMediatorWidget extends StatefulWidget {
  final PaymentParameterModalDialogController paymentParameterModalDialogController;
  final PaymentParameterModalDialogPageParameter paymentParameterModalDialogPageParameter;

  const _StatefulPaymentParameterModalDialogControllerMediatorWidget({
    required this.paymentParameterModalDialogController,
    required this.paymentParameterModalDialogPageParameter
  });

  @override
  State<_StatefulPaymentParameterModalDialogControllerMediatorWidget> createState() => _StatefulPaymentParameterModalDialogControllerMediatorWidgetState();
}

class _StatefulPaymentParameterModalDialogControllerMediatorWidgetState extends State<_StatefulPaymentParameterModalDialogControllerMediatorWidget> {
  late final ScrollController _paymentParameterScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _paymentParameterListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _paymentParameterListItemPagingControllerState;

  PaymentMethod? _paymentMethod;
  LoadDataResult<Coupon> _couponLoadDataResult = NoLoadDataResult<Coupon>();

  @override
  void initState() {
    super.initState();
    _paymentParameterScrollController = ScrollController();
    _paymentParameterListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.paymentParameterModalDialogController.apiRequestManager,
    );
    _paymentParameterListItemPagingControllerState = PagingControllerState(
      pagingController: _paymentParameterListItemPagingController,
      scrollController: _paymentParameterScrollController,
      isPagingControllerExist: false
    );
    _paymentParameterListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _paymentInstructionListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _paymentParameterListItemPagingControllerState.isPagingControllerExist = true;
    PaymentParameterModalDialogPageDelegate paymentParameterModalDialogPageDelegate = widget.paymentParameterModalDialogPageParameter.paymentParameterModalDialogPageDelegate;
    paymentParameterModalDialogPageDelegate._onUpdatePaymentMethod = (paymentMethod) {
      _paymentMethod = paymentMethod;
      setState(() {});
    };
    paymentParameterModalDialogPageDelegate._onUpdateCoupon = (couponId) async {
      _getCouponDetail(couponId);
    };
  }

  void _getCouponDetail(String couponId) async {
    _couponLoadDataResult = IsLoadingLoadDataResult<Coupon>();
    setState(() {});
    _couponLoadDataResult = await widget.paymentParameterModalDialogController.getCouponDetail(
      CouponDetailParameter(
        couponId: couponId
      )
    );
    setState(() {});
    if (_couponLoadDataResult.isFailedBecauseCancellation) {
      return;
    }
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _paymentInstructionListItemPagingControllerStateListener(int pageKey) async {
    return SuccessLoadDataResult(
      value: PagingDataResult<ListItemControllerState>(
        itemList: <ListItemControllerState>[
          PaymentParameterListItemControllerState(
            onGetPaymentMethod: () => _paymentMethod,
            onGetCouponLoadDataResult: () => _couponLoadDataResult,
            onSetCouponLoadDataResult: (value) => _couponLoadDataResult = value,
            onSelectPaymentMethod: () {
              widget.paymentParameterModalDialogPageParameter.onGotoSelectPaymentMethodPage(_paymentMethod?.settlingId);
            },
            onRemovePaymentMethod: () {
              setState(() => _paymentMethod = null);
            },
            onSelectCoupon: () {
              String? couponLoadDataResultId = _couponLoadDataResult.resultIfSuccess?.id;
              widget.paymentParameterModalDialogPageParameter.onGotoSelectCouponPage(couponLoadDataResultId);
            },
            onRemoveCoupon: () {
              setState(() => _couponLoadDataResult = NoLoadDataResult<Coupon>());
            },
            errorProvider: () => Injector.locator(),
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
    PaymentParameterModalDialogPageParameter paymentParameterModalDialogPageParameter = widget.paymentParameterModalDialogPageParameter;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text(paymentParameterModalDialogPageParameter.titleLabel()),
            ],
          ),
          primary: false
        ),
        Flexible(
          child: SizedBox(
            child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              padding: EdgeInsets.zero,
              pagingControllerState: _paymentParameterListItemPagingControllerState,
              onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                pagingControllerState: pagingControllerState!
              ),
              shrinkWrap: true
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedOutlineGradientButton(
            onPressed: _paymentMethod == null ? null : (
              !(_couponLoadDataResult.isSuccess || _couponLoadDataResult.isNotLoading) ? null : () {
                widget.paymentParameterModalDialogPageParameter.onProcessPaymentParameter(
                  _paymentMethod!.settlingId, _couponLoadDataResult.resultIfSuccess?.id
                );
              }
            ),
            text: paymentParameterModalDialogPageParameter.buttonLabel(),
            outlineGradientButtonType: OutlineGradientButtonType.solid,
            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
          ),
        )
      ]
    );
  }
}

class PaymentParameterModalDialogPageParameter {
  PaymentParameterModalDialogPageDelegate paymentParameterModalDialogPageDelegate;
  void Function(String? paymentMethodSettlingId) onGotoSelectPaymentMethodPage;
  void Function(String? couponId) onGotoSelectCouponPage;
  void Function(String? paymentMethodSettlingId, String? couponId) onProcessPaymentParameter;
  String Function() titleLabel;
  String Function() buttonLabel;

  PaymentParameterModalDialogPageParameter({
    required this.paymentParameterModalDialogPageDelegate,
    required this.onGotoSelectPaymentMethodPage,
    required this.onGotoSelectCouponPage,
    required this.onProcessPaymentParameter,
    required this.titleLabel,
    required this.buttonLabel
  });
}

class PaymentParameterModalDialogPageDelegate {
  void Function(PaymentMethod)? _onUpdatePaymentMethod;
  void Function(PaymentMethod) get onUpdatePaymentMethod => (paymentMethod) {
    if (_onUpdatePaymentMethod != null) {
      _onUpdatePaymentMethod!(paymentMethod);
    }
  };

  void Function(String)? _onUpdateCoupon;
  void Function(String) get onUpdateCoupon => (couponId) {
    if (_onUpdateCoupon != null) {
      _onUpdateCoupon!(couponId);
    }
  };
}