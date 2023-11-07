import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/manager/controller_manager.dart';
import 'package:masterbagasi/misc/validation/validation_result.dart';

import '../domain/entity/login/login_parameter.dart';
import '../domain/entity/login/login_response.dart';
import '../domain/entity/login/login_with_google_parameter.dart';
import '../domain/entity/login/login_with_google_response.dart';
import '../domain/usecase/login_use_case.dart';
import '../domain/usecase/login_with_google_use_case.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/string_util.dart';
import '../misc/typedef.dart';
import '../misc/validation/validator/email_or_phone_number_validator.dart';
import '../misc/validation/validator/email_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/login_validator_group.dart';
import 'base_getx_controller.dart';

typedef _OnGetLoginInput = String Function();
typedef _OnLoginBack = void Function();
typedef _OnLoginIntoOneSignal = Future<LoadDataResult<String>> Function(String);
typedef _OnShowLoginRequestProcessLoadingCallback = Future<void> Function();
typedef _OnLoginRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowLoginRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnLoginWithGoogle = Future<String?> Function();
typedef _OnRequestPin = void Function(RequestPinParameter);
typedef _OnSaveTempData = Future<void> Function(String);

class LoginController extends BaseGetxController {
  final LoginUseCase loginUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;

  late EmailOrPhoneNumberValidator _emailOrPhoneNumberValidator;
  late Rx<Validator> emailValidatorRx;
  late Rx<Validator> passwordValidatorRx;
  late final LoginValidatorGroup loginValidatorGroup;

  LoginDelegate? _loginDelegate;

  String get _effectiveEmailAndPhoneNumberLoginInput {
    return StringUtil.effectiveEmailOrPhoneNumber(
      _loginDelegate!.onGetEmailAndPhoneNumberLoginInput(),
      _emailOrPhoneNumberValidator
    );
  }

