import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/navigator_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/platform_interface.dart';

import '../../controller/web_viewer_controller.dart';
import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/navigation_helper.dart';
import '../../misc/toast_helper.dart';
import '../widget/app_bar_icon_area.dart';
import '../widget/loaddataresultimplementer/load_data_result_implementer_directly.dart';
import '../widget/modified_loading_indicator.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/progress_indicator_bar.dart';
import 'getx_page.dart';
import 'package:html/parser.dart';

class LoginWithAppleWebViewerPage extends RestorableGetxPage<_LoginWithAppleWebViewerPageRestoration> {
  late final ControllerMember<WebViewerController> _webViewerController = ControllerMember<WebViewerController>().addToControllerManager(controllerManager);

  LoginWithAppleWebViewerPage({
    Key? key
  }) : super(key: key, pageRestorationId: () => "login-with-apple-web-viewer-page");

  @override
  void onSetController() {
    _webViewerController.controller = GetExtended.put<WebViewerController>(WebViewerController(controllerManager), tag: pageName);
  }

  @override
  _LoginWithAppleWebViewerPageRestoration createPageRestoration() => _LoginWithAppleWebViewerPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulLoginWithAppleWebViewerPage();
  }
}

class LoginWithAppleWebViewerPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => LoginWithAppleWebViewerPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(LoginWithAppleWebViewerPage()));
}

