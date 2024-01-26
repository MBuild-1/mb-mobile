// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:get/get.dart';

import 'error/message_error.dart';
import 'response_translation_helper.dart';

class MultiLanguageString {
  dynamic value;

  MultiLanguageString(this.value);

  @override
  String toString() {
    if (value is TrMultiLanguageStringValue) {
      return (value as TrMultiLanguageStringValue).text.tr;
    } else {
      return ResponseTranslationHelper.translateResponse(value).toString();
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other is MultiLanguageString && runtimeType == other.runtimeType) {
      if (value is Map<String, dynamic> && other.value is Map<String, dynamic>) {
        return const DeepCollectionEquality().equals(value, other.value);
      } else {
        return value == other.value;
      }
    } else {
      return false;
    }
  }

  @override
  int get hashCode => value.hashCode;
}

class TrMultiLanguageStringValue {
  final String text;

  TrMultiLanguageStringValue({
    required this.text
  });
}