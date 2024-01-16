import 'package:hive/hive.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';

abstract class _TempOrderDetailBackResultDataHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveTempOrderDetailBackResult(String tempPaymentInstruction);
  DefaultProcessing<String> getTempOrderDetailBackResult();
  FutureProcessing<LoadDataResult<void>> deleteTempOrderDetailBackResult();
}

class _DefaultTempOrderDetailBackResultDataHelperImpl implements _TempOrderDetailBackResultDataHelperImpl {
  @override
  FutureProcessing<LoadDataResult<void>> saveTempOrderDetailBackResult(String tempOrderDetailBackResult) {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.put(Constant.tempOrderDetailBackResultHiveTableKey, tempOrderDetailBackResult).getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getTempOrderDetailBackResult() {
    try {
      var box = Hive.box(Constant.settingHiveTable);
      return DefaultProcessing(box.get(Constant.tempOrderDetailBackResultHiveTableKey, defaultValue: ''));
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteTempOrderDetailBackResult() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.tempOrderDetailBackResultHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final _TempOrderDetailBackResultDataHelperImpl TempOrderDetailBackResultDataHelper = _DefaultTempOrderDetailBackResultDataHelperImpl();