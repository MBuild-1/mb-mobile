import 'package:flutter/material.dart';

class LocaleWidgetBindingObserver extends WidgetsBindingObserver {
  void Function() onUpdateWhileDeviceLocaleIsChange;

  LocaleWidgetBindingObserver({
    required this.onUpdateWhileDeviceLocaleIsChange
  });

  @override
  void didChangeLocales(List<Locale>? locales) {
    onUpdateWhileDeviceLocaleIsChange();
  }
}