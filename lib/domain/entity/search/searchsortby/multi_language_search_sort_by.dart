import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../misc/error/message_error.dart';
import '../../../../misc/multi_language_string.dart';
import 'search_sort_by.dart';

class MultiLanguageSearchSortBy extends SearchSortBy {
  @override
  String get name => nameMultiLanguageString.toEmptyStringNonNull;

  @override
  set name(String value) => throw MessageError(message: "You only can change name through nameMultiLanguageString field.");

  MultiLanguageString nameMultiLanguageString;

  MultiLanguageSearchSortBy({
    required this.nameMultiLanguageString,
    required super.value,
  }) : super(
    name: ""
  );
}