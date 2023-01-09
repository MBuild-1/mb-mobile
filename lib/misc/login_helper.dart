import 'package:masterbagasi/misc/ext/future_ext.dart';

import 'constant.dart';
import 'load_data_result.dart';
import 'processing/default_processing.dart';
import 'processing/future_processing.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class _LoginHelperImpl {
  FutureProcessing<LoadDataResult<void>> saveToken(String tokenWithoutBearer);
  DefaultProcessing<String> getTokenWithBearer();
  FutureProcessing<LoadDataResult<void>> deleteToken();
}

class _DefaultLoginHelperImpl implements _LoginHelperImpl {
  final String _keyword = 'Bearer';

  @override
  FutureProcessing<LoadDataResult<void>> saveToken(String tokenWithoutBearer) {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.put(Constant.settingHiveTableKey, '$_keyword $tokenWithoutBearer').getLoadDataResult();
    });
  }

  @override
  DefaultProcessing<String> getTokenWithBearer() {
    try {
      var box = Hive.box(Constant.settingHiveTable);
      return DefaultProcessing(box.get(Constant.settingHiveTableKey));
    } catch (e) {
      return DefaultProcessing('');
    }
  }

  @override
  FutureProcessing<LoadDataResult<void>> deleteToken() {
    return FutureProcessing(({parameter}) {
      var box = Hive.box(Constant.settingHiveTable);
      return box.delete(Constant.settingHiveTableKey).getLoadDataResult();
    });
  }
}

// ignore: non_constant_identifier_names
final LoginHelper = _DefaultLoginHelperImpl();