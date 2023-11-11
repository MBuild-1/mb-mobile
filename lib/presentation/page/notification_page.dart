import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';

import '../../controller/notification_controller.dart';
import '../../domain/entity/notification/notification_by_user_paging_parameter.dart';
import '../../domain/entity/notification/notification_order_status_parameter.dart';
import '../../domain/entity/notification/short_notification.dart';
import '../../domain/usecase/get_notification_by_user_paging_use_case.dart';
import '../../domain/usecase/get_transaction_notification_detail_use_case.dart';
import '../../domain/usecase/notification_order_status_use_case.dart';
import '../../domain/usecase/read_all_notification_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/notificationlistitemcontrollerstate/notification_container_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/list_item_controller_state_helper.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/toast_helper.dart';
import '../notifier/notification_notifier.dart';
import '../widget/colorful_chip_tab_bar.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';
import 'order_page.dart';

class NotificationPage extends RestorableGetxPage<_NotificationPageRestoration> {
  late final ControllerMember<NotificationController> _notificationController = ControllerMember<NotificationController>().addToControllerManager(controllerManager);

  NotificationPage({Key? key}) : super(key: key, pageRestorationId: () => "notification-page");

  @override
  void onSetController() {
    _notificationController.controller = GetExtended.put<NotificationController>(
      NotificationController(
        controllerManager,
        Injector.locator<GetNotificationByUserPagingUseCase>(),
        Injector.locator<GetTransactionNotificationDetailUseCase>(),
        Injector.locator<NotificationOrderStatusUseCase>(),
        Injector.locator<ReadAllNotificationUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _NotificationPageRestoration createPageRestoration() => _NotificationPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulNotificationControllerMediatorWidget(
      notificationController: _notificationController.controller,
    );
  }
}

class _NotificationPageRestoration extends MixableGetxPageRestoration with OrderPageRestorationMixin {
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

class NotificationPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => NotificationPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(NotificationPage()));
}

mixin NotificationPageRestorationMixin on MixableGetxPageRestoration {
  late NotificationPageRestorableRouteFuture notificationPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    notificationPageRestorableRouteFuture = NotificationPageRestorableRouteFuture(restorationId: restorationIdWithPageName('notification-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    notificationPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    notificationPageRestorableRouteFuture.dispose();
  }
}

class NotificationPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  NotificationPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(NotificationPageGetPageBuilderAssistant()),
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

class _StatefulNotificationControllerMediatorWidget extends StatefulWidget {
  final NotificationController notificationController;

  const _StatefulNotificationControllerMediatorWidget({
    required this.notificationController
  });

  @override
  State<_StatefulNotificationControllerMediatorWidget> createState() => _StatefulNotificationControllerMediatorWidgetState();
}

class _StatefulNotificationControllerMediatorWidgetState extends State<_StatefulNotificationControllerMediatorWidget> {
  late final ScrollController _notificationScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _notificationListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _notificationListItemPagingControllerState;
  late ColorfulChipTabBarController _notificationTabColorfulChipTabBarController;
  late List<ColorfulChipTabBarData> _notificationColorfulChipTabBarDataList;
  LoadDataResult<int> _purchaseStatusLoadDataResult = NoLoadDataResult<int>();
  String _status = "transaction";

  final ValueNotifier<dynamic> _fillerErrorValueNotifier = ValueNotifier(null);
  late NotificationNotifier _notificationNotifier;

  @override
  void initState() {
    super.initState();
    _notificationNotifier = Provider.of<NotificationNotifier>(context, listen: false);
    _notificationScrollController = ScrollController();
    _notificationListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.notificationController.apiRequestManager,
      fillerErrorValueNotifier: _fillerErrorValueNotifier
    );
    _notificationListItemPagingControllerState = PagingControllerState(
      pagingController: _notificationListItemPagingController,
      scrollController: _notificationScrollController,
      isPagingControllerExist: false
    );
    _notificationListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _notificationListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _notificationListItemPagingControllerState.isPagingControllerExist = true;
    _notificationTabColorfulChipTabBarController = ColorfulChipTabBarController(0);
    _notificationColorfulChipTabBarDataList = <ColorfulChipTabBarData>[
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: MultiLanguageString({
          Constant.textInIdLanguageKey: "Transaksi",
          Constant.textEnUsLanguageKey: "Transaction"
        }).toEmptyStringNonNull,
        data: "transaction"
      ),
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Info",
        data: "info"
      ),
      ColorfulChipTabBarData(
        color: Constant.colorMain,
        title: "Promo",
        data: "promo"
      ),
    ];
    _notificationTabColorfulChipTabBarController.addListener(() {
      _status = (_notificationColorfulChipTabBarDataList[_notificationTabColorfulChipTabBarController.value].data as String).toEmptyStringNonNull;
      _notificationListItemPagingController.resetToDesiredPageKey(1);
    });
  }

  void _loadNotificationPurchaseStatus() async {
    _purchaseStatusLoadDataResult = IsLoadingLoadDataResult<int>();
    setState(() {});
    _purchaseStatusLoadDataResult = await widget.notificationController.notificationOrderStatus(
      NotificationOrderStatusParameter()
    ).map<int>(
      (value) => value.orderStatus
    );
    if (_purchaseStatusLoadDataResult.isFailedBecauseCancellation) {
      return;
    }
    setState(() {});
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _notificationListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? notificationListItemControllerStateList) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _fillerErrorValueNotifier.value = null;
    });
    List<ListItemControllerState> resultListItemControllerState = [];
    if (pageKey == 1) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _notificationNotifier.loadNotificationLoadDataResult();
        _loadNotificationPurchaseStatus();
      });
      resultListItemControllerState = [
        NotificationContainerListItemControllerState(
          notificationList: [],
          onNotificationTap: (notification) {},
          onUpdateState: () => setState(() {}),
          onMarkAllNotification: () => widget.notificationController.readAllNotification(_status),
          onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
          notificationTabColorfulChipTabBarController: _notificationTabColorfulChipTabBarController,
          notificationColorfulChipTabBarDataList: _notificationColorfulChipTabBarDataList,
          purchaseStatusLoadDataResult: () => _purchaseStatusLoadDataResult,
          notificationLoadDataResult: () => _notificationNotifier.notificationLoadDataResult,
          transactionNotificationLoadDataResult: () => _notificationNotifier.transactionNotificationLoadDataResult,
          infoNotificationLoadDataResult: () => _notificationNotifier.infoNotificationLoadDataResult,
          promoNotificationLoadDataResult: () => _notificationNotifier.promoNotificationLoadDataResult
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
      LoadDataResult<PagingDataResult<ShortNotification>> shortNotificationPagingLoadDataResult = await widget.notificationController.getNotificationByUser(
        NotificationByUserPagingParameter(
          page: effectivePageKey,
          search: _status
        )
      );
      if (shortNotificationPagingLoadDataResult.isSuccess) {
        if (shortNotificationPagingLoadDataResult.resultIfSuccess!.itemList.isEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            _fillerErrorValueNotifier.value = FailedLoadDataResult.throwException(() {
              throw ErrorHelper.generateMultiLanguageDioError(
                MultiLanguageMessageError(
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "No Transaction Notification Yet",
                    Constant.textInIdLanguageKey: "Belum Ada Notifikasi Transaksi",
                  }),
                  message: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Notifications regarding your transaction will appear here.",
                    Constant.textInIdLanguageKey: "Notifikasi terkait transaksi kamu bakal muncul disini.",
                  }),
                )
              );
            })!.e;
          });
        }
      }
      return shortNotificationPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((notificationPaging) {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(notificationListItemControllerStateList)) {
          NotificationContainerListItemControllerState notificationContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(notificationListItemControllerStateList![0]) as NotificationContainerListItemControllerState;
          notificationContainerListItemControllerState.notificationList.addAll(notificationPaging.itemList);
        }
        return PagingDataResult<ListItemControllerState>(
          itemList: resultListItemControllerState,
          page: notificationPaging.page,
          totalPage: notificationPaging.totalPage,
          totalItem: notificationPaging.totalItem
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.notificationController.setNotificationDelegate(
      NotificationDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onBack: () => Get.back(),
        onShowReadAllNotificationRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowReadAllNotificationRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onReadAllNotificationRequestProcessSuccessCallback: (readAllNotificationResponse) async {
          _notificationListItemPagingController.refresh();
        },
      )
    );
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Notification".tr),
          ],
        ),
      ),
      body: Consumer<NotificationNotifier>(
        builder: (_, notificationNotifier, __) => SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: _notificationListItemPagingControllerState,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true,
                  onGetErrorProvider: () => Injector.locator<ErrorProvider>(),
                ),
              ),
            ]
          )
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}