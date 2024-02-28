import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_parameter.dart';
import '../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';
import '../../domain/usecase/can_be_updated_versioning_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/api_request_manager.dart';

class VersioningNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final CanBeUpdatedVersioningUseCase canBeUpdatedVersioningUseCase;

  LoadDataResult<CanBeUpdatedVersioningResponse> _canBeUpdatedVersioningResponseLoadDataResult = NoLoadDataResult<CanBeUpdatedVersioningResponse>();
  LoadDataResult<CanBeUpdatedVersioningResponse> get canBeUpdatedVersioningResponseLoadDataResult => _canBeUpdatedVersioningResponseLoadDataResult;

  VersioningNotifierDelegate? _versioningNotifierDelegate;

  void setVersioningNotifierDelegate(VersioningNotifierDelegate versioningNotifierDelegate) {
    _versioningNotifierDelegate = versioningNotifierDelegate;
  }

  VersioningNotifier(this.canBeUpdatedVersioningUseCase) {
    apiRequestManager = ApiRequestManager();
    notifyListeners();
  }

  void checkUpdate() async {
    if (_versioningNotifierDelegate != null) {
      _canBeUpdatedVersioningResponseLoadDataResult = IsLoadingLoadDataResult<CanBeUpdatedVersioningResponse>();
      notifyListeners();
      while (!_canBeUpdatedVersioningResponseLoadDataResult.isSuccess) {
        _canBeUpdatedVersioningResponseLoadDataResult = await canBeUpdatedVersioningUseCase.execute(
          CanBeUpdatedVersioningParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart("check-update").value
        );
      }
      notifyListeners();
      _versioningNotifierDelegate!.onGetCanBeUpdatedVersioningResponse(
        _canBeUpdatedVersioningResponseLoadDataResult.resultIfSuccess!
      );
    }
  }
}

class VersioningNotifierDelegate {
  void Function(CanBeUpdatedVersioningResponse) onGetCanBeUpdatedVersioningResponse;

  VersioningNotifierDelegate({
    required this.onGetCanBeUpdatedVersioningResponse
  });
}