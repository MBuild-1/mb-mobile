import 'package:masterbagasi/misc/ext/string_ext.dart';

extension DoubleStringExt on String? {
  double parseDoubleWithAdditionalChecking() {
    return double.parse(toEmptyStringNonNull.replaceAll(",", "."));
  }

  double? tryParseDoubleWithAdditionalChecking() {
    return double.tryParse(toEmptyStringNonNull.replaceAll(",", "."));
  }
}