import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';
import '../../domain/usecase/versioning_based_filter_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/api_request_manager.dart';

class VersioningNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final VersioningBasedFilterUseCase versioningBasedFilterUseCase;

  LoadDataResult<VersioningBasedFilterResponse> _specifiedVersioningBasedFilterResponseLoadDataResult = NoLoadDataResult<VersioningBasedFilterResponse>();
  LoadDataResult<VersioningBasedFilterResponse> get specifiedVersioningBasedFilterResponseLoadDataResult => _specifiedVersioningBasedFilterResponseLoadDataResult;

  VersioningNotifierDelegate? _versioningNotifierDelegate;

  void setVersioningNotifierDelegate(VersioningNotifierDelegate versioningNotifierDelegate) {
    _versioningNotifierDelegate = versioningNotifierDelegate;
  }

  VersioningNotifier(this.versioningBasedFilterUseCase) {
    apiRequestManager = ApiRequestManager();
    notifyListeners();
  }

  void checkUpdate(VersioningBasedFilterParameter versioningBasedFilterParameter) async {
    if (_versioningNotifierDelegate != null) {
      _specifiedVersioningBasedFilterResponseLoadDataResult = IsLoadingLoadDataResult<VersioningBasedFilterResponse>();
      notifyListeners();
      while (!_specifiedVersioningBasedFilterResponseLoadDataResult.isSuccess) {
        _specifiedVersioningBasedFilterResponseLoadDataResult = await versioningBasedFilterUseCase.execute(
          versioningBasedFilterParameter
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("check-update").value
        );
        if (_specifiedVersioningBasedFilterResponseLoadDataResult.isFailed) {
          dynamic e = _specifiedVersioningBasedFilterResponseLoadDataResult.resultIfFailed;
          if (e is DioError) {
            if ((e.response?.data["meta"]["message"] as String?).toEmptyStringNonNull.toLowerCase().contains("version not found")) {
              return;
            }
          }
        }
      }
      notifyListeners();
      _versioningNotifierDelegate!.onGetSpecifiedVersioningBasedFilterResponse(
        _specifiedVersioningBasedFilterResponseLoadDataResult.resultIfSuccess!
      );
    }
  }
}

class VersioningNotifierDelegate {
  void Function(VersioningBasedFilterResponse) onGetSpecifiedVersioningBasedFilterResponse;

  VersioningNotifierDelegate({
    required this.onGetSpecifiedVersioningBasedFilterResponse
  });
}