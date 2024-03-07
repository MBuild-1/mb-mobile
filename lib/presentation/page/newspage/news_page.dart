import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/newscontroller/news_controller.dart';
import '../../../domain/entity/news/news.dart';
import '../../../domain/entity/news/news_paging_parameter.dart';
import '../../../domain/usecase/get_news_paging_use_case.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/newslistitemcontrollerstate/news_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/list_item_controller_state_helper.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modified_scaffold.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../getx_page.dart';
import 'news_detail_page.dart';

class NewsPage extends RestorableGetxPage<_NewsPageRestoration> {
  late final ControllerMember<NewsController> _newsController = ControllerMember<NewsController>().addToControllerManager(controllerManager);

  NewsPage({Key? key}) : super(key: key, pageRestorationId: () => "news-page");

  @override
  void onSetController() {
    _newsController.controller = GetExtended.put<NewsController>(
      NewsController(
        controllerManager,
        Injector.locator<GetNewsPagingUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _NewsPageRestoration createPageRestoration() => _NewsPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulNewsControllerMediatorWidget(
      newsController: _newsController.controller,
    );
  }
}

class _NewsPageRestoration extends ExtendedMixableGetxPageRestoration with NewsDetailPageRestorationMixin {
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

class NewsPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => NewsPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(NewsPage()));
}

mixin NewsPageRestorationMixin on MixableGetxPageRestoration {
  late NewsPageRestorableRouteFuture newsPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    newsPageRestorableRouteFuture = NewsPageRestorableRouteFuture(restorationId: restorationIdWithPageName('news-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    newsPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    newsPageRestorableRouteFuture.dispose();
  }
}

class NewsPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  NewsPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        NewsPageGetPageBuilderAssistant()
      )
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

class _StatefulNewsControllerMediatorWidget extends StatefulWidget {
  final NewsController newsController;

  const _StatefulNewsControllerMediatorWidget({
    required this.newsController
  });

  @override
  State<_StatefulNewsControllerMediatorWidget> createState() => _StatefulNewsControllerMediatorWidgetState();
}

class _StatefulNewsControllerMediatorWidgetState extends State<_StatefulNewsControllerMediatorWidget> {
  late final ScrollController _newsScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _newsListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _newsListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _newsScrollController = ScrollController();
    _newsListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.newsController.apiRequestManager,
    );
    _newsListItemPagingControllerState = PagingControllerState(
      pagingController: _newsListItemPagingController,
      scrollController: _newsScrollController,
      isPagingControllerExist: false
    );
    _newsListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _newsListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _newsListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _newsListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? orderListItemControllerStateList) async {
    LoadDataResult<PagingDataResult<News>> newsPagingLoadDataResult = await widget.newsController.getNewsPaging(
      NewsPagingParameter(page: pageKey)
    );
    return newsPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((newsPaging) {
      List<ListItemControllerState> resultListItemControllerState = [];
      if (pageKey == 1) {
        resultListItemControllerState = [
          NewsContainerListItemControllerState(
            newsList: newsPaging.itemList,
            onUpdateState: () => setState(() {}),
            onNewsTap: (news) => PageRestorationHelper.toNewsDetailPage(context, news.id)
          )
        ];
      } else {
        if (ListItemControllerStateHelper.checkListItemControllerStateList(orderListItemControllerStateList)) {
          NewsContainerListItemControllerState newsContainerListItemControllerState = ListItemControllerStateHelper.parsePageKeyedListItemControllerState(orderListItemControllerStateList![0]) as NewsContainerListItemControllerState;
          newsContainerListItemControllerState.newsList.addAll(newsPaging.itemList);
        }
      }
      return PagingDataResult<ListItemControllerState>(
        itemList: resultListItemControllerState,
        page: newsPaging.page,
        totalPage: newsPaging.totalPage,
        totalItem: newsPaging.totalItem
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Master Bagasi's Blog".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _newsListItemPagingControllerState,
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

  @override
  void dispose() {
    super.dispose();
  }
}