class _LoginWithAppleWebViewerPageRestoration extends ExtendedMixableGetxPageRestoration  {
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

mixin LoginWithAppleWebViewerPageRestorationMixin on MixableGetxPageRestoration {
  late LoginWithAppleWebViewerPageRestorableRouteFuture loginWithAppleWebViewerPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    loginWithAppleWebViewerPageRestorableRouteFuture = LoginWithAppleWebViewerPageRestorableRouteFuture(restorationId: restorationIdWithPageName('web-viewer-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    loginWithAppleWebViewerPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    loginWithAppleWebViewerPageRestorableRouteFuture.dispose();
  }
}

class LoginWithAppleWebViewerPageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<bool?>? onComplete;

  late RestorableRouteFuture<bool?> _pageRoute;

  LoginWithAppleWebViewerPageRestorableRouteFuture({
    required String restorationId,
    this.onComplete
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<bool?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
      onComplete: onComplete
    );
  }

  static Route<bool?>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(LoginWithAppleWebViewerPageGetPageBuilderAssistant())
    );
  }

  @pragma('vm:entry-point')
  static Route<bool?> _pageRouteBuilder(BuildContext context, Object? arguments) {
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

class _StatefulLoginWithAppleWebViewerPage extends StatefulWidget {
  @override
  _StatefulLoginWithAppleWebViewerPageState createState() => _StatefulLoginWithAppleWebViewerPageState();
}

class _StatefulLoginWithAppleWebViewerPageState extends State<_StatefulLoginWithAppleWebViewerPage> {
  InAppWebViewController? _webViewController;
  late String _url = "";
  Map<String, dynamic>? _header;
  bool _isLoading = true;
  bool _canGoBack = false;
  bool _canGoForward = false;
  bool _canShare = false;
  int _progress = 0;
  FailedLoadDataResult<bool>? _webLoadingFailedLoadDataResult;
  bool _isSuccessLoginViaApple = false;

  @override
  void initState() {
    super.initState();
    _url = Constant.envValueAppleLoginWebUrl;
  }

  @override
  Widget build(BuildContext context) {
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptorWithAdditionalParameter: (context, title, titleInterceptorAdditionalParameter) {
          Size preferredSize = titleInterceptorAdditionalParameter.appBarPreferredSize;
          return Row(
            children: [
              Expanded(
                child: title ?? Container(),
              ),
              AppBarIconArea(
                onTap: () {
                  setState(() => _webLoadingFailedLoadDataResult = null);
                  _webViewController?.reload();
                },
                height: preferredSize.height,
                child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary, size: 30)
              ),
              AppBarIconArea(
                onTap: _canGoBack ? () async {
                  if (_webViewController != null) {
                    if (await _webViewController!.canGoBack()) {
                      await _webViewController!.goBack();
                    }
                  }
                } : null,
                height: preferredSize.height,
                child: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.primary, size: 30)
              ),
              AppBarIconArea(
                onTap: _canGoForward ? () async {
                  if (_webViewController != null) {
                    if (await _webViewController!.canGoForward()) {
                      await _webViewController!.goForward();
                    }
                  }
                } : null,
                height: preferredSize.height,
                child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary, size: 30)
              ),
            ],
          );
        },
      ),
      body: Builder(
        builder: (context) {
          Widget centerLoadingIndicator(Widget loadingIndicator) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loadingIndicator
                ]
              ),
            );
          }
          return Stack(
            children: [
              Visibility(
                visible: _isSuccessLoginViaApple,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: centerLoadingIndicator(const ModifiedLoadingIndicator())
              ),
              Visibility(
                visible: !_isSuccessLoginViaApple,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: LoadDataResultImplementerDirectlyWithDefault<bool>(
                  loadDataResult: _webLoadingFailedLoadDataResult ?? NoLoadDataResult<bool>(),
                  errorProvider: Injector.locator<ErrorProvider>(),
                  onImplementLoadDataResultDirectlyWithDefault: (loadDataResult, errorProvider, defaultLoadDataResultWidget) {
                    if (loadDataResult is FailedLoadDataResult<bool>) {
                      return centerLoadingIndicator(
                        defaultLoadDataResultWidget.failedLoadDataResultWidget(context, loadDataResult, errorProvider)
                      );
                    }
                    return Column(
                      children: [
                        if (_isLoading)
                          ProgressIndicatorBar(
                            barColor: Theme.of(context).colorScheme.primary,
                            barBackgroundColor: Colors.grey.shade200,
                            barValue: _progress / 100,
                            height: 3.0,
                            barBackgroundRadius: Radius.zero,
                            barRadius: Radius.zero,
                          ),
                        Expanded(
                          child: InAppWebView(
                            initialUrlRequest: URLRequest(
                              url: Uri.parse(_url),
                              headers: _header != null ? _header!.map(
                                (key, value) => MapEntry<String, String>(
                                  key, value as String
                                )
                              ) : null
                            ),
                            onProgressChanged: (controller, progress) async {
                              _progress = progress;
                              setState(() {});
                              if (_isLoading && _progress == 100) {
                                await _onPageFinishedLoading();
                              } else if (!_isLoading) {
                                _onPageStartedLoading();
                              }
                            },
                            onLoadStart: (controller, url) => _onPageStartedLoading(),
                            onLoadStop: (controller, url) async {
                              String urlString = url.toString();
                              String parseHtmlString(String htmlString) {
                                final document = parse(htmlString);
                                final String parsedString = (parse(document.body?.text).documentElement?.text).toEmptyStringNonNull;
                                return parsedString;
                              }
                              String result = parseHtmlString((await controller.getHtml()).toString());
                              if (urlString.contains(Constant.textDefaultUrl) && urlString.contains("/api/auth/apple")) {
                                setState(() => _isSuccessLoginViaApple = true);
                                await _onPageFinishedLoading();
                                String jsonResultString = result;
                                String currentRoute = MainRouteObserver.getCurrentRoute();
                                if (MainRouteObserver.onRedirectFromNotificationClick[currentRoute] != null) {
                                  MainRouteObserver.onRedirectFromNotificationClick[currentRoute]!({
                                    "type": "login-with-apple-callback",
                                    "data": {
                                      "content": jsonResultString
                                    }
                                  });
                                }
                              } else if (result.toLowerCase().contains("success redirect")) {
                                Navigator.of(context).popUntilLogin();
                              }
                            },
                            onLoadError: (InAppWebViewController controller, Uri? url, int code, String message) {
                              setState(() {
                                _webLoadingFailedLoadDataResult = FailedLoadDataResult.throwException<bool>(
                                  () => throw MessageError(
                                    title: "Web Cannot Be Loaded".tr,
                                    message: message
                                  )
                                );
                              });
                            },
                            onLoadHttpError: (InAppWebViewController controller, Uri? url, int code, String message) {
                              setState(() {
                                _webLoadingFailedLoadDataResult = FailedLoadDataResult.throwException<bool>(
                                  () => throw MessageError(
                                    title: "Web Cannot Be Loaded".tr,
                                    message: message
                                  )
                                );
                              });
                            },
                          ),
                        )
                      ]
                    );
                  },
                ),
              )
            ],
          );
        }
      )
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {
        ToastHelper.showToast(message.message);
      }
    );
  }

  Future<void> _onPageFinishedLoading() async {
    await _checkCanGoBackAndForwardEnabled();
    setState(() => _isLoading = false);
  }

  void _onPageStartedLoading() {
    _resetCanGoBackAndForwardEnabled();
    setState(() => _isLoading = true);
  }

  void _resetCanGoBackAndForwardEnabled() {
    _canGoBack = false;
    _canGoForward = false;
    _canShare = false;
    _webLoadingFailedLoadDataResult = null;
    setState(() {});
  }

  Future<void> _checkCanGoBackAndForwardEnabled() async {
    if (_webViewController != null) {
      _canGoBack = await _webViewController!.canGoBack();
      _canGoForward = await _webViewController!.canGoForward();
      _canShare = true;
    }
    setState(() {});
  }
}