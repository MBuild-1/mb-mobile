import 'package:hive/hive.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';

abstract class _SelectedLanguageBasedIndexValueHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveSelectedLanguageBasedIndexValue(String saveSelectedLanguageBasedIndexValue);
  DefaultProcessing<String> getSelectedLanguageBasedIndexValue();
  FutureProcessing<LoadDataResult<void>> deleteSelectedLanguageBasedIndexValue();
}

class _DefaultSelectedLanguageBasedIndexValueHelperImpl implements _SelectedLanguageBasedIndexValueHelperImpl {
  @override
  FutureProcessing<LoadDataResult<void>> saveSelectedLanguageBasedIndexValue(String saveSelectedLanguageBasedIndexValue) {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.put(Constant.saveSelectedLanguageBasedIndexValueHiveTableKey, saveSelectedLanguageBasedIndexValue).getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getSelectedLanguageBasedIndexValue() {
    try {
      var box = Hive.box(Constant.settingHiveTable);
      return DefaultProcessing(box.get(Constant.saveSelectedLanguageBasedIndexValueHiveTableKey, defaultValue: ""));
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteSelectedLanguageBasedIndexValue() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.saveSelectedLanguageBasedIndexValueHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final _DefaultSelectedLanguageBasedIndexValueHelperImpl SelectedLanguageBasedIndexValueHelper = _DefaultSelectedLanguageBasedIndexValueHelperImpl();