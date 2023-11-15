import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart' as in_app_web_view;
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'constant.dart';

abstract class WebLaunchUrlType {
  const WebLaunchUrlType();
}

class NativeWebLaunchUrlType extends WebLaunchUrlType {
  const NativeWebLaunchUrlType();
}

class WebViewWebLaunchUrlType extends WebLaunchUrlType {
  BuildContext Function() onGetBuildContext;
  Map<String, dynamic> header;

  WebViewWebLaunchUrlType({
    required this.onGetBuildContext,
    required this.header
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
      final in_app_web_view.InAppBrowser browser = in_app_web_view.InAppBrowser();
      await browser.openUrlRequest(
        urlRequest: in_app_web_view.URLRequest(
          url: uri,
          headers: webLaunchUrlType.header.map(
            (key, value) => MapEntry<String, String>(
              key, value as String
            )
          )
        ),
        options: in_app_web_view.InAppBrowserClassOptions(
          android: in_app_web_view.AndroidInAppBrowserOptions(),
          ios: in_app_web_view.IOSInAppBrowserOptions(),
          crossPlatform: in_app_web_view.InAppBrowserOptions(),
        ),
      );
    }
  }
}

// ignore: non_constant_identifier_names
final _WebHelperImpl WebHelper = _WebHelperImpl();