  LoginController(
    ControllerManager? controllerManager,
    this.loginUseCase,
    this.loginWithGoogleUseCase
  ) : super(controllerManager) {
    _emailOrPhoneNumberValidator = EmailOrPhoneNumberValidator(
      emailOrPhoneNumber: () => _loginDelegate!.onGetEmailAndPhoneNumberLoginInput()
    );
    loginValidatorGroup = LoginValidatorGroup(
      emailOrPhoneNumberValidator: _emailOrPhoneNumberValidator,
      passwordValidator: Validator(
        onValidate: () => !_loginDelegate!.onGetEmailAndPhoneNumberLoginInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Password is required".tr}."))
      )
    );
    emailValidatorRx = loginValidatorGroup.emailOrPhoneNumberValidator.obs;
    passwordValidatorRx = loginValidatorGroup.passwordValidator.obs;
  }

  LoginController setLoginDelegate(LoginDelegate loginDelegate) {
    _loginDelegate = loginDelegate;
    return this;
  }

  void login() async {
    if (_loginDelegate != null) {
      _loginDelegate!.onUnfocusAllWidget();
      if (loginValidatorGroup.validate()) {
        _loginDelegate!.onShowLoginRequestProcessLoadingCallback();
        LoadDataResult<LoginResponse> loginLoadDataResult = await loginUseCase.execute(
          LoginParameter(
            credential: _effectiveEmailAndPhoneNumberLoginInput,
            password: _loginDelegate!.onGetPasswordLoginInput(),
            pushNotificationSubscriptionId: _loginDelegate!.onGetPushNotificationSubscriptionId()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('login').value
        );
        if (loginLoadDataResult.isSuccess) {
          if (await loginOneSignal()) {
            return;
          }
          await LoginHelper.saveToken(loginLoadDataResult.resultIfSuccess!.token).future();
          Get.back();
          _loginDelegate!.onLoginRequestProcessSuccessCallback();
        } else {
          dynamic data = loginLoadDataResult.resultIfFailed;
          if (await _checkIfNeedPinWhileLoginError(data)) {
            return;
          }
          Get.back();
          _loginDelegate!.onShowLoginRequestProcessFailedCallback(data);
        }
      }
    }
  }

  void loginWithGoogle() async {
    if (_loginDelegate != null) {
      _loginDelegate!.onUnfocusAllWidget();
      String? idToken = await _loginDelegate!.onLoginWithGoogle();
      if (idToken.isNotEmptyString) {
        _loginDelegate!.onShowLoginRequestProcessLoadingCallback();
        LoadDataResult<LoginWithGoogleResponse> loginWithGoogleLoadDataResult = await loginWithGoogleUseCase.execute(
          LoginWithGoogleParameter(
            idToken: idToken!,
            pushNotificationSubscriptionId: _loginDelegate!.onGetPushNotificationSubscriptionId()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('login-with-google').value
        );
        if (loginWithGoogleLoadDataResult.isSuccess) {
          if (await loginOneSignal()) {
            return;
          }
          await LoginHelper.saveToken(loginWithGoogleLoadDataResult.resultIfSuccess!.token).future();
          Get.back();
          _loginDelegate!.onLoginRequestProcessSuccessCallback();
        } else {
          dynamic data = loginWithGoogleLoadDataResult.resultIfFailed;
          if (await _checkIfNeedPinWhileLoginError(data)) {
            return;
          }
          Get.back();
          _loginDelegate!.onShowLoginRequestProcessFailedCallback(data);
        }
      }
    }
  }

  Future<bool> _checkIfNeedPinWhileLoginError(dynamic result) async {
    if (result is DioError) {
      dynamic data = result.response?.data;
      if (data is Map<String, dynamic>) {
        if (!data.containsKey("meta")) {
          return false;
        }
        String message = data["meta"]["message"];
        if (message.toLowerCase() == "you must input your pin") {
          String dataString = jsonEncode(data["data"]);
          await _loginDelegate!.onSaveTempData(dataString);
          Get.back();
          _loginDelegate!.onRequestPin(RequestPinParameter(data: dataString));
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> loginOneSignal() async {
    LoadDataResult<String> oneSignalLoginResult = await _loginDelegate!.onLoginIntoOneSignal(_effectiveEmailAndPhoneNumberLoginInput);
    if (oneSignalLoginResult.isFailed) {
      Get.back();
      _loginDelegate!.onShowLoginRequestProcessFailedCallback(oneSignalLoginResult.resultIfFailed);
      return true;
    }
    return false;
  }
}

class LoginDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetLoginInput onGetEmailAndPhoneNumberLoginInput;
  _OnLoginBack onLoginBack;
  _OnGetLoginInput onGetPasswordLoginInput;
  _OnShowLoginRequestProcessLoadingCallback onShowLoginRequestProcessLoadingCallback;
  _OnLoginRequestProcessSuccessCallback onLoginRequestProcessSuccessCallback;
  _OnShowLoginRequestProcessFailedCallback onShowLoginRequestProcessFailedCallback;
  _OnRequestPin onRequestPin;
  _OnLoginWithGoogle onLoginWithGoogle;
  _OnSaveTempData onSaveTempData;
  _OnLoginIntoOneSignal onLoginIntoOneSignal;
  OnGetPushNotificationSubscriptionId onGetPushNotificationSubscriptionId;

  LoginDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetEmailAndPhoneNumberLoginInput,
    required this.onLoginBack,
    required this.onGetPasswordLoginInput,
    required this.onShowLoginRequestProcessLoadingCallback,
    required this.onLoginRequestProcessSuccessCallback,
    required this.onShowLoginRequestProcessFailedCallback,
    required this.onRequestPin,
    required this.onLoginWithGoogle,
    required this.onSaveTempData,
    required this.onLoginIntoOneSignal,
    required this.onGetPushNotificationSubscriptionId
  });
}

class RequestPinParameter {
  String data;

  RequestPinParameter({
    required this.data
  });
}