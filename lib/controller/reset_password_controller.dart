import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../domain/entity/resetpassword/check/check_reset_password_parameter.dart';
import '../domain/entity/resetpassword/check/check_reset_password_response.dart';
import '../domain/entity/resetpassword/reset_password_parameter.dart';
import '../domain/entity/resetpassword/reset_password_response.dart';
import '../domain/entity/resetpassword/whatsapp/check/whatsapp_check_reset_password_parameter.dart';
import '../domain/entity/resetpassword/whatsapp/whatsapp_reset_password_parameter.dart';
import '../domain/entity/user/user.dart';
import '../domain/usecase/check_reset_password_use_case.dart';
import '../domain/usecase/reset_password_use_case.dart';
import '../misc/ValidatorHelper.dart';
import '../misc/error/message_error.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/string_util.dart';
import '../misc/typedef.dart';
import '../misc/validation/validation_result.dart';
import '../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/reset_password_validator_group.dart';
import '../presentation/page/reset_password_page.dart';
import 'base_getx_controller.dart';

typedef _OnGetResetPasswordInput = String Function();
typedef _OnResetPasswordBack = void Function();
typedef _OnShowResetPasswordRequestProcessLoadingCallback = Future<void> Function();
typedef _OnResetPasswordRequestProcessSuccessCallback = Future<void> Function(ResetPasswordResponse);
typedef _OnShowResetPasswordRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowCheckPasswordRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowSubmitWhatsappPhoneNumberOtpRequestProcessLoadingCallback = Future<void> Function();
typedef _OnSubmitWhatsappPhoneNumberOtpRequestProcessSuccessCallback = Future<void> Function(CheckResetPasswordResponse);
typedef _OnShowSubmitWhatsappPhoneNumberOtpRequestProcessFailedCallback = Future<void> Function(dynamic e);

class ResetPasswordController extends BaseGetxController {
  final ResetPasswordUseCase resetPasswordUseCase;
  final CheckResetPasswordUseCase checkResetPasswordUseCase;

  late Rx<LoadDataResultWrapper<CheckResetPasswordResponse>> checkResetPasswordLoadDataResultWrapperRx;
  LoadDataResult<CheckResetPasswordResponse> _checkResetPasswordResponseLoadDataResult = NoLoadDataResult<CheckResetPasswordResponse>();

  late Rx<PasswordCompoundValidator> resetPasswordCompoundValidatorRx;
  late final ResetPasswordValidatorGroup resetPasswordValidatorGroup;

  ResetPasswordDelegate? _resetPasswordDelegate;
  bool _hasCheckResetPassword = false;

  ResetPasswordController(
    super.controllerManager,
    this.resetPasswordUseCase,
    this.checkResetPasswordUseCase
  ) {
    resetPasswordValidatorGroup = ResetPasswordValidatorGroup(
      resetPasswordCompoundValidator: PasswordCompoundValidator(
        passwordValidator: Validator(
          onValidate: () {
            return ValidatorHelper.getPasswordValidator(
              _resetPasswordDelegate!.onGetNewPasswordInput()
            ).validate();
          }
        ),
        passwordConfirmationValidator: Validator(
          onValidate: () {
            String password = _resetPasswordDelegate!.onGetNewPasswordInput();
            String passwordConfirmation = _resetPasswordDelegate!.onGetConfirmNewPasswordInput();
            if (password != passwordConfirmation) {
              return FailedValidationResult(e: ValidationError(message: "${"Password must be same with password confirmation".tr}."));
            } else {
              return SuccessValidationResult();
            }
          }
        )
      )
    );
    resetPasswordCompoundValidatorRx = resetPasswordValidatorGroup.resetPasswordCompoundValidator.obs;
    checkResetPasswordLoadDataResultWrapperRx = LoadDataResultWrapper<CheckResetPasswordResponse>(_checkResetPasswordResponseLoadDataResult).obs;
  }

  ResetPasswordController setResetPasswordDelegate(ResetPasswordDelegate resetPasswordDelegate) {
    _resetPasswordDelegate = resetPasswordDelegate;
    return this;
  }

  void _updateMenuMainMenuState() {
    checkResetPasswordLoadDataResultWrapperRx.valueFromLast(
      (value) => LoadDataResultWrapper<CheckResetPasswordResponse>(
        _checkResetPasswordResponseLoadDataResult
      )
    );
    update();
  }

