import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/purchase_direct_modal_dialog_controller.dart';
import '../../../domain/entity/coupon/coupon.dart';
import '../../../domain/entity/coupon/coupon_detail_parameter.dart';
import '../../../domain/entity/payment/payment_method.dart';
import '../../../domain/usecase/get_coupon_detail_use_case.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/purchase_direct_list_item_controller_state.dart';
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

class PurchaseDirectModalDialogPage extends ModalDialogPage<PurchaseDirectModalDialogController> {
  PurchaseDirectModalDialogController get purchaseDirectModalDialogController => modalDialogController.controller;

  final PurchaseDirectModalDialogPageParameter purchaseDirectModalDialogPageParameter;

  PurchaseDirectModalDialogPage({
    Key? key,
    required this.purchaseDirectModalDialogPageParameter
  }) : super(key: key);

  @override
  PurchaseDirectModalDialogController onCreateModalDialogController() {
    return PurchaseDirectModalDialogController(
      controllerManager,
      Injector.locator<GetCouponDetailUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulPurchaseDirectModalDialogControllerMediatorWidget(
      purchaseDirectModalDialogController: purchaseDirectModalDialogController,
      purchaseDirectModalDialogPageParameter: purchaseDirectModalDialogPageParameter,
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

  PaymentMethod? _paymentMethod;
  LoadDataResult<Coupon> _couponLoadDataResult = NoLoadDataResult<Coupon>();

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
    PurchaseDirectModalDialogPageDelegate purchaseDirectModalDialogPageDelegate = widget.purchaseDirectModalDialogPageParameter.purchaseDirectModalDialogPageDelegate;
    purchaseDirectModalDialogPageDelegate._onUpdatePaymentMethod = (paymentMethod) {
      _paymentMethod = paymentMethod;
      setState(() {});
    };
    purchaseDirectModalDialogPageDelegate._onUpdateCoupon = (couponId) async {
      _getCouponDetail(couponId);
    };
  }

  void _getCouponDetail(String couponId) async {
    _couponLoadDataResult = IsLoadingLoadDataResult<Coupon>();
    setState(() {});
    _couponLoadDataResult = await widget.purchaseDirectModalDialogController.getCouponDetail(
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
          PurchaseDirectListItemControllerState(
            onGetPaymentMethod: () => _paymentMethod,
            onGetCouponLoadDataResult: () => _couponLoadDataResult,
            onSetCouponLoadDataResult: (value) => _couponLoadDataResult = value,
            onSelectPaymentMethod: () {
              widget.purchaseDirectModalDialogPageParameter.onGotoSelectPaymentMethodPage(_paymentMethod?.settlingId);
            },
            onRemovePaymentMethod: () {
              setState(() => _paymentMethod = null);
            },
            onSelectCoupon: () {
              String? couponLoadDataResultId = _couponLoadDataResult.resultIfSuccess?.id;
              widget.purchaseDirectModalDialogPageParameter.onGotoSelectCouponPage(couponLoadDataResultId);
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Buy Directly".tr),
            ],
          ),
          primary: false
        ),
        Flexible(
          child: SizedBox(
            child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              padding: EdgeInsets.zero,
              pagingControllerState: _purchaseDirectListItemPagingControllerState,
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
                widget.purchaseDirectModalDialogPageParameter.onProcessPurchaseDirect(
                  _paymentMethod!.settlingId, _couponLoadDataResult.resultIfSuccess?.id
                );
              }
            ),
            text: "Buy Directly".tr,
            outlineGradientButtonType: OutlineGradientButtonType.solid,
            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
          ),
        )
      ]
    );
  }
}

class PurchaseDirectModalDialogPageParameter {
  PurchaseDirectModalDialogPageDelegate purchaseDirectModalDialogPageDelegate;
  void Function(String? paymentMethodSettlingId) onGotoSelectPaymentMethodPage;
  void Function(String? couponId) onGotoSelectCouponPage;
  void Function(String? paymentMethodSettlingId, String? couponId) onProcessPurchaseDirect;

  PurchaseDirectModalDialogPageParameter({
    required this.purchaseDirectModalDialogPageDelegate,
    required this.onGotoSelectPaymentMethodPage,
    required this.onGotoSelectCouponPage,
    required this.onProcessPurchaseDirect
  });
}

class PurchaseDirectModalDialogPageDelegate {
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