import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/forgotpassword/forgot_password_parameter.dart';
import '../domain/entity/forgotpassword/forgot_password_response.dart';
import '../domain/usecase/forgot_password_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/typedef.dart';
import '../misc/validation/validator/email_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/forgot_password_validator_group.dart';
import 'base_getx_controller.dart';

typedef _OnGetForgotPasswordInput = String Function();
typedef _OnForgotPasswordBack = void Function();
typedef _OnShowForgotPasswordRequestProcessLoadingCallback = Future<void> Function();
typedef _OnForgotPasswordRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowForgotPasswordRequestProcessFailedCallback = Future<void> Function(dynamic e);

class ForgotPasswordController extends BaseGetxController {
  final ForgotPasswordUseCase forgotPasswordUseCase;

  late Rx<Validator> emailValidatorRx;
  late final ForgotPasswordValidatorGroup forgotPasswordValidatorGroup;

  ForgotPasswordDelegate? _forgotPasswordDelegate;

  ForgotPasswordController(
    ControllerManager? controllerManager,
    this.forgotPasswordUseCase
  ) : super(controllerManager) {
    forgotPasswordValidatorGroup = ForgotPasswordValidatorGroup(
      emailValidator: EmailValidator(
        email: () => _forgotPasswordDelegate!.onGetEmailForgotPasswordInput()
      ),
    );
    emailValidatorRx = forgotPasswordValidatorGroup.emailValidator.obs;
  }

  ForgotPasswordController setForgotPasswordDelegate(ForgotPasswordDelegate forgotPasswordDelegate) {
    _forgotPasswordDelegate = forgotPasswordDelegate;
    return this;
  }

  void forgotPassword() async {
    if (_forgotPasswordDelegate != null) {
      _forgotPasswordDelegate!.onUnfocusAllWidget();
      if (forgotPasswordValidatorGroup.validate()) {
        _forgotPasswordDelegate!.onShowForgotPasswordRequestProcessLoadingCallback();
        LoadDataResult<ForgotPasswordResponse> forgotPasswordLoadDataResult = await forgotPasswordUseCase.execute(
          ForgotPasswordParameter(
            email: _forgotPasswordDelegate!.onGetEmailForgotPasswordInput()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('forgot-password').value
        );
        Get.back();
        if (forgotPasswordLoadDataResult.isSuccess) {
          _forgotPasswordDelegate!.onForgotPasswordRequestProcessSuccessCallback();
        } else {
          _forgotPasswordDelegate!.onShowForgotPasswordRequestProcessFailedCallback(forgotPasswordLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class ForgotPasswordDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetForgotPasswordInput onGetEmailForgotPasswordInput;
  _OnForgotPasswordBack onLoginBack;
  _OnShowForgotPasswordRequestProcessLoadingCallback onShowForgotPasswordRequestProcessLoadingCallback;
  _OnForgotPasswordRequestProcessSuccessCallback onForgotPasswordRequestProcessSuccessCallback;
  _OnShowForgotPasswordRequestProcessFailedCallback onShowForgotPasswordRequestProcessFailedCallback;

  ForgotPasswordDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetEmailForgotPasswordInput,
    required this.onLoginBack,
    required this.onShowForgotPasswordRequestProcessLoadingCallback,
    required this.onForgotPasswordRequestProcessSuccessCallback,
    required this.onShowForgotPasswordRequestProcessFailedCallback
  });
}