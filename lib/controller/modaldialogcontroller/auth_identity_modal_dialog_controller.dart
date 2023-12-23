import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/address/country_list_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/auth_identity_change_input_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/auth_identity_change_input_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/email_auth_identity_change_input_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/phone_auth_identity_change_input_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/auth_identity_change_verify_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/auth_identity_change_verify_otp_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/email_auth_identity_change_verify_otp_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/phone_auth_identity_change_verify_otp_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentityverifyotp/auth_identity_verify_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/auth_identity_verify_otp_parameter.dart';
import '../../domain/usecase/auth_identity_change_input_use_case.dart';
import '../../domain/usecase/auth_identity_change_use_case.dart';
import '../../domain/usecase/auth_identity_change_verify_otp_use_case.dart';
import '../../domain/usecase/auth_identity_send_verify_otp_use_case.dart';
import '../../domain/usecase/auth_identity_verify_otp_use_case.dart';
import '../../domain/usecase/get_country_list_use_case.dart';
import '../../misc/authidentitystep/auth_identity_step.dart';
import '../../misc/authidentitystep/auth_identity_step_wrapper.dart';
import '../../misc/authidentitystep/changeauthidentitystep/change_auth_identity_step.dart';
import '../../misc/authidentitystep/changeauthidentitystep/email_change_auth_identity_step.dart';
import '../../misc/authidentitystep/changeauthidentitystep/phone_change_auth_identity_step.dart';
import '../../misc/authidentitystep/is_loading_auth_identity_step.dart';
import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error/validation_error.dart';
import '../../misc/load_data_result.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/string_util.dart';
import '../../misc/typedef.dart';
import '../../misc/validation/validation_result.dart';
import '../../misc/validation/validationresult/is_email_success_validation_result.dart';
import '../../misc/validation/validationresult/is_phone_number_success_validation_result.dart';
import '../../misc/validation/validator/email_or_phone_number_validator.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/validation/validatorgroup/change_auth_identity_validator_group.dart';
import '../../misc/validation/validatorgroup/verify_auth_identity_validator_group.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetAuthIdentityInput = String Function();
typedef _OnAuthIdentityBack = void Function();
typedef _OnShowAuthIdentitySendVerifyProcessLoadingCallback = Future<void> Function();
typedef _OnAuthIdentitySendVerifyProcessSuccessCallback = Future<void> Function(AuthIdentitySendVerifyOtpResponse);
typedef _OnShowAuthIdentitySendVerifyProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowAuthIdentityVerifyOtpProcessLoadingCallback = Future<void> Function();
typedef _OnAuthIdentityVerifyOtpProcessSuccessCallback = Future<void> Function(AuthIdentityVerifyOtpResponse);
typedef _OnShowAuthIdentityVerifyOtpProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowAuthIdentityChangeInputProcessLoadingCallback = Future<void> Function();
typedef _OnAuthIdentityChangeInputProcessSuccessCallback = Future<void> Function(AuthIdentityChangeInputResponse);
typedef _OnShowAuthIdentityChangeInputProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowAuthIdentityChangeVerifyOtpProcessLoadingCallback = Future<void> Function();
typedef _OnAuthIdentityChangeVerifyOtpProcessSuccessCallback = Future<void> Function(AuthIdentityChangeVerifyOtpResponse);
typedef _OnShowAuthIdentityChangeVerifyOtpProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowAuthIdentityChangeProcessLoadingCallback = Future<void> Function();
typedef _OnAuthIdentityChangeProcessSuccessCallback = Future<void> Function(AuthIdentityChangeResponse);
typedef _OnShowAuthIdentityChangeProcessFailedCallback = Future<void> Function(dynamic e);

class AuthIdentityModalDialogController extends ModalDialogController {
  final AuthIdentitySendVerifyOtpUseCase authIdentitySendVerifyOtpUseCase;
  final AuthIdentityVerifyOtpUseCase authIdentityVerifyOtpUseCase;
  final AuthIdentityChangeInputUseCase authIdentityChangeInputUseCase;
  final AuthIdentityChangeVerifyOtpUseCase authIdentityChangeVerifyOtpUseCase;
  final AuthIdentityChangeUseCase authIdentityChangeUseCase;
  final GetCountryListUseCase getCountryListUseCase;

  AuthIdentityDelegate? _authIdentityDelegate;

  late final Validator _emailOrPhoneNumberValidator;

  // Auth Identity Step
  late Rx<AuthIdentityStepWrapper> authIdentityStepWrapperRx;

