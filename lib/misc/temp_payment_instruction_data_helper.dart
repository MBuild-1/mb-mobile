import 'package:hive/hive.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';

abstract class _TempPaymentInstructionDataHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveTempPaymentInstruction(String tempPaymentInstruction);
  DefaultProcessing<String> getTempPaymentInstruction();
  FutureProcessing<LoadDataResult<void>> deleteTempPaymentInstruction();
}

class _DefaultTempPaymentInstructionDataHelperImpl implements _TempPaymentInstructionDataHelperImpl {
  @override
  FutureProcessing<LoadDataResult<void>> saveTempPaymentInstruction(String tempPaymentInstruction) {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.put(Constant.tempPaymentInstructionHiveTableKey, tempPaymentInstruction).getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getTempPaymentInstruction() {
    try {
      var box = Hive.box(Constant.settingHiveTable);
      return DefaultProcessing(box.get(Constant.tempPaymentInstructionHiveTableKey, defaultValue: false));
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteTempPaymentInstruction() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.tempPaymentInstructionHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final _TempPaymentInstructionDataHelperImpl TempPaymentInstructionDataHelper = _DefaultTempPaymentInstructionDataHelperImpl();