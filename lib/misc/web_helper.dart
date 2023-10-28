import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import 'constant.dart';

class _WebHelperImpl {
  void launchUrl(Uri uri) {
    if (Platform.isAndroid) {
      FlutterWebBrowser.openWebPage(
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
      FlutterWebBrowser.openWebPage(
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
  }
}

// ignore: non_constant_identifier_names
final _WebHelperImpl WebHelper = _WebHelperImpl();