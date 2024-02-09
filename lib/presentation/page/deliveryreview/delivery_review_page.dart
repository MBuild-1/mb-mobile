import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/deliveryreviewcontroller/delivery_review_controller.dart';
import '../../../../misc/getextended/get_extended.dart';
import '../../../../misc/getextended/get_restorable_route_future.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../controller/deliveryreviewcontroller/deliveryreviewsubpagecontroller/history_delivery_review_sub_controller.dart';
import '../../../controller/deliveryreviewcontroller/deliveryreviewsubpagecontroller/waiting_to_be_reviewed_delivery_review_sub_controller.dart';
import '../../../domain/entity/payment/payment_method.dart';
import '../../../misc/controllercontentdelegate/repurchase_controller_content_delegate.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/main_route_observer.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/refresh_delivery_review.dart';
import '../../widget/modified_scaffold.dart';
import '../../widget/modified_tab_bar.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../country_delivery_review_page.dart';
import '../coupon_page.dart';
import '../getx_page.dart';
import '../modaldialogpage/payment_parameter_modal_dialog_page.dart';
import '../order_detail_page.dart';
import '../payment_method_page.dart';
import 'deliveryreviewsubpage/history_delivery_review_sub_page.dart';
import 'deliveryreviewsubpage/waiting_to_be_reviewed_delivery_review_sub_page.dart';

class DeliveryReviewPage extends RestorableGetxPage<_DeliveryReviewPageRestoration> {
  late final ControllerMember<DeliveryReviewController> _deliveryReviewController = ControllerMember<DeliveryReviewController>().addToControllerManager(controllerManager);
  late final List<List<dynamic>> _deliveryReviewSubControllerList;
  final _StatefulDeliveryReviewControllerMediatorWidgetDelegate _statefulDeliveryReviewControllerMediatorWidgetDelegate = _StatefulDeliveryReviewControllerMediatorWidgetDelegate();

  DeliveryReviewPage({Key? key}) : super(key: key, pageRestorationId: () => "delivery-review-page") {
    _deliveryReviewSubControllerList = [
      [
        null,
        () => ControllerMember<WaitingToBeReviewedDeliveryReviewSubController>().addToControllerManager(controllerManager),
        null
      ],
      [
        null,
        () => ControllerMember<HistoryDeliveryReviewSubController>().addToControllerManager(controllerManager),
        null
      ],
    ];
    _deliveryReviewSubControllerList[0][2] = () {
      if (_deliveryReviewSubControllerList[0][0] == null) {
        _deliveryReviewSubControllerList[0][0] = _deliveryReviewSubControllerList[0][1]();
      }
      return _deliveryReviewSubControllerList[0][0];
    };
    _deliveryReviewSubControllerList[1][2] = () {
      if (_deliveryReviewSubControllerList[1][0] == null) {
        _deliveryReviewSubControllerList[1][0] = _deliveryReviewSubControllerList[1][1]();
      }
      return _deliveryReviewSubControllerList[1][0];
    };
  }

  @override
  void onSetController() {
    _deliveryReviewController.controller = GetExtended.put<DeliveryReviewController>(
      DeliveryReviewController(
        controllerManager,
        Injector.locator<RepurchaseControllerContentDelegate>()
      ),
      tag: pageName
    );
  }