  // Change Auth Validator
  late Rx<Validator> changeAuthIdentityValidatorRx;
  late final ChangeAuthIdentityValidatorGroup _changeAuthIdentityValidatorGroup;

  // Change Auth Validator
  late final Rx<Validator> verifyAuthIdentityValidatorRx;
  late final VerifyAuthIdentityValidatorGroup _verifyAuthIdentityValidatorGroup;

  String get _effectiveAuthIdentityChangeInput {
    return StringUtil.effectiveEmailOrPhoneNumber(
      _authIdentityDelegate!.onGetAuthIdentityChangeInput(),
      _emailOrPhoneNumberValidator
    );
  }

  AuthIdentityModalDialogController(
    super.controllerManager,
    this.authIdentitySendVerifyOtpUseCase,
    this.authIdentityVerifyOtpUseCase,
    this.authIdentityChangeInputUseCase,
    this.authIdentityChangeVerifyOtpUseCase,
    this.authIdentityChangeUseCase,
    this.getCountryListUseCase
  ) {
    AuthIdentityStep authIdentityStep = IsLoadingAuthIdentityStep();
    authIdentityStepWrapperRx = AuthIdentityStepWrapper(authIdentityStep).obs;
    _emailOrPhoneNumberValidator = EmailOrPhoneNumberValidator(
      emailOrPhoneNumber: () => _authIdentityDelegate!.onGetAuthIdentityChangeInput()
    );
    _changeAuthIdentityValidatorGroup = ChangeAuthIdentityValidatorGroup(
      changeAuthIdentityValidator: Validator(
        onValidate: () {
          AuthIdentityStepWrapper authIdentityStepWrapper = authIdentityStepWrapperRx.value;
          AuthIdentityStep? effectiveAuthIdentityStep = authIdentityStepWrapper.authIdentityStep;
          if (effectiveAuthIdentityStep is! ChangeAuthIdentityStep) {
            effectiveAuthIdentityStep = _authIdentityDelegate!.onGetLastChangeAuthIdentityStep();
          }
          if (effectiveAuthIdentityStep is ChangeAuthIdentityStep) {
            // ignore: invalid_use_of_protected_member
            ValidationResult validationResult = _emailOrPhoneNumberValidator.validating();
            if (effectiveAuthIdentityStep is EmailChangeAuthIdentityStep) {
              if (validationResult is IsEmailSuccessValidationResult) {
                return validationResult;
              } else {
                return FailedValidationResult(e: ValidationError(message: "${"This input must be an email".tr}."));
              }
            } else if (effectiveAuthIdentityStep is PhoneChangeAuthIdentityStep) {
              String emailOrPhoneNumber = _authIdentityDelegate!.onGetAuthIdentityChangeInput();
              LoadDataResult<List<String>> countryCodeListLoadDataResult = effectiveAuthIdentityStep.countryCodeListLoadDataResult;
              if (countryCodeListLoadDataResult.isSuccess) {
                List<String> countryCodeList = countryCodeListLoadDataResult.resultIfSuccess!;
                if (validationResult is IsPhoneNumberSuccessValidationResult) {
                  int step = 1;
                  String temp = "";
                  for (int i = 0; i < emailOrPhoneNumber.length; i++) {
                    String c = emailOrPhoneNumber[i];
                    if (c.isNum) {
                      temp += c;
                    }
                    if (step == 1) {
                      if (temp.isNotEmpty && temp.length <= 3) {
                        if (countryCodeList.where((countryCode) => countryCode == temp).isNotEmpty) {
                          return SuccessValidationResult();
                        }
                      }
                      if (temp.length == 1) {
                        if (temp == "0") {
                          return SuccessValidationResult();
                        }
                      }
                    }
                  }
                  return FailedValidationResult(
                    e: ValidationError(
                      message: MultiLanguageString({
                        Constant.textEnUsLanguageKey: "Country phone code is not suitable.",
                        Constant.textInIdLanguageKey: "Kode telepon negara tidak ada yang sesuai."
                      }).toStringNonNull
                    )
                  );
                }
                return validationResult;
              } else {
                return FailedValidationResult(
                  e: ValidationError(
                    message: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Country phone code cannot be checked.",
                      Constant.textInIdLanguageKey: "Kode telepon negara tidak bisa dicek."
                    }).toStringNonNull
                  )
                );
              }
            }
          }
          return FailedValidationResult(
            e: ValidationError(
              message: MultiLanguageString({
                Constant.textEnUsLanguageKey: "Subclass from ChangeAuthIdentityStep is not suitabled.",
                Constant.textInIdLanguageKey: "Subclass dari ChangeAuthIdentityStep-nya tidak cocok."
              }).toStringNonNull
            )
          );
        }
      ),
    );
    changeAuthIdentityValidatorRx = _changeAuthIdentityValidatorGroup.changeAuthIdentityValidator.obs;
    _verifyAuthIdentityValidatorGroup = VerifyAuthIdentityValidatorGroup(
      verifyAuthIdentityValidator: Validator(
        onValidate: () {
          return !_effectiveAuthIdentityChangeInput.isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Name is required".tr}."));
        }
      ),
    );
    verifyAuthIdentityValidatorRx = _verifyAuthIdentityValidatorGroup.verifyAuthIdentityValidator.obs;
  }

  void authIdentitySendVerifyOtpProcess(AuthIdentitySendVerifyOtpParameter authIdentitySendVerifyOtpParameter) async {
    if (_authIdentityDelegate != null) {
      _authIdentityDelegate!.onUnfocusAllWidget();
      _authIdentityDelegate!.onShowAuthIdentitySendVerifyProcessLoadingCallback();
      LoadDataResult<AuthIdentitySendVerifyOtpResponse> authIdentitySendVerifyOtpResponseLoadDataResult = await authIdentitySendVerifyOtpUseCase.execute(
        authIdentitySendVerifyOtpParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('auth-identity-send-verify-otp').value
      );
      _authIdentityDelegate!.onAuthIdentityBack();
      if (authIdentitySendVerifyOtpResponseLoadDataResult.isSuccess) {
        _authIdentityDelegate!.onAuthIdentitySendVerifyProcessSuccessCallback(authIdentitySendVerifyOtpResponseLoadDataResult.resultIfSuccess!);
      } else {
        _authIdentityDelegate!.onShowAuthIdentitySendVerifyProcessFailedCallback(authIdentitySendVerifyOtpResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void authIdentityVerifyOtp(AuthIdentityVerifyOtpParameter authIdentityVerifyOtpParameter) async {
    if (_authIdentityDelegate != null) {
      _authIdentityDelegate!.onUnfocusAllWidget();
      _authIdentityDelegate!.onShowAuthIdentityVerifyOtpProcessLoadingCallback();
      LoadDataResult<AuthIdentityVerifyOtpResponse> authIdentityVerifyOtpResponseLoadDataResult = await authIdentityVerifyOtpUseCase.execute(
        authIdentityVerifyOtpParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('auth-identity-verify-otp').value
      );
      _authIdentityDelegate!.onAuthIdentityBack();
      if (authIdentityVerifyOtpResponseLoadDataResult.isSuccess) {
        _authIdentityDelegate!.onAuthIdentityVerifyOtpProcessSuccessCallback(authIdentityVerifyOtpResponseLoadDataResult.resultIfSuccess!);
      } else {
        _authIdentityDelegate!.onShowAuthIdentityVerifyOtpProcessFailedCallback(authIdentityVerifyOtpResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void authIdentityChangeInput(AuthIdentityChangeInputParameter authIdentityChangeInputParameter) async {
    if (_authIdentityDelegate != null) {
      _authIdentityDelegate!.onUnfocusAllWidget();
      if (_changeAuthIdentityValidatorGroup.validate()) {
        _authIdentityDelegate!.onShowAuthIdentityChangeInputProcessLoadingCallback();
        late AuthIdentityChangeInputParameter newAuthIdentityChangeInputParameter;
        if (authIdentityChangeInputParameter is EmailAuthIdentityChangeInputParameter) {
          newAuthIdentityChangeInputParameter = EmailAuthIdentityChangeInputParameter(
            email: _effectiveAuthIdentityChangeInput
          );
        } else if (authIdentityChangeInputParameter is PhoneAuthIdentityChangeInputParameter) {
          newAuthIdentityChangeInputParameter = PhoneAuthIdentityChangeInputParameter(
            phone: _effectiveAuthIdentityChangeInput
          );
        } else {
          throw MessageError(title: "Subclass of AuthIdentityChangeInputParameter is not suitable");
        }
        LoadDataResult<AuthIdentityChangeInputResponse> authIdentityChangeInputResponseLoadDataResult = await authIdentityChangeInputUseCase.execute(
          newAuthIdentityChangeInputParameter
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('auth-identity-change-input').value
        );
        _authIdentityDelegate!.onAuthIdentityBack();
        if (authIdentityChangeInputResponseLoadDataResult.isSuccess) {
          _authIdentityDelegate!.onAuthIdentityChangeInputProcessSuccessCallback(authIdentityChangeInputResponseLoadDataResult.resultIfSuccess!);
        } else {
          _authIdentityDelegate!.onShowAuthIdentityChangeInputProcessFailedCallback(authIdentityChangeInputResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void authIdentityChangeVerifyOtp(AuthIdentityChangeVerifyOtpParameter authIdentityChangeVerifyOtpParameter) async {
    if (_authIdentityDelegate != null) {
      _authIdentityDelegate!.onUnfocusAllWidget();
      if (_verifyAuthIdentityValidatorGroup.validate()) {
        _authIdentityDelegate!.onShowAuthIdentityChangeVerifyOtpProcessLoadingCallback();
        late AuthIdentityChangeVerifyOtpParameter newAuthIdentityChangeVerifyOtpParameter;
        if (authIdentityChangeVerifyOtpParameter is EmailAuthIdentityChangeVerifyOtpParameter) {
          newAuthIdentityChangeVerifyOtpParameter = EmailAuthIdentityChangeVerifyOtpParameter(
            email: _effectiveAuthIdentityChangeInput,
            otp: authIdentityChangeVerifyOtpParameter.otp
          );
        } else if (authIdentityChangeVerifyOtpParameter is PhoneAuthIdentityChangeVerifyOtpParameter) {
          newAuthIdentityChangeVerifyOtpParameter = PhoneAuthIdentityChangeVerifyOtpParameter(
            phone: _effectiveAuthIdentityChangeInput,
            otp: authIdentityChangeVerifyOtpParameter.otp
          );
        } else {
          throw MessageError(title: "Subclass of AuthIdentityChangeVerifyOtpParameter is not suitable");
        }
        LoadDataResult<AuthIdentityChangeVerifyOtpResponse> authIdentityChangeVerifyOtpResponseLoadDataResult = await authIdentityChangeVerifyOtpUseCase.execute(
          newAuthIdentityChangeVerifyOtpParameter
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('auth-identity-change-verify-otp').value
        );
        _authIdentityDelegate!.onAuthIdentityBack();
        if (authIdentityChangeVerifyOtpResponseLoadDataResult.isSuccess) {
          _authIdentityDelegate!.onAuthIdentityChangeVerifyOtpProcessSuccessCallback(authIdentityChangeVerifyOtpResponseLoadDataResult.resultIfSuccess!);
        } else {
          _authIdentityDelegate!.onShowAuthIdentityChangeVerifyOtpProcessFailedCallback(authIdentityChangeVerifyOtpResponseLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void authIdentityChange(AuthIdentityChangeParameter authIdentityChangeParameter) async {
    if (_authIdentityDelegate != null) {
      _authIdentityDelegate!.onUnfocusAllWidget();
      _authIdentityDelegate!.onShowAuthIdentityChangeProcessLoadingCallback();
      AuthIdentityChangeParameter newAuthIdentityChangeParameter = AuthIdentityChangeParameter(
        credential: _effectiveAuthIdentityChangeInput
      );
      LoadDataResult<AuthIdentityChangeResponse> authIdentityChangeResponseLoadDataResult = await authIdentityChangeUseCase.execute(
        newAuthIdentityChangeParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('auth-identity-change').value
      );
      _authIdentityDelegate!.onAuthIdentityBack();
      if (authIdentityChangeResponseLoadDataResult.isSuccess) {
        _authIdentityDelegate!.onAuthIdentityChangeProcessSuccessCallback(authIdentityChangeResponseLoadDataResult.resultIfSuccess!);
      } else {
        _authIdentityDelegate!.onShowAuthIdentityChangeProcessFailedCallback(authIdentityChangeResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void updateAuthIdentityStep(AuthIdentityStep authIdentityStep) {
    void updatingAuthIdentityStep() {
      authIdentityStepWrapperRx.valueFromLast(
        (value) => AuthIdentityStepWrapper(authIdentityStep)
      );
      update();
    }
    void loadCountryCodeListForPhoneChangeAuthIdentityStep(PhoneChangeAuthIdentityStep phoneChangeAuthIdentityStep) async {
      LoadDataResult<List<String>> countryCodeListStringLoadDataResult = await getCountryListUseCase.execute(
        CountryListParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('country-list-code').value
      ).map<List<String>>(
        (value) => value.map(
          (country) => country.phoneCode
        ).toList()..add("62")
      );
      if (countryCodeListStringLoadDataResult.isFailedBecauseCancellation) {
        return;
      }
      phoneChangeAuthIdentityStep.countryCodeListLoadDataResult = countryCodeListStringLoadDataResult;
      updatingAuthIdentityStep();
    }
    if (authIdentityStep is PhoneChangeAuthIdentityStep) {
      loadCountryCodeListForPhoneChangeAuthIdentityStep(authIdentityStep);
    }
    updatingAuthIdentityStep();
  }

  void setAuthIdentityDelegate(AuthIdentityDelegate authIdentityDelegate) {
    _authIdentityDelegate = authIdentityDelegate;
  }
}

class AuthIdentityDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnAuthIdentityBack onAuthIdentityBack;
  _OnGetAuthIdentityInput onGetAuthIdentitySendVerifyOtpInput;
  _OnGetAuthIdentityInput onGetAuthIdentityChangeInput;
  _OnGetAuthIdentityInput onGetAuthIdentityChangeVerifyOtpInput;
  _OnShowAuthIdentitySendVerifyProcessLoadingCallback onShowAuthIdentitySendVerifyProcessLoadingCallback;
  _OnAuthIdentitySendVerifyProcessSuccessCallback onAuthIdentitySendVerifyProcessSuccessCallback;
  _OnShowAuthIdentitySendVerifyProcessFailedCallback onShowAuthIdentitySendVerifyProcessFailedCallback;
  _OnShowAuthIdentityVerifyOtpProcessLoadingCallback onShowAuthIdentityVerifyOtpProcessLoadingCallback;
  _OnAuthIdentityVerifyOtpProcessSuccessCallback onAuthIdentityVerifyOtpProcessSuccessCallback;
  _OnShowAuthIdentityVerifyOtpProcessFailedCallback onShowAuthIdentityVerifyOtpProcessFailedCallback;
  _OnShowAuthIdentityChangeInputProcessLoadingCallback onShowAuthIdentityChangeInputProcessLoadingCallback;
  _OnAuthIdentityChangeInputProcessSuccessCallback onAuthIdentityChangeInputProcessSuccessCallback;
  _OnShowAuthIdentityChangeInputProcessFailedCallback onShowAuthIdentityChangeInputProcessFailedCallback;
  _OnShowAuthIdentityChangeVerifyOtpProcessLoadingCallback onShowAuthIdentityChangeVerifyOtpProcessLoadingCallback;
  _OnAuthIdentityChangeVerifyOtpProcessSuccessCallback onAuthIdentityChangeVerifyOtpProcessSuccessCallback;
  _OnShowAuthIdentityChangeVerifyOtpProcessFailedCallback onShowAuthIdentityChangeVerifyOtpProcessFailedCallback;
  _OnShowAuthIdentityChangeProcessLoadingCallback onShowAuthIdentityChangeProcessLoadingCallback;
  _OnAuthIdentityChangeProcessSuccessCallback onAuthIdentityChangeProcessSuccessCallback;
  _OnShowAuthIdentityChangeProcessFailedCallback onShowAuthIdentityChangeProcessFailedCallback;
  ChangeAuthIdentityStep? Function() onGetLastChangeAuthIdentityStep;

  AuthIdentityDelegate({
    required this.onUnfocusAllWidget,
    required this.onAuthIdentityBack,
    required this.onGetAuthIdentitySendVerifyOtpInput,
    required this.onGetAuthIdentityChangeInput,
    required this.onGetAuthIdentityChangeVerifyOtpInput,
    required this.onShowAuthIdentitySendVerifyProcessLoadingCallback,
    required this.onAuthIdentitySendVerifyProcessSuccessCallback,
    required this.onShowAuthIdentitySendVerifyProcessFailedCallback,
    required this.onShowAuthIdentityVerifyOtpProcessLoadingCallback,
    required this.onAuthIdentityVerifyOtpProcessSuccessCallback,
    required this.onShowAuthIdentityVerifyOtpProcessFailedCallback,
    required this.onShowAuthIdentityChangeInputProcessLoadingCallback,
    required this.onAuthIdentityChangeInputProcessSuccessCallback,
    required this.onShowAuthIdentityChangeInputProcessFailedCallback,
    required this.onShowAuthIdentityChangeVerifyOtpProcessLoadingCallback,
    required this.onAuthIdentityChangeVerifyOtpProcessSuccessCallback,
    required this.onShowAuthIdentityChangeVerifyOtpProcessFailedCallback,
    required this.onShowAuthIdentityChangeProcessLoadingCallback,
    required this.onAuthIdentityChangeProcessSuccessCallback,
    required this.onShowAuthIdentityChangeProcessFailedCallback,
    required this.onGetLastChangeAuthIdentityStep
  });
}