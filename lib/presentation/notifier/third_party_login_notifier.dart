import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../domain/entity/login/third_party_login_visibility.dart';
import '../../domain/entity/login/third_party_login_visibility_parameter.dart';
import '../../domain/usecase/third_party_login_visibility_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/api_request_manager.dart';

class ThirdPartyLoginNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final ThirdPartyLoginVisibilityUseCase thirdPartyLoginVisibilityUseCase;

  LoadDataResult<ThirdPartyLoginVisibility> _thirdPartyLoginVisibilityLoadDataResult = NoLoadDataResult<ThirdPartyLoginVisibility>();
  LoadDataResult<ThirdPartyLoginVisibility> get thirdPartyLoginVisibilityLoadDataResult => _thirdPartyLoginVisibilityLoadDataResult;

  ThirdPartyLoginNotifier(this.thirdPartyLoginVisibilityUseCase) {
    apiRequestManager = ApiRequestManager();
    notifyListeners();
  }

  void checkThirdPartyLoginVisibility(ThirdPartyLoginVisibilityParameter thirdPartyLoginVisibilityParameter) async {
    _thirdPartyLoginVisibilityLoadDataResult = IsLoadingLoadDataResult<ThirdPartyLoginVisibility>();
    notifyListeners();
    _thirdPartyLoginVisibilityLoadDataResult = await thirdPartyLoginVisibilityUseCase.execute(
      thirdPartyLoginVisibilityParameter
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("third-party-login-visibility").value
    );
    if (_thirdPartyLoginVisibilityLoadDataResult.isFailedBecauseCancellation) {
      return;
    }
    notifyListeners();
  }

  void resetThirdPartyLoginVisibilityValue() {
    _thirdPartyLoginVisibilityLoadDataResult = NoLoadDataResult<ThirdPartyLoginVisibility>();
  }
}