import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/mainmenucontroller/mainmenusubpagecontroller/mbestie_main_menu_sub_controller.dart';
import '../../../../misc/backgroundappbarscaffoldtype/color_background_app_bar_scaffold_type.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../../../../misc/controllerstate/paging_controller_state.dart';
import '../../../../misc/error/coming_soon_error.dart';
import '../../../../misc/errorprovider/error_provider.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/load_data_result.dart';
import '../../../../misc/login_helper.dart';
import '../../../../misc/main_route_observer.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/paging/modified_paging_controller.dart';
import '../../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../../misc/paging/pagingresult/paging_result.dart';
import '../../../../misc/widget_helper.dart';
import '../../../widget/background_app_bar_scaffold.dart';
import '../../../widget/modified_paged_list_view.dart';
import '../../../widget/modifiedappbar/main_menu_search_app_bar.dart';
import '../../getx_page.dart';

class MBestieMainMenuSubPage extends DefaultGetxPage {
  late final ControllerMember<MBestieMainMenuSubController> _mBestieMainMenuSubController = ControllerMember<MBestieMainMenuSubController>().addToControllerManager(controllerManager);
  final String ancestorPageName;

  MBestieMainMenuSubPage({Key? key, required this.ancestorPageName}) : super(key: key, systemUiOverlayStyle: SystemUiOverlayStyle.light);

  @override
  void onSetController() {
    _mBestieMainMenuSubController.controller = Injector.locator<MBestieMainMenuSubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulMBestieMainMenuSubControllerMediatorWidget(
      mBestieMainMenuSubController: _mBestieMainMenuSubController.controller
    );
  }
}

class _StatefulMBestieMainMenuSubControllerMediatorWidget extends StatefulWidget {
  final MBestieMainMenuSubController mBestieMainMenuSubController;

  const _StatefulMBestieMainMenuSubControllerMediatorWidget({
    required this.mBestieMainMenuSubController
  });

  @override
  State<_StatefulMBestieMainMenuSubControllerMediatorWidget> createState() => _StatefulMBestieMainMenuSubControllerMediatorWidgetState();
}

class _StatefulMBestieMainMenuSubControllerMediatorWidgetState extends State<_StatefulMBestieMainMenuSubControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _mBestieMainMenuSubListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _mBestieMainMenuSubListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _mBestieMainMenuSubListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.mBestieMainMenuSubController.apiRequestManager
    );
    _mBestieMainMenuSubListItemPagingControllerState = PagingControllerState(
      pagingController: _mBestieMainMenuSubListItemPagingController,
      isPagingControllerExist: false
    );
    _mBestieMainMenuSubListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _mBestieMainMenuListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _mBestieMainMenuSubListItemPagingControllerState.isPagingControllerExist = true;
    MainRouteObserver.controllerMediatorMap[Constant.subPageKeyMBestieMainMenu] = refreshMBestieMainMenu;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _mBestieMainMenuListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    bool isLogin = false;
    LoginHelper.checkingLogin(
      context,
      () => isLogin = true,
      resultIfHasNotBeenLogin: () {}
    );
    if (!isLogin) {
      return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
        value: PagingDataResult<ListItemControllerState>(
          page: 1,
          totalPage: 1,
          totalItem: 1,
          itemList: [NoContentListItemControllerState()]
        )
      );
    }
    return SuccessLoadDataResult<PagingDataResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: 0,
        itemList: [NoContentListItemControllerState()],
      )
    );
  }

  void refreshMBestieMainMenu() {
    setState(() {});
    _mBestieMainMenuSubListItemPagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    print("Ini kan mantap: ${MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMBestieMainMenu]}");
    return WidgetHelper.checkVisibility(
      MainRouteObserver.subMainMenuVisibility[Constant.subPageKeyMBestieMainMenu],
      () => BackgroundAppBarScaffold(
        backgroundAppBarScaffoldType: ColorBackgroundAppBarScaffoldType(
          color: Constant.colorDarkBlack2
        ),
        appBar: MainMenuSearchAppBar(value: 0.0),
        withModifiedScaffold: false,
        backgroundColor: Constant.colorSurfaceGrey,
        body: Expanded(
          child: () {
            return WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
              context: context,
              errorProvider: Injector.locator<ErrorProvider>(),
              imageHeight: 50.h,
              e: ComingSoonError()
            );
            return WidgetHelper.checkingLogin(
              context,
              () => ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _mBestieMainMenuSubListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
              Injector.locator<ErrorProvider>(),
              withIndexedStack: true
            );
          }()
        ),
      )
    );
  }
}