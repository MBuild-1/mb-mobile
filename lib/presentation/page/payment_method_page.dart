import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/data/entitymappingext/payment_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/payment_method_controller.dart';
import '../../domain/entity/payment/payment_method.dart';
import '../../domain/entity/payment/payment_method_group.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../../domain/usecase/payment_method_list_use_case.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/paymentmethodlistitemcontrollerstate/payment_method_container_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/response_wrapper.dart';
import '../../misc/string_util.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/colorful_chip_tab_bar.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';

class PaymentMethodPage extends RestorableGetxPage<_PaymentMethodPageRestoration> {
  final String? paymentMethodSettlingId;

  late final ControllerMember<PaymentMethodController> _paymentMethodController = ControllerMember<PaymentMethodController>().addToControllerManager(controllerManager);

  PaymentMethodPage({
    Key? key,
    required this.paymentMethodSettlingId
  }) : super(
    key: key,
    pageRestorationId: () => "payment-method-page"
  );

  @override
  void onSetController() {
    _paymentMethodController.controller = GetExtended.put<PaymentMethodController>(
      PaymentMethodController(
        controllerManager,
        Injector.locator<PaymentMethodListUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _PaymentMethodPageRestoration createPageRestoration() => _PaymentMethodPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulPaymentMethodControllerMediatorWidget(
      paymentMethodController: _paymentMethodController.controller,
      paymentMethodSettlingId: paymentMethodSettlingId,
    );
  }
}

class _PaymentMethodPageRestoration extends ExtendedMixableGetxPageRestoration with PaymentMethodPageRestorationMixin {
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

class PaymentMethodPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String? paymentMethodSettlingId;

  PaymentMethodPageGetPageBuilderAssistant({
    required this.paymentMethodSettlingId
  });

  @override
  GetPageBuilder get pageBuilder => (() => PaymentMethodPage(
    paymentMethodSettlingId: paymentMethodSettlingId
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    PaymentMethodPage(
      paymentMethodSettlingId: paymentMethodSettlingId
    )
  ));
}

mixin PaymentMethodPageRestorationMixin on MixableGetxPageRestoration {
  RouteCompletionCallback<String?>? onCompleteSelectPaymentMethod;

  late PaymentMethodPageRestorableRouteFuture paymentMethodPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    paymentMethodPageRestorableRouteFuture = PaymentMethodPageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('payment-method-route'),
      onComplete: onCompleteSelectPaymentMethod
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    paymentMethodPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    paymentMethodPageRestorableRouteFuture.dispose();
  }
}

class PaymentMethodPageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<String?>? onComplete;

  late RestorableRouteFuture<void> _pageRoute;

  PaymentMethodPageRestorableRouteFuture({
    required String restorationId,
    this.onComplete
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<String?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
      onComplete: onComplete
    );
  }

