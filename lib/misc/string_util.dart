import 'dart:convert';
import 'dart:math';

import 'package:get/utils.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:validators/validators.dart';

import 'constant.dart';
import 'duration_string.dart';
import 'multi_language_string.dart';
import 'validation/validation_result.dart';
import 'validation/validationresult/is_phone_number_success_validation_result.dart';
import 'validation/validator/validator.dart';

class _StringUtilImpl {
  static const _sizeSuffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

  String filterNumber(String input) {
    String result = "";
    for (int i = 0; i < input.length; i++) {
      if (input[i].isNumericOnly) {
        result += input[i];
      }
    }
    return result;
  }

  String filterNumberAndDecimal(String input) {
    String result = "";
    for (int i = 0; i < input.length; i++) {
      if (input[i].isNumericOnly || input[i] == "." || input[i] == ",") {
        result += input[i];
      }
    }
    return result;
  }

  String addUppercaseInFirstCharacter(String text) {
    String result = "";
    for (int i = 0; i < text.length; i++) {
      result += i == 0 ? text[i].toUpperCase() : text[i];
    }
    return result;
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + _sizeSuffixes[i];
  }

  int fromByteStringToInt(String size) {
    String tempSize = "";
    String tempSizeSuffix = "";
    for (int i = 0; i < size.length; i++) {
      String c = size[i];
      if (isNumeric(c) || c == "." || c == ",") {
        tempSize += c;
      } else if (isAlpha(c)) {
        tempSizeSuffix += c.toUpperCase();
      }
    }
    int index = _sizeSuffixes.indexOf(tempSizeSuffix);
    return (double.parse(tempSize) * (10 ^ index)).toInt();
  }

  String removeSeparatorInThousandNumber(String numberText) {
    String result = "";
    for (int i = numberText.length - 1; i >= 0; i--) {
      if (_isNumber(numberText[i])) {
        result = numberText[i] + result;
      }
    }
    return result;
  }

  String removeOtherThanAlphabet(String text) {
    String result = "";
    for (int i = text.length - 1; i >= 0; i--) {
      if (_isAlphabet(text[i])) {
        result = text[i] + result;
      }
    }
    return result;
  }

  String addDotSeparatorInNumber(String numberText, String separator) {
    String result = "";
    for (int i = numberText.length - 1; i >= 0; i--) {
      if ((numberText.length - 1 - i) % 3 == 0 && i != numberText.length - 1) {
        result = separator[0] + result;
      }
      if (_isNumber(numberText[i])) {
        result = numberText[i] + result;
      }
    }
    return result;
  }

  bool _isNumber(String char) {
    int charCodeUnit = char.codeUnitAt(0);
    return charCodeUnit >= 48 && charCodeUnit <= 57;
  }

  bool _isAlphabet(String char) {
    int charCodeUnit = char.codeUnitAt(0);
    return (charCodeUnit >= 65 && charCodeUnit <= 90) || (charCodeUnit >= 97 && charCodeUnit <= 122);
  }

  dynamic decodeBase64String(String encodedBase64String) {
    return utf8.decode(base64.decode(encodedBase64String));
  }

  String encodeBase64String(String value) {
    return base64.encode(utf8.encode(value));
  }

  String encodeJson(dynamic value) {
    return json.encode(value);
  }

  dynamic decodeJson(String jsonString) {
    return json.decode(jsonString);
  }

  String encodeBase64StringFromJson(dynamic value) {
    return encodeBase64String(encodeJson(value));
  }

  dynamic decodeBase64StringToJson(String encodedBase64JsonString) {
    return decodeJson(decodeBase64String(encodedBase64JsonString));
  }

  DurationString toDurationStringFromMilliSeconds(int milliseconds) {
    Duration duration = Duration(milliseconds: milliseconds);
    int hours = duration.inHours;
    int minutes = (duration.inMinutes % 60);
    int seconds = (duration.inSeconds % 60);
    return DurationString(
      hoursString: (hours < 10) ? '0$hours' : '$hours',
      minutesString: (minutes < 10) ? '0$minutes' : '$minutes',
      secondsString: (seconds < 10) ? '0$seconds' : '$seconds'
    );
  }

  String? convertYoutubeLinkUrlToId(String url, {bool trimWhitespaces = true}) {
    if (!url.contains("http") && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();
    for (var exp in [
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:music\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube\.com\/shorts\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  String tokenWithBearer(String tokenWithoutBearer) {
    return "Bearer $tokenWithoutBearer";
  }

  String effectiveEmailOrPhoneNumber(String emailOrPhoneNumber, Validator emailOrPhoneNumberValidator) {
    // ignore: invalid_use_of_protected_member
    ValidationResult emailOrPhoneNumberValidationResult = emailOrPhoneNumberValidator.validating();
    if (emailOrPhoneNumberValidationResult.isSuccess) {
      if (emailOrPhoneNumberValidationResult is IsPhoneNumberSuccessValidationResult) {
        String result = "";
        for (int i = 0; i < emailOrPhoneNumber.length; i++) {
          String c = emailOrPhoneNumber[i];
          if (c.isNum) {
            result += c;
          }
          if (result.length == 1) {
            if (result == "0") {
              result = "62";
            }
          }
        }
        return result;
      }
    }
    return emailOrPhoneNumber;
  }

  String effectivePhoneNumber(String phoneNumber) {
    String result = "";
    for (int i = 0; i < phoneNumber.length; i++) {
      String c = phoneNumber[i];
      if (c.isNum) {
        result += c;
      }
      if (result.length == 1) {
        if (result == "0") {
          result = "62";
        }
      }
    }
    return result;
  }
}

// ignore: non_constant_identifier_names
var StringUtil = _StringUtilImpl();