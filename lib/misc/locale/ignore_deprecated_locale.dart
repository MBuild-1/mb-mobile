import 'dart:ui';

import 'package:masterbagasi/misc/ext/string_ext.dart';

class IgnoreDeprecatedLocale extends Locale {
  IgnoreDeprecatedLocale(
    String languageCode, [
    String? countryCode,
  ]) : super(
    languageCode,
    countryCode
  );

  IgnoreDeprecatedLocale.fromSubtags({
    String languageCode = 'und',
    String? scriptCode,
    String? countryCode,
  }): super.fromSubtags(
    languageCode: languageCode,
    scriptCode: scriptCode,
    countryCode: countryCode
  );

  @override
  String get languageCode {
    String currentLanguageCode = super.languageCode;
    if (currentLanguageCode.isNotEmptyString) {
      if (currentLanguageCode.toLowerCase() == "id") {
        currentLanguageCode = "in";
      }
    }
    return currentLanguageCode;
  }
}