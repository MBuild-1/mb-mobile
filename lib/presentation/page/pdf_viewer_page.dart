import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as syncfusion_pdf_viewer;
import 'package:url_launcher/url_launcher.dart';

import '../../controller/pdf_viewer_controller.dart';
import '../../misc/constant.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/option_builder.dart';
import '../../misc/parameter_link_helper.dart';
import '../../misc/parameterlink/parameter_link_input.dart';
import '../../misc/toast_helper.dart';
import '../widget/app_bar_icon_area.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';

class PdfViewerPage extends RestorableGetxPage<_PdfViewerPageRestoration> {
  final String pdfViewerParameterLink;

  late final ControllerMember<PdfViewerController> _pdfViewerController = ControllerMember<PdfViewerController>().addToControllerManager(controllerManager);

  PdfViewerPage({
    Key? key,
    required this.pdfViewerParameterLink
  }) : super(key: key, pageRestorationId: () => "pdf-viewer-page");

  @override
  void onSetController() {
    _pdfViewerController.controller = GetExtended.put<PdfViewerController>(PdfViewerController(controllerManager), tag: pageName);
  }

  @override
  _PdfViewerPageRestoration createPageRestoration() => _PdfViewerPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulPdfViewerPage(pdfViewerParameterLink: pdfViewerParameterLink);
  }
}

class PdfViewerPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String pdfViewerParameterLink;

  PdfViewerPageGetPageBuilderAssistant({
    required this.pdfViewerParameterLink
  });

  @override
  GetPageBuilder get pageBuilder => (() => PdfViewerPage(pdfViewerParameterLink: pdfViewerParameterLink));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(PdfViewerPage(pdfViewerParameterLink: pdfViewerParameterLink)));
}

class _PdfViewerPageRestoration extends GetxPageRestoration  {
  @override
  void initState() {}

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {}

  @override
  void dispose() {}
}

