import 'package:hive/hive.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/selectlanguage/select_language.dart';
import 'constant.dart';
import 'multi_language_string.dart';
import 'processing/default_processing.dart';
import 'selected_language_based_index_value_helper.dart';
import 'selected_language_helper.dart';

class _LanguageHelperImpl {
  List<SelectLanguage> get selectLanguageList => <SelectLanguage>[
    SelectLanguage(
      nameMultiLanguageString: MultiLanguageString({
        Constant.textInIdLanguageKey: "Bahasa Dari Sistem",
        Constant.textEnUsLanguageKey: "Language From System",
      }),
      localeString: "",
      indexValue: "-1"
    ),
    SelectLanguage(
      nameMultiLanguageString: MultiLanguageString("Indonesia"),
      localeString: Constant.textInIdLanguageKey,
      indexValue: "0"
    ),
    SelectLanguage(
      nameMultiLanguageString: MultiLanguageString("English (United States)"),
      localeString: Constant.textEnUsLanguageKey,
      indexValue: "1"
    )
  ];

  DefaultProcessing<String> getSelectedLanguage() {
    return DefaultProcessing(() {
      String selectedLanguageIndexValueString = SelectedLanguageBasedIndexValueHelper.getSelectedLanguageBasedIndexValue().result;
      List<SelectLanguage> cachedSelectLanguageList = selectLanguageList;
      if (selectedLanguageIndexValueString.isNotEmptyString) {
        Iterable<SelectLanguage> filteredCachedSelectLanguageIterable = cachedSelectLanguageList.where(
          (selectLanguage) => selectLanguage.indexValue == selectedLanguageIndexValueString
        );
        if (filteredCachedSelectLanguageIterable.isNotEmpty) {
          filteredCachedSelectLanguageIterable.first.localeString;
        }
      }
      String selectedLanguageLocaleString = SelectedLanguageHelper.getSelectedLanguage().result;
      // If language configuration is never changed then set default selected language
      if (selectedLanguageIndexValueString.isEmptyString && selectedLanguageLocaleString.isEmptyString) {
        // Default selected language: Indonesia
        return selectLanguageList[1].localeString;
      }
      return selectedLanguageLocaleString;
    }());
  }
}

// ignore: non_constant_identifier_names
final _LanguageHelperImpl LanguageHelper = _LanguageHelperImpl();