import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../controller/newscontroller/news_detail_controller.dart';
import '../../../domain/entity/news/news.dart';
import '../../../domain/usecase/get_news_detail_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../../widget/modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../../widget/rx_consumer.dart';
import '../getx_page.dart';

class NewsDetailPage extends RestorableGetxPage<_NewsDetailPageRestoration> {
  late final ControllerMember<NewsDetailController> _newsDetailController = ControllerMember<NewsDetailController>().addToControllerManager(controllerManager);

  final String newsId;

  NewsDetailPage({Key? key, required this.newsId}) : super(key: key, pageRestorationId: () => "news-detail-page");

  @override
  void onSetController() {
    _newsDetailController.controller = GetExtended.put<NewsDetailController>(
      NewsDetailController(
        controllerManager,
        Injector.locator<GetNewsDetailUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _NewsDetailPageRestoration createPageRestoration() => _NewsDetailPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulNewsDetailControllerMediatorWidget(
        newsController: _newsDetailController.controller,
        newsId: newsId
      ),
    );
  }
}

class _NewsDetailPageRestoration extends MixableGetxPageRestoration {
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

class NewsDetailPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String newsId;

  NewsDetailPageGetPageBuilderAssistant({
    required this.newsId
  });

  @override
  GetPageBuilder get pageBuilder => (() => NewsDetailPage(newsId: newsId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(NewsDetailPage(newsId: newsId)));
}

mixin NewsDetailPageRestorationMixin on MixableGetxPageRestoration {
  late NewsDetailPageRestorableRouteFuture newsDetailPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    newsDetailPageRestorableRouteFuture = NewsDetailPageRestorableRouteFuture(restorationId: restorationIdWithPageName('news-detail-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    newsDetailPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    newsDetailPageRestorableRouteFuture.dispose();
  }
}

class NewsDetailPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  NewsDetailPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(NewsDetailPageGetPageBuilderAssistant(newsId: arguments)),
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

class _StatefulNewsDetailControllerMediatorWidget extends StatefulWidget {
  final NewsDetailController newsController;
  final String newsId;

  const _StatefulNewsDetailControllerMediatorWidget({
    required this.newsController,
    required this.newsId
  });

  @override
  State<_StatefulNewsDetailControllerMediatorWidget> createState() => _StatefulNewsDetailControllerMediatorWidgetState();
}

class _StatefulNewsDetailControllerMediatorWidgetState extends State<_StatefulNewsDetailControllerMediatorWidget> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.newsController.loadNewsDetail(widget.newsId);
    });
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("News Detail".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RxConsumer<LoadDataResultWrapper<News>>(
                rxValue: widget.newsController.newsDetailLoadDataResultWrapperRx,
                onConsumeValue: (context, value) => LoadDataResultImplementer<News>(
                  errorProvider: Injector.locator<ErrorProvider>(),
                  loadDataResult: value.loadDataResult,
                  onSuccessLoadDataResultWidget: (news) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(Constant.paddingListItem),
                      child: Column(
                        children: [
                          Text(
                            news.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                            )
                          ),
                          const SizedBox(height: 16),
                          HtmlWidget(
                            news.body,
                            isSelectable: true,
                            onTapUrl: (url) async {
                              Uri uri = Uri.parse(url);
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                              return true;
                            },
                          ),
                        ],
                      )
                    );
                  },
                ),
              ),
            ),
          ]
        )
      ),
    );
  }
}