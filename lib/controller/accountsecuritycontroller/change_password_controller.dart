import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/changepassword/change_password_parameter.dart';
import '../../domain/entity/changepassword/change_password_response.dart';
import '../../domain/usecase/change_password_use_case.dart';
import '../../misc/error/validation_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/typedef.dart';
import '../../misc/validation/validation_result.dart';
import '../../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/validation/validatorgroup/change_password_validator_group.dart';
import '../base_getx_controller.dart';

typedef _OnGetChangePasswordInput = String Function();
typedef _OnChangePasswordBack = void Function();
typedef _OnShowChangePasswordRequestProcessLoadingCallback = Future<void> Function();
typedef _OnChangePasswordRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowChangePasswordRequestProcessFailedCallback = Future<void> Function(dynamic e);

class ChangePasswordController extends BaseGetxController {
  final ChangePasswordUseCase changePasswordUseCase;

  late Rx<PasswordCompoundValidator> passwordCompoundValidatorRx;
  late final ChangePasswordValidatorGroup changePasswordValidatorGroup;

  ChangePasswordDelegate? _changePasswordDelegate;

  ChangePasswordController(
    super.controllerManager,
    this.changePasswordUseCase
  ) {
    changePasswordValidatorGroup = ChangePasswordValidatorGroup(
      passwordCompoundValidator: PasswordCompoundValidator(
        passwordValidator: Validator(
          onValidate: () => !_changePasswordDelegate!.onGetNewPasswordInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Password is required".tr}."))
        ),
        passwordConfirmationValidator: Validator(
          onValidate: () {
            String password = _changePasswordDelegate!.onGetNewPasswordInput();
            String passwordConfirmation = _changePasswordDelegate!.onGetConfirmNewPasswordInput();
            if (password != passwordConfirmation) {
              return FailedValidationResult(e: ValidationError(message: "${"Password must be same with password confirmation".tr}."));
            } else {
              return SuccessValidationResult();
            }
          }
        )
      )
    );
    passwordCompoundValidatorRx = changePasswordValidatorGroup.passwordCompoundValidator.obs;
  }

  ChangePasswordController setChangePasswordDelegate(ChangePasswordDelegate changePasswordDelegate) {
    _changePasswordDelegate = changePasswordDelegate;
    return this;
  }

  void changePassword() async {
    if (_changePasswordDelegate != null) {
      _changePasswordDelegate!.onUnfocusAllWidget();
      if (changePasswordValidatorGroup.validate()) {
        _changePasswordDelegate!.onShowChangePasswordRequestProcessLoadingCallback();
        LoadDataResult<ChangePasswordResponse> changePasswordLoadDataResult = await changePasswordUseCase.execute(
          ChangePasswordParameter(
            newPassword: _changePasswordDelegate!.onGetNewPasswordInput(),
            confirmNewPassword: _changePasswordDelegate!.onGetConfirmNewPasswordInput(),
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('change-password').value
        );
        Get.back();
        if (changePasswordLoadDataResult.isSuccess) {
          _changePasswordDelegate!.onChangePasswordRequestProcessSuccessCallback();
        } else {
          _changePasswordDelegate!.onShowChangePasswordRequestProcessFailedCallback(changePasswordLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class ChangePasswordDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetChangePasswordInput onGetNewPasswordInput;
  _OnGetChangePasswordInput onGetConfirmNewPasswordInput;
  _OnChangePasswordBack onChangePasswordBack;
  _OnShowChangePasswordRequestProcessLoadingCallback onShowChangePasswordRequestProcessLoadingCallback;
  _OnChangePasswordRequestProcessSuccessCallback onChangePasswordRequestProcessSuccessCallback;
  _OnShowChangePasswordRequestProcessFailedCallback onShowChangePasswordRequestProcessFailedCallback;

  ChangePasswordDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetNewPasswordInput,
    required this.onGetConfirmNewPasswordInput,
    required this.onChangePasswordBack,
    required this.onShowChangePasswordRequestProcessLoadingCallback,
    required this.onChangePasswordRequestProcessSuccessCallback,
    required this.onShowChangePasswordRequestProcessFailedCallback
  });
}