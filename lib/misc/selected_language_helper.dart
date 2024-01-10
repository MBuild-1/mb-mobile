import 'package:hive/hive.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';

abstract class _SelectedLanguageHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveSelectedLanguage(String tempLoginDataWhileInputPin);
  DefaultProcessing<String> getSelectedLanguage();
  FutureProcessing<LoadDataResult<void>> deleteSelectedLanguage();
}

class _DefaultSelectedLanguageHelperImpl implements _SelectedLanguageHelperImpl {
  @override
  FutureProcessing<LoadDataResult<void>> saveSelectedLanguage(String saveSelectedLanguage) {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.put(Constant.saveSelectedLanguageHiveTableKey, saveSelectedLanguage).getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getSelectedLanguage() {
    try {
      var box = Hive.box(Constant.settingHiveTable);
      return DefaultProcessing(box.get(Constant.saveSelectedLanguageHiveTableKey, defaultValue: ""));
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteSelectedLanguage() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.saveSelectedLanguageHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final _DefaultSelectedLanguageHelperImpl SelectedLanguageHelper = _DefaultSelectedLanguageHelperImpl();