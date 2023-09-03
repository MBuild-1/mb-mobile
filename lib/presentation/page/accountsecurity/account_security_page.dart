import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/accountsecuritycontroller/account_security_controller.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/divider_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../getx_page.dart';
import 'change_password_page.dart';

class AccountSecurityPage extends RestorableGetxPage<_AccountSecurityPageRestoration> {
  late final ControllerMember<AccountSecurityController> _accountSecurityController = ControllerMember<AccountSecurityController>().addToControllerManager(controllerManager);

  AccountSecurityPage({
    Key? key
  }) : super(key: key, pageRestorationId: () => "account-security-page");

  @override
  void onSetController() {
    _accountSecurityController.controller = GetExtended.put<AccountSecurityController>(
      AccountSecurityController(
        controllerManager
      ), tag: pageName
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulAccountSecurityControllerMediatorWidget(
      accountSecurityController: _accountSecurityController.controller
    );
  }

  @override
  _AccountSecurityPageRestoration createPageRestoration() => _AccountSecurityPageRestoration();
}

class _AccountSecurityPageRestoration extends MixableGetxPageRestoration with ChangePasswordPageRestorationMixin {
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

class AccountSecurityPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => AccountSecurityPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(AccountSecurityPage()));
}

mixin AccountSecurityPageRestorationMixin on MixableGetxPageRestoration {
  late AccountSecurityPageRestorableRouteFuture accountSecurityPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    accountSecurityPageRestorableRouteFuture = AccountSecurityPageRestorableRouteFuture(restorationId: restorationIdWithPageName('account-security-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    accountSecurityPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    accountSecurityPageRestorableRouteFuture.dispose();
  }
}

class AccountSecurityPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  AccountSecurityPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(AccountSecurityPageGetPageBuilderAssistant())
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

class _StatefulAccountSecurityControllerMediatorWidget extends StatefulWidget {
  final AccountSecurityController accountSecurityController;

  const _StatefulAccountSecurityControllerMediatorWidget({
    required this.accountSecurityController
  });

  @override
  State<_StatefulAccountSecurityControllerMediatorWidget> createState() => _StatefulAccountSecurityControllerMediatorWidgetState();
}

class _StatefulAccountSecurityControllerMediatorWidgetState extends State<_StatefulAccountSecurityControllerMediatorWidget> {
  late final ScrollController _accountSecurityScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _accountSecurityListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _accountSecurityListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _accountSecurityScrollController = ScrollController();
    _accountSecurityListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.accountSecurityController.apiRequestManager,
    );
    _accountSecurityListItemPagingControllerState = PagingControllerState(
      pagingController: _accountSecurityListItemPagingController,
      scrollController: _accountSecurityScrollController,
      isPagingControllerExist: false
    );
    _accountSecurityListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _accountSecurityListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _accountSecurityListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _accountSecurityListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    Widget descriptionInterceptor(description, lastDescriptionTextStyle) => Text(description);
    return SuccessLoadDataResult<PagingDataResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
          ProfileMenuListItemControllerState(
            onTap: (context) => PageRestorationHelper.toChangePasswordPage(context),
            title: 'Change Password'.tr,
            descriptionInterceptor: descriptionInterceptor,
            icon: null
          ),
          DividerListItemControllerState(),
          ProfileMenuListItemControllerState(
            onTap: (context) {},
            title: 'PIN Master Bagasi'.tr,
            descriptionInterceptor: descriptionInterceptor,
            icon: null
          ),
          DividerListItemControllerState(),
          ProfileMenuListItemControllerState(
            onTap: (context) {},
            title: 'Fingerprint'.tr,
            descriptionInterceptor: descriptionInterceptor,
            icon: null
          ),
          DividerListItemControllerState(),
          ProfileMenuListItemControllerState(
            onTap: (context) {},
            title: 'Personal Data Verification'.tr,
            descriptionInterceptor: descriptionInterceptor,
            icon: null
          ),
          DividerListItemControllerState(),
          ProfileMenuListItemControllerState(
            onTap: (context) {},
            title: 'Login Via Notification'.tr,
            descriptionInterceptor: descriptionInterceptor,
            icon: null
          ),
        ],
        page: 1,
        totalPage: 1,
        totalItem: 0
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Account Security".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _accountSecurityListItemPagingControllerState,
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