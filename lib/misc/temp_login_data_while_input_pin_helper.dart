import 'package:hive/hive.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';

abstract class _TempLoginDataWhileInputPinHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveTempLoginDataWhileInputPin(String tempLoginDataWhileInputPin);
  DefaultProcessing<String> getTempLoginDataWhileInputPin();
  FutureProcessing<LoadDataResult<void>> deleteTempLoginDataWhileInputPin();
}

class _DefaultTempLoginDataWhileInputPinHelperImpl implements _TempLoginDataWhileInputPinHelperImpl {
  @override
  FutureProcessing<LoadDataResult<void>> saveTempLoginDataWhileInputPin(String tempLoginDataWhileInputPin) {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.put(Constant.tempLoginDataWhileInputPinHiveTableKey, tempLoginDataWhileInputPin).getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getTempLoginDataWhileInputPin() {
    try {
      var box = Hive.box(Constant.settingHiveTable);
      return DefaultProcessing(box.get(Constant.tempLoginDataWhileInputPinHiveTableKey, defaultValue: false));
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteTempLoginDataWhileInputPin() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.tempLoginDataWhileInputPinHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final _TempLoginDataWhileInputPinHelperImpl TempLoginDataWhileInputPinHelper = _DefaultTempLoginDataWhileInputPinHelperImpl();