mixin PdfViewerPageRestorationMixin on MixableGetxPageRestoration {
  late PdfViewerPageRestorableRouteFuture pdfViewerPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    pdfViewerPageRestorableRouteFuture = PdfViewerPageRestorableRouteFuture(restorationId: restorationIdWithPageName('pdf-viewer-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    pdfViewerPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    pdfViewerPageRestorableRouteFuture.dispose();
  }
}

class PdfViewerPageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<bool?>? onComplete;

  late RestorableRouteFuture<bool?> _pageRoute;

  PdfViewerPageRestorableRouteFuture({
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
    if (arguments is! String) {
      throw Exception("Arguments must be a string");
    }
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(PdfViewerPageGetPageBuilderAssistant(pdfViewerParameterLink: arguments))
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

class _StatefulPdfViewerPage extends StatefulWidget {
  final String pdfViewerParameterLink;

  const _StatefulPdfViewerPage({
    required this.pdfViewerParameterLink
  });

  @override
  _StatefulPdfViewerPageState createState() => _StatefulPdfViewerPageState();
}

class _StatefulPdfViewerPageState extends State<_StatefulPdfViewerPage> {
  late ParameterLinkInput _webViewParameterLinkInput;
  late String _url = "";
  late String _fileName = "";
  Map<String, dynamic>? _header;
  final syncfusion_pdf_viewer.PdfViewerController _pdfViewerController = syncfusion_pdf_viewer.PdfViewerController();

  @override
  void initState() {
    super.initState();
    _webViewParameterLinkInput = ParameterLinkHelper.toParameterLinkInput(widget.pdfViewerParameterLink);
    if (_webViewParameterLinkInput.otherParameter is Map<String, dynamic>) {
      Map<String, dynamic> otherParameterMap =  _webViewParameterLinkInput.otherParameter as Map<String, dynamic>;
      if (otherParameterMap.containsKey(Constant.textEncodedUrlKey)) {
        _url = utf8.decode(base64.decode(otherParameterMap[Constant.textEncodedUrlKey]));
      }
      if (otherParameterMap.containsKey(Constant.textHeaderKey)) {
        _header = json.decode(utf8.decode(base64.decode(otherParameterMap[Constant.textHeaderKey])));
      }
      if (otherParameterMap.containsKey(Constant.textFileNameKey)) {
        _fileName = utf8.decode(base64.decode(otherParameterMap[Constant.textFileNameKey]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptorWithAdditionalParameter: (context, title, titleInterceptorAdditionalParameter) {
          Size preferredSize = titleInterceptorAdditionalParameter.appBarPreferredSize;
          return Row(
            children: [
              Expanded(
                child: title ?? Container(),
              ),
              // AppBarIconArea(
              //   onTap: () {
              //     setState(() => _webLoadingFailedLoadDataResult = null);
              //     _webViewController?.reload();
              //   },
              //   height: preferredSize.height,
              //   child: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary, size: 30)
              // ),
              // AppBarIconArea(
              //   onTap: _canGoBack ? () async {
              //     if (_webViewController != null) {
              //       if (await _webViewController!.canGoBack()) {
              //         await _webViewController!.goBack();
              //       }
              //     }
              //   } : null,
              //   height: preferredSize.height,
              //   child: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.primary, size: 30)
              // ),
              // AppBarIconArea(
              //   onTap: _canGoForward ? () async {
              //     if (_webViewController != null) {
              //       if (await _webViewController!.canGoForward()) {
              //         await _webViewController!.goForward();
              //       }
              //     }
              //   } : null,
              //   height: preferredSize.height,
              //   child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.primary, size: 30)
              // ),
              AppBarIconArea(
                onTap: () => _saveFile(_url, _fileName),
                height: preferredSize.height,
                child: Icon(Icons.download, color: Theme.of(context).colorScheme.primary, size: 30)
              )
            ],
          );
        },
      ),
      body: syncfusion_pdf_viewer.SfPdfViewer.network(
        _url,
        controller: _pdfViewerController,
        headers: _header != null ? _header!.map(
          (key, value) => MapEntry<String, String>(
            key, value as String
          )
        ) : {},
        pageLayoutMode: syncfusion_pdf_viewer.PdfPageLayoutMode.single,
        onDocumentLoaded: (details) {

        }
      )
    );
  }

  Future<bool> _saveFile(String url, String fileName) async {
    DialogHelper.showLoadingDialog(context);
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      late Permission permission;
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt >= 33) {
          permission = Permission.manageExternalStorage;
        } else {
          permission = Permission.storage;
        }
      } else {
        permission = Permission.storage;
      }
      if (await _requestPermission(permission)) {
        Directory? directory;
        directory = await getExternalStorageDirectory();
        String newPath = "";
        List<String> paths = directory!.path.split("/");
        for (int x = 1; x < paths.length; x++) {
          String folder = paths[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/masterbagasi_pdf_download";
        directory = Directory(newPath);
        File saveFile = File('${directory.path}/$fileName');
        if (kDebugMode) {
          print(saveFile.path);
        }
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }
        if (await directory.exists()) {
          Dio dio = Injector.locator<Dio>();
          await dio.download(
            "",
            saveFile.path,
            options: OptionsBuilder.withBaseUrl(url).buildExtended()
          );
          ToastHelper.showToast(
            MultiLanguageString({
              Constant.textInIdLanguageKey: "Download pdf sukses.",
              Constant.textEnUsLanguageKey: "Download pdf success."
            }).toStringNonNull
          );
          OpenResult openResult = await OpenFile.open(saveFile.path);
          if (openResult.type != ResultType.done) {
            throw MultiLanguageMessageError(
              title: MultiLanguageString({
                Constant.textEnUsLanguageKey: "Open Invoice File Failed",
                Constant.textInIdLanguageKey: "Buka File Invoice Gagal"
              }),
              message: MultiLanguageString({
                Constant.textEnUsLanguageKey: openResult.message,
                Constant.textInIdLanguageKey: openResult.message
              })
            );
          }
        }
      }
      Get.back();
      return true;
    } catch (e) {
      Get.back();
      DialogHelper.showFailedModalBottomDialogFromErrorProvider(
        context: context,
        errorProvider: Injector.locator<ErrorProvider>(),
        e: e
      );
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }
}