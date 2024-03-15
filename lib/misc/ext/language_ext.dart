import 'package:masterbagasi/misc/ext/string_ext.dart';

extension LanguageStringExt on String? {
  bool get isLanguageFromSystem => toEmptyStringNonNull.contains("-1") || isEmptyString;
  bool get isNotLanguageFromSystem => !isLanguageFromSystem;
}