import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/register/register_parameter.dart';
import '../domain/entity/register/register_response.dart';
import '../domain/usecase/register_use_case.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/login_helper.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/typedef.dart';
import '../misc/validation/validation_result.dart';
import '../misc/validation/validator/email_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/register_validator_group.dart';
import 'base_getx_controller.dart';

typedef _OnGetRegisterInput = String Function();
typedef _OnRegisterBack = void Function();
typedef _OnShowRegisterRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRegisterRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowRegisterRequestProcessFailedCallback = Future<void> Function(dynamic e);

class RegisterController extends BaseGetxController {
  final RegisterUseCase registerUseCase;

  late Rx<Validator> emailValidatorRx;
  late Rx<Validator> passwordValidatorRx;
  late Rx<Validator> testValidatorRx;
  late final RegisterValidatorGroup registerValidatorGroup;

  RegisterDelegate? _registerDelegate;

  RegisterController(ControllerManager? controllerManager, this.registerUseCase) : super(controllerManager) {
    registerValidatorGroup = RegisterValidatorGroup(
      emailValidator: EmailValidator(
        email: () => _registerDelegate!.onGetEmailRegisterInput()
      ),
      nameValidator: Validator(
        onValidate: () => !_registerDelegate!.onGetNameRegisterInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Name is required".tr}."))
      ),
      passwordValidator: Validator(
        onValidate: () => !_registerDelegate!.onGetPasswordRegisterInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Password is required".tr}."))
      ),
      passwordConfirmationValidator: Validator(
        onValidate: () => !_registerDelegate!.onGetPasswordConfirmationRegisterInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Password confirmation is required".tr}."))
      ),
    );
    emailValidatorRx = registerValidatorGroup.emailValidator.obs;
    passwordValidatorRx = registerValidatorGroup.passwordValidator.obs;
  }

  RegisterController setRegisterDelegate(RegisterDelegate registerDelegate) {
    _registerDelegate = registerDelegate;
    return this;
  }

  void login() async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      if (registerValidatorGroup.validate()) {
        _registerDelegate!.onShowRegisterRequestProcessLoadingCallback();
        LoadDataResult<RegisterResponse> registerLoadDataResult = await registerUseCase.execute(
          RegisterParameter(
            email: _registerDelegate!.onGetEmailRegisterInput(),
            name: _registerDelegate!.onGetNameRegisterInput(),
            password: _registerDelegate!.onGetPasswordRegisterInput(),
            passwordConfirmation: _registerDelegate!.onGetPasswordConfirmationRegisterInput()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('register').value
        );
        Get.back();
        if (registerLoadDataResult.isSuccess) {
          await LoginHelper.saveToken(registerLoadDataResult.resultIfSuccess!.token).future();
          _registerDelegate!.onRegisterRequestProcessSuccessCallback();
        } else {
          _registerDelegate!.onShowRegisterRequestProcessFailedCallback(registerLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class RegisterDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnRegisterBack onRegisterBack;
  _OnGetRegisterInput onGetEmailRegisterInput;
  _OnGetRegisterInput onGetNameRegisterInput;
  _OnGetRegisterInput onGetPasswordRegisterInput;
  _OnGetRegisterInput onGetPasswordConfirmationRegisterInput;
  _OnShowRegisterRequestProcessLoadingCallback onShowRegisterRequestProcessLoadingCallback;
  _OnRegisterRequestProcessSuccessCallback onRegisterRequestProcessSuccessCallback;
  _OnShowRegisterRequestProcessFailedCallback onShowRegisterRequestProcessFailedCallback;

  RegisterDelegate({
    required this.onUnfocusAllWidget,
    required this.onRegisterBack,
    required this.onGetEmailRegisterInput,
    required this.onGetNameRegisterInput,
    required this.onGetPasswordRegisterInput,
    required this.onGetPasswordConfirmationRegisterInput,
    required this.onShowRegisterRequestProcessLoadingCallback,
    required this.onRegisterRequestProcessSuccessCallback,
    required this.onShowRegisterRequestProcessFailedCallback
  });
}