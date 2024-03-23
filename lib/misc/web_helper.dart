import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as in_app_web_view;
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'constant.dart';
import 'page_restoration_helper.dart';

abstract class WebLaunchUrlType {
  const WebLaunchUrlType();
}

class NativeWebLaunchUrlType extends WebLaunchUrlType {
  const NativeWebLaunchUrlType();
}

class WebViewWebLaunchUrlType extends WebLaunchUrlType {
  BuildContext Function() onGetBuildContext;
  Map<String, dynamic> header;
  bool canShare;

  WebViewWebLaunchUrlType({
    required this.onGetBuildContext,
    this.header = const {},
    this.canShare = true
  });
}

class _WebHelperImpl {
  Future<void> launchUrl(Uri uri, {WebLaunchUrlType webLaunchUrlType = const NativeWebLaunchUrlType()}) async {
    if (webLaunchUrlType is NativeWebLaunchUrlType) {
      if (Platform.isAndroid) {
        return await FlutterWebBrowser.openWebPage(
          url: uri.toString(),
          customTabsOptions: CustomTabsOptions(
            colorScheme: CustomTabsColorScheme.dark,
            darkColorSchemeParams: CustomTabsColorSchemeParams(
              toolbarColor: Constant.colorMain,
              secondaryToolbarColor: Constant.colorMain,
              navigationBarColor: Colors.black,
              navigationBarDividerColor: Colors.black,
            ),
            shareState: CustomTabsShareState.on,
            instantAppsEnabled: true,
            showTitle: true,
            urlBarHidingEnabled: true,
          ),
        );
      } else if (Platform.isIOS) {
        return await FlutterWebBrowser.openWebPage(
          url: uri.toString(),
          safariVCOptions: SafariViewControllerOptions(
            barCollapsingEnabled: true,
            preferredBarTintColor: Constant.colorMain,
            preferredControlTintColor: Constant.colorMain,
            dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
            modalPresentationCapturesStatusBarAppearance: true,
            modalPresentationStyle: UIModalPresentationStyle.popover,
          ),
        );
      }
    } else if (webLaunchUrlType is WebViewWebLaunchUrlType) {
      PageRestorationHelper.toWebViewerPage(
        webLaunchUrlType.onGetBuildContext(),
        <String, dynamic>{
          Constant.textUrlKey: uri.toString(),
          if (webLaunchUrlType.header.isNotEmpty) ...{
            Constant.textHeaderKey: webLaunchUrlType.header.map(
              (key, value) => MapEntry<String, String>(
                key, value as String
              )
            ),
          },
          Constant.textCanShareKey: webLaunchUrlType.canShare ? "1" : "0"
        }
      );
    }
  }
}

// ignore: non_constant_identifier_names
final _WebHelperImpl WebHelper = _WebHelperImpl();