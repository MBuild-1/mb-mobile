import 'package:intl/intl.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/multi_language_string.dart';

import 'constant.dart';
import 'dateformat/anthony_input_date_format.dart';

class _DateUtilImpl {
  String get _currentLocale => MultiLanguageString({
    Constant.textEnUsLanguageKey: "en_US",
    Constant.textInIdLanguageKey: "id"
  }).toEmptyStringNonNull;
  DateFormat get standardDateFormat => DateFormat("yyyy-MM-dd HH:mm:ss", _currentLocale);
  DateFormat get standardDateFormat2 => DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'", _currentLocale);
  DateFormat get standardDateFormat3 => DateFormat("yyyy-MM-dd", _currentLocale);
  DateFormat get standardDateFormat4 => DateFormat("dd MMMM yyyy", _currentLocale);
  DateFormat get standardDateFormat5 => DateFormat("MMMM yyyy", _currentLocale);
  DateFormat get standardDateFormat6 => DateFormat("dd MMMM yyyy HH:mm:ss", _currentLocale);
  DateFormat get standardDateFormat7 => DateFormat("dd MMM yyyy", _currentLocale);
  DateFormat get standardDateFormat8 => DateFormat("dd MMM yyyy HH:mm:ss", _currentLocale);
  DateFormat get standardDateFormat9 => DateFormat("dd MMM", _currentLocale);
  DateFormat get standardDateFormat10 => DateFormat("dd MMMM yyyy, HH:mm:ss", _currentLocale);
  DateFormat get standardTimeFormat => DateFormat("HH:mm:ss", _currentLocale);
  DateFormat get standardHourMinuteTimeFormat => DateFormat("HH:mm", _currentLocale);
  DateFormat get anthonyInputDateFormat => AnthonyInputDateFormat();

  String formatDateBasedTodayOrNot(DateTime? willBeFormatting) {
    return willBeFormatting == null ? "(Empty)" : (
      willBeFormatting == DateTime.now() ? standardHourMinuteTimeFormat.format(willBeFormatting) : standardDateFormat4.format(willBeFormatting)
    );
  }

  DateTime convertUtcOffset(DateTime dateTime, int newUtcOffset) {
    Duration offsetDifference = Duration(hours: newUtcOffset - dateTime.timeZoneOffset.inHours);
    DateTime convertedDateTime = dateTime.add(offsetDifference);
    return convertedDateTime;
  }
}

// ignore: non_constant_identifier_names
var DateUtil = _DateUtilImpl();