  void submitWhatsappPhoneNumberOtp() async {
    if (_resetPasswordDelegate != null) {
      _resetPasswordDelegate!.onShowSubmitWhatsappPhoneNumberOtpRequestProcessLoadingCallback();
      LoadDataResult<CheckResetPasswordResponse> submitWhatsappPhoneNumberLoadDataResult = await checkResetPasswordUseCase.execute(
        () {
          ResetPasswordPageParameterType resetPasswordPageParameterType = _resetPasswordDelegate!.onGetResetPasswordPageParameterType();
          if (resetPasswordPageParameterType is EmailResetPasswordPageParameterType) {
            return CheckResetPasswordParameter(
              code: _resetPasswordDelegate!.onGetCode()
            );
          } else if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
            return WhatsappCheckResetPasswordParameter(
              code: _resetPasswordDelegate!.onGetCode()
            );
          }
          throw MessageError(title: "Reset password page parameter type is not suitable");
        }()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('reset-password').value
      );
      _resetPasswordDelegate!.onResetPasswordBack();
      if (submitWhatsappPhoneNumberLoadDataResult.isSuccess) {
        _resetPasswordDelegate!.onSubmitWhatsappPhoneNumberOtpRequestProcessSuccessCallback(submitWhatsappPhoneNumberLoadDataResult.resultIfSuccess!);
        _checkResetPasswordResponseLoadDataResult = SuccessLoadDataResult<CheckResetPasswordResponse>(
          value: CheckResetPasswordResponse()
        );
        _updateMenuMainMenuState();
      } else {
        _resetPasswordDelegate!.onShowSubmitWhatsappPhoneNumberOtpRequestProcessFailedCallback(submitWhatsappPhoneNumberLoadDataResult.resultIfFailed);
      }
    }
  }

  void checkResetPassword() async {
    if (_resetPasswordDelegate != null) {
      if (!_hasCheckResetPassword) {
        _hasCheckResetPassword = true;
        _checkResetPasswordResponseLoadDataResult = IsLoadingLoadDataResult<CheckResetPasswordResponse>();
        _updateMenuMainMenuState();
        _checkResetPasswordResponseLoadDataResult = await checkResetPasswordUseCase.execute(
          () {
            ResetPasswordPageParameterType resetPasswordPageParameterType = _resetPasswordDelegate!.onGetResetPasswordPageParameterType();
            if (resetPasswordPageParameterType is EmailResetPasswordPageParameterType) {
              return CheckResetPasswordParameter(
                code: _resetPasswordDelegate!.onGetCode()
              );
            } else if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
              return WhatsappCheckResetPasswordParameter(
                code: _resetPasswordDelegate!.onGetCode()
              );
            }
            throw MessageError(title: "Reset password page parameter type is not suitable");
          }()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('reset-password').value
        );
        _updateMenuMainMenuState();
        if (_checkResetPasswordResponseLoadDataResult.isFailed) {
          _resetPasswordDelegate!.onShowCheckPasswordRequestProcessFailedCallback(_checkResetPasswordResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void resetPassword() async {
    if (_resetPasswordDelegate != null) {
      _resetPasswordDelegate!.onUnfocusAllWidget();
      if (resetPasswordValidatorGroup.validate()) {
        _resetPasswordDelegate!.onShowResetPasswordRequestProcessLoadingCallback();
        LoadDataResult<ResetPasswordResponse> resetPasswordResponseLoadDataResult = await resetPasswordUseCase.execute(
          () {
            ResetPasswordPageParameterType resetPasswordPageParameterType = _resetPasswordDelegate!.onGetResetPasswordPageParameterType();
            if (resetPasswordPageParameterType is EmailResetPasswordPageParameterType) {
              return ResetPasswordParameter(
                code: _resetPasswordDelegate!.onGetCode(),
                newPassword: _resetPasswordDelegate!.onGetNewPasswordInput(),
                confirmNewPassword: _resetPasswordDelegate!.onGetConfirmNewPasswordInput()
              );
            } else if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
              return WhatsappResetPasswordParameter(
                code: _resetPasswordDelegate!.onGetCode(),
                newPassword: _resetPasswordDelegate!.onGetNewPasswordInput(),
                confirmNewPassword: _resetPasswordDelegate!.onGetConfirmNewPasswordInput()
              );
            }
            throw MessageError(title: "Reset password page parameter type is not suitable");
          }()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('reset-password').value
        );
        _resetPasswordDelegate!.onResetPasswordBack();
        if (resetPasswordResponseLoadDataResult.isSuccess) {
          _resetPasswordDelegate!.onResetPasswordRequestProcessSuccessCallback(resetPasswordResponseLoadDataResult.resultIfSuccess!);
        } else {
          _resetPasswordDelegate!.onShowResetPasswordRequestProcessFailedCallback(resetPasswordResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class ResetPasswordDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetResetPasswordInput onGetCode;
  _OnGetResetPasswordInput onGetNewPasswordInput;
  _OnGetResetPasswordInput onGetConfirmNewPasswordInput;
  _OnResetPasswordBack onResetPasswordBack;
  _OnShowResetPasswordRequestProcessLoadingCallback onShowResetPasswordRequestProcessLoadingCallback;
  _OnResetPasswordRequestProcessSuccessCallback onResetPasswordRequestProcessSuccessCallback;
  _OnShowResetPasswordRequestProcessFailedCallback onShowResetPasswordRequestProcessFailedCallback;
  _OnShowCheckPasswordRequestProcessFailedCallback onShowCheckPasswordRequestProcessFailedCallback;
  _OnShowSubmitWhatsappPhoneNumberOtpRequestProcessLoadingCallback onShowSubmitWhatsappPhoneNumberOtpRequestProcessLoadingCallback;
  _OnSubmitWhatsappPhoneNumberOtpRequestProcessSuccessCallback onSubmitWhatsappPhoneNumberOtpRequestProcessSuccessCallback;
  _OnShowSubmitWhatsappPhoneNumberOtpRequestProcessFailedCallback onShowSubmitWhatsappPhoneNumberOtpRequestProcessFailedCallback;
  ResetPasswordPageParameterType Function() onGetResetPasswordPageParameterType;

  ResetPasswordDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetCode,
    required this.onGetNewPasswordInput,
    required this.onGetConfirmNewPasswordInput,
    required this.onResetPasswordBack,
    required this.onShowResetPasswordRequestProcessLoadingCallback,
    required this.onResetPasswordRequestProcessSuccessCallback,
    required this.onShowResetPasswordRequestProcessFailedCallback,
    required this.onShowCheckPasswordRequestProcessFailedCallback,
    required this.onShowSubmitWhatsappPhoneNumberOtpRequestProcessLoadingCallback,
    required this.onSubmitWhatsappPhoneNumberOtpRequestProcessSuccessCallback,
    required this.onShowSubmitWhatsappPhoneNumberOtpRequestProcessFailedCallback,
    required this.onGetResetPasswordPageParameterType
  });
}