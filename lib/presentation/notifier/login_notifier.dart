import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/loginorregister/login_or_register_with_apple_via_callback_parameter.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/login_or_register_with_apple_via_callback_use_case.dart';
import '../../misc/error/token_empty_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/manager/api_request_manager.dart';

class LoginNotifier extends ChangeNotifier {
  late ApiRequestManager apiRequestManager;

  final GetUserUseCase getUserUseCase;
  final LoginOrRegisterWithAppleViaCallbackUseCase loginOrRegisterWithAppleViaCallbackUseCase;

  LoadDataResult<User> _loggedUserProfileLoadDataResult = NoLoadDataResult<User>();
  LoadDataResult<User> get loggedUserProfileLoadDataResult => _loggedUserProfileLoadDataResult;

  LoginNotifier(
    this.getUserUseCase,
    this.loginOrRegisterWithAppleViaCallbackUseCase
  ) {
    apiRequestManager = ApiRequestManager();
    notifyListeners();
  }

  void loadProfile() async {
    if (LoginHelper.getTokenWithBearer().result.isEmptyString) {
      _loggedUserProfileLoadDataResult = FailedLoadDataResult.throwException<User>(() => throw TokenEmptyError())!;
      notifyListeners();
      return;
    }
    _loggedUserProfileLoadDataResult = IsLoadingLoadDataResult<User>();
    notifyListeners();
    _loggedUserProfileLoadDataResult = await getUserUseCase.execute(
      GetUserParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("logged-user-profile").value
    ).map<User>(
      (getUserResponse) => getUserResponse.user
    );
    notifyListeners();
  }

  Future<LoadDataResult<User>> loadUser() async {
    return getUserUseCase.execute(
      GetUserParameter()
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("logged-user-profile").value
    ).map<User>(
      (getUserResponse) => getUserResponse.user
    );
  }

  Future<LoadDataResult<LoginResponse>> loginOrRegisterWithAppleViaCallback(String link) {
    return loginOrRegisterWithAppleViaCallbackUseCase.execute(
      LoginOrRegisterWithAppleViaCallbackParameter(link: link)
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("login-or-register-with-apple-via-callback").value
    ).map<LoginResponse>(
      (response) => response.loginResponse
    );
  }
}