  static Route<String?>? _getRoute([Object? arguments]) {
    if (arguments is! String?) {
      throw MessageError(message: "Arguments must be a String");
    }
    return GetExtended.toWithGetPageRouteReturnValue<String?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        PaymentMethodPageGetPageBuilderAssistant(
          paymentMethodSettlingId: arguments
        )
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

class _StatefulPaymentMethodControllerMediatorWidget extends StatefulWidget {
  final PaymentMethodController paymentMethodController;
  final String? paymentMethodSettlingId;

  const _StatefulPaymentMethodControllerMediatorWidget({
    required this.paymentMethodController,
    required this.paymentMethodSettlingId
  });

  @override
  State<_StatefulPaymentMethodControllerMediatorWidget> createState() => _StatefulPaymentMethodControllerMediatorWidgetState();
}

class _StatefulPaymentMethodControllerMediatorWidgetState extends State<_StatefulPaymentMethodControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _paymentMethodListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _paymentMethodListItemPagingControllerState;
  PaymentMethod? _selectedPaymentMethod;
  final ColorfulChipTabBarController _paymentMethodColorfulChipTabBarController = ColorfulChipTabBarController(-1);

  @override
  void initState() {
    super.initState();
    _paymentMethodListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.paymentMethodController.apiRequestManager,
    );
    _paymentMethodListItemPagingControllerState = PagingControllerState(
      pagingController: _paymentMethodListItemPagingController,
      isPagingControllerExist: false
    );
    _paymentMethodListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _paymentMethodListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _paymentMethodListItemPagingControllerState.isPagingControllerExist = true;
    _paymentMethodColorfulChipTabBarController.addListener(() {
      setState(() {});
    });
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _paymentMethodListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedPaymentMethod = null;
      setState(() {});
    });
    LoadDataResult<PaymentMethodListResponse> paymentMethodListResponseLoadDataResult = await widget.paymentMethodController.getPaymentMethodList(PaymentMethodListParameter());
    if (paymentMethodListResponseLoadDataResult.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _setSelectedPaymentMethod(paymentMethodListResponseLoadDataResult.resultIfSuccess!.paymentMethodGroupList);
        setState(() {});
      });
    }
    return paymentMethodListResponseLoadDataResult.map<PagingResult<ListItemControllerState>>((paymentMethodListResponse) {
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          PaymentMethodContainerListItemControllerState(
            paymentMethodGroupList: paymentMethodListResponse.paymentMethodGroupList,
            onGetPaymentMethodTabColor: () => Theme.of(context).colorScheme.primary,
            onGetPaymentMethodColorfulChipTabBarController: () => _paymentMethodColorfulChipTabBarController,
            onGetSelectedPaymentMethodSettlingId: () => _selectedPaymentMethod?.settlingId,
            onSelectPaymentMethod: (paymentMethod) => _selectedPaymentMethod = paymentMethod,
            onUpdateState: () => setState(() {}),
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  void _setSelectedPaymentMethod(List<PaymentMethodGroup> paymentMethodGroupList) {
    int i = 0;
    for (PaymentMethodGroup paymentMethodGroup in paymentMethodGroupList) {
      for (PaymentMethod paymentMethod in paymentMethodGroup.paymentMethodList) {
        if (paymentMethod.settlingId == widget.paymentMethodSettlingId) {
          _selectedPaymentMethod = paymentMethod;
          _paymentMethodColorfulChipTabBarController.value = i;
          return;
        }
      }
      i++;
    }
    _paymentMethodColorfulChipTabBarController.value = 0;
  }

  @override
  Widget build(BuildContext context) {
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Select Payment Method".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _paymentMethodListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
            if (_selectedPaymentMethod != null)
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedOutlineGradientButton(
                      onPressed: () => Get.back(
                        result: PaymentMethodPageResponse(
                          paymentMethod: _selectedPaymentMethod!
                        ).toEncodeBase64String()
                      ),
                      text: "Choose Payment Method".tr,
                      outlineGradientButtonType: OutlineGradientButtonType.solid,
                      outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                    )
                  ]
                ),
              )
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class PaymentMethodPageResponse {
  PaymentMethod paymentMethod;

  PaymentMethodPageResponse({
    required this.paymentMethod
  });
}

extension PaymentMethodPageResponseExt on PaymentMethodPageResponse {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    <String, dynamic>{
      "payment_method": {
        "id": paymentMethod.settlingId,
        "payment_group_id": paymentMethod.paymentGroupId,
        "payment_group": paymentMethod.paymentGroup,
        "payment_type": paymentMethod.paymentType,
        "payment_active": paymentMethod.paymentActive,
        "payment_image": paymentMethod.paymentImage,
        "service_fee": paymentMethod.serviceFee,
        "tax_rate": paymentMethod.taxRate
      }
    }
  );
}

extension PaymentMethodPageResponseStringExt on String {
  PaymentMethodPageResponse toPaymentMethodPageResponse() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return PaymentMethodPageResponse(
      paymentMethod: ResponseWrapper(result["payment_method"]).mapFromResponseToPaymentMethod()
    );
  }
}