  @override
  _DeliveryReviewPageRestoration createPageRestoration() => _DeliveryReviewPageRestoration(
    onCompleteSelectPaymentMethod: (result) {
      if (result != null) {
        if (_statefulDeliveryReviewControllerMediatorWidgetDelegate.onRefreshPaymentMethod != null) {
          _statefulDeliveryReviewControllerMediatorWidgetDelegate.onRefreshPaymentMethod!(result.toPaymentMethodPageResponse().paymentMethod);
        }
      }
    },
    onCompleteSelectCoupon: (result) {
      if (result != null) {
        if (_statefulDeliveryReviewControllerMediatorWidgetDelegate.onRefreshCouponId != null) {
          _statefulDeliveryReviewControllerMediatorWidgetDelegate.onRefreshCouponId!(result);
        }
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulDeliveryReviewControllerMediatorWidget(
      deliveryReviewController: _deliveryReviewController.controller,
      deliveryReviewSubControllerList: _deliveryReviewSubControllerList,
      pageName: pageName,
      statefulDeliveryReviewControllerMediatorWidgetDelegate: _statefulDeliveryReviewControllerMediatorWidgetDelegate
    );
  }
}

class _DeliveryReviewPageRestoration extends ExtendedMixableGetxPageRestoration with CountryDeliveryReviewPageRestorationMixin, OrderDetailPageRestorationMixin, PaymentMethodPageRestorationMixin, CouponPageRestorationMixin {
  final RouteCompletionCallback<String?>? _onCompleteSelectPaymentMethod;
  final RouteCompletionCallback<String?>? _onCompleteSelectCoupon;

  _DeliveryReviewPageRestoration({
    RouteCompletionCallback<String?>? onCompleteSelectPaymentMethod,
    RouteCompletionCallback<String?>? onCompleteSelectCoupon
  }) : _onCompleteSelectPaymentMethod = onCompleteSelectPaymentMethod,
      _onCompleteSelectCoupon = onCompleteSelectCoupon;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSelectPaymentMethod = _onCompleteSelectPaymentMethod;
    onCompleteSelectCoupon = _onCompleteSelectCoupon;
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

class DeliveryReviewPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => DeliveryReviewPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(DeliveryReviewPage()));
}

mixin DeliveryReviewPageRestorationMixin on MixableGetxPageRestoration {
  late DeliveryReviewPageRestorableRouteFuture deliveryReviewPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    deliveryReviewPageRestorableRouteFuture = DeliveryReviewPageRestorableRouteFuture(restorationId: restorationIdWithPageName('delivery-review-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    deliveryReviewPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    deliveryReviewPageRestorableRouteFuture.dispose();
  }
}

class DeliveryReviewPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  DeliveryReviewPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(DeliveryReviewPageGetPageBuilderAssistant()),
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
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

class _StatefulDeliveryReviewControllerMediatorWidgetDelegate {
  void Function(PaymentMethod)? onRefreshPaymentMethod;
  void Function(String)? onRefreshCouponId;
}

class _StatefulDeliveryReviewControllerMediatorWidget extends StatefulWidget {
  final DeliveryReviewController deliveryReviewController;
  final List<List<dynamic>> deliveryReviewSubControllerList;
  final String pageName;
  final _StatefulDeliveryReviewControllerMediatorWidgetDelegate statefulDeliveryReviewControllerMediatorWidgetDelegate;

  const _StatefulDeliveryReviewControllerMediatorWidget({
    required this.deliveryReviewController,
    required this.deliveryReviewSubControllerList,
    required this.pageName,
    required this.statefulDeliveryReviewControllerMediatorWidgetDelegate
  });

  @override
  State<_StatefulDeliveryReviewControllerMediatorWidget> createState() => _StatefulDeliveryReviewControllerMediatorWidgetState();
}

class _StatefulDeliveryReviewControllerMediatorWidgetState extends State<_StatefulDeliveryReviewControllerMediatorWidget> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _tabControllerIndex = 0;
  final PaymentParameterModalDialogPageDelegate _repurchasePaymentParameterModalDialogPageDelegate = PaymentParameterModalDialogPageDelegate();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() => _tabControllerIndex = _tabController.index);
    });
    MainRouteObserver.onRefreshDeliveryReview = RefreshDeliveryReview();
    widget.statefulDeliveryReviewControllerMediatorWidgetDelegate.onRefreshPaymentMethod = (paymentMethod) {
      _repurchasePaymentParameterModalDialogPageDelegate.onUpdatePaymentMethod(paymentMethod);
    };
    widget.statefulDeliveryReviewControllerMediatorWidgetDelegate.onRefreshCouponId = (couponId) {
      _repurchasePaymentParameterModalDialogPageDelegate.onUpdateCoupon(couponId);
    };
  }

  @override
  Widget build(BuildContext context) {
    widget.deliveryReviewController.repurchaseControllerContentDelegate.setRepurchaseDelegate(
      Injector.locator<RepurchaseDelegateFactory>().generateRepurchaseDelegate(
        onGetBuildContext: () => context,
        onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
        onBeginRepurchase: (repurchaseAction) {
          DialogHelper.showModalBottomDialogPage<int, int>(
            context: context,
            modalDialogPageBuilder: (context, parameter) => PaymentParameterModalDialogPage(
              paymentParameterModalDialogPageParameter: PaymentParameterModalDialogPageParameter(
                paymentParameterModalDialogPageDelegate: _repurchasePaymentParameterModalDialogPageDelegate,
                onGotoSelectPaymentMethodPage: (paymentMethodSettlingId) {
                  PageRestorationHelper.toPaymentMethodPage(context, paymentMethodSettlingId);
                },
                onGotoSelectCouponPage: (couponId) {
                  PageRestorationHelper.toCouponPage(context, couponId);
                },
                onProcessPaymentParameter: (paymentMethodSettlingId, couponId) {
                  repurchaseAction.onStartRepurchase(paymentMethodSettlingId, couponId);
                },
                titleLabel: () => "Repurchase".tr,
                buttonLabel: () => "Repurchase".tr
              )
            ),
            parameter: 1
          );
        }
      )
    );
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Delivery Review".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ModifiedTabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  text: "Waiting To Be Reviewed".tr,
                ),
                Tab(
                  text: "History".tr
                )
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _tabControllerIndex,
                children: [
                  WaitingToBeReviewedDeliveryReviewSubPage(
                    ancestorPageName: widget.pageName,
                    onAddControllerMember: () => widget.deliveryReviewSubControllerList[0][2]() as ControllerMember<WaitingToBeReviewedDeliveryReviewSubController>,
                    onBuyAgainTap: (order) {
                      widget.deliveryReviewController.repurchaseControllerContentDelegate.repurchase(order.id);
                    },
                  ),
                  HistoryDeliveryReviewSubPage(
                    ancestorPageName: widget.pageName,
                    onAddControllerMember: () => widget.deliveryReviewSubControllerList[1][2]() as ControllerMember<HistoryDeliveryReviewSubController>,
                  )
                ],
              )
            )
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    MainRouteObserver.onRefreshDeliveryReview?.dispose();
    MainRouteObserver.onRefreshDeliveryReview = null;
    super.dispose();
  }
}