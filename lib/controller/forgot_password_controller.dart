import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/address/country_list_parameter.dart';
import '../domain/entity/forgotpassword/forgot_password_parameter.dart';
import '../domain/entity/forgotpassword/forgot_password_response.dart';
import '../domain/entity/forgotpassword/whatsapp/whatsapp_forgot_password_parameter.dart';
import '../domain/usecase/forgot_password_use_case.dart';
import '../domain/usecase/get_country_list_use_case.dart';
import '../domain/usecase/whatsapp_forgot_password_use_case.dart';
import '../misc/ValidatorHelper.dart';
import '../misc/constant.dart';
import '../misc/error/message_error.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/load_data_result.dart';
import '../misc/load_data_result.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/multi_language_string.dart';
import '../misc/processing/future_processing.dart';
import '../misc/registerstep/first_register_step.dart';
import '../misc/registerstep/register_step.dart';
import '../misc/registerstep/register_step_wrapper.dart';
import '../misc/string_util.dart';
import '../misc/typedef.dart';
import '../misc/validation/validation_result.dart';
import '../misc/validation/validationresult/is_email_success_validation_result.dart';
import '../misc/validation/validationresult/is_phone_number_success_validation_result.dart';
import '../misc/validation/validator/email_or_phone_number_validator.dart';
import '../misc/validation/validator/email_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/forgot_password_validator_group.dart';
import 'base_getx_controller.dart';

typedef _OnGetForgotPasswordInput = String Function();
typedef _OnForgotPasswordBack = void Function();
typedef _OnShowForgotPasswordRequestProcessLoadingCallback = Future<void> Function();
typedef _OnForgotPasswordRequestProcessSuccessCallback = Future<void> Function(ValidationResult?);
typedef _OnShowForgotPasswordRequestProcessFailedCallback = Future<void> Function(dynamic e);

class ForgotPasswordController extends BaseGetxController {
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final WhatsappForgotPasswordUseCase whatsappForgotPasswordUseCase;
  final GetCountryListUseCase getCountryListUseCase;

  late Rx<Validator> emailOrPhoneNumberValidatorRx;
  late final ForgotPasswordValidatorGroup forgotPasswordValidatorGroup;
  late final Validator _emailOrPhoneNumberValidator;
  ValidationResult? _validationResult;

  late Rx<LoadDataResultWrapper<List<String>>> countryListLoadDataResultWrapperRx;

  ForgotPasswordDelegate? _forgotPasswordDelegate;

  ForgotPasswordController(
    ControllerManager? controllerManager,
    this.forgotPasswordUseCase,
    this.whatsappForgotPasswordUseCase,
    this.getCountryListUseCase
  ) : super(controllerManager) {
    countryListLoadDataResultWrapperRx = LoadDataResultWrapper<List<String>>(
      NoLoadDataResult<List<String>>()
    ).obs;
    _emailOrPhoneNumberValidator = EmailOrPhoneNumberValidator(
      emailOrPhoneNumber: () => _forgotPasswordDelegate!.onGetEmailOrPhoneNumberForgotPasswordInput()
    );
    forgotPasswordValidatorGroup = ForgotPasswordValidatorGroup(
      emailOrPhoneNumberValidator: Validator(
        onValidate: () {
          Validator validator = ValidatorHelper.getEmailOrPhoneNumberValidator(
            onCheckingAfterValidateEmailOrPhoneNumber: () => SuccessValidationResult(),
            onGetEmailOrPhoneNumberValidator: () => _emailOrPhoneNumberValidator,
            onGetEmailOrPhoneNumberRegisterInput: _forgotPasswordDelegate!.onGetEmailOrPhoneNumberForgotPasswordInput,
            onGetCountryCodeListLoadDataResult: () => countryListLoadDataResultWrapperRx.value.loadDataResult,
            onGetEmailOrPhoneTypeValidationResult: (validationResult) {
              _validationResult = validationResult;
            }
          );
          // ignore: invalid_use_of_protected_member
          return validator.validating();
        }
      )
    );
    emailOrPhoneNumberValidatorRx = forgotPasswordValidatorGroup.emailOrPhoneNumberValidator.obs;
  }

  @override
  void onInitController() {
    _loadCountryCodeList();
  }

  void _updateCountryList(LoadDataResult<List<String>> countryListLoadDataResult) {
    countryListLoadDataResultWrapperRx.valueFromLast(
      (value) => LoadDataResultWrapper<List<String>>(countryListLoadDataResult)
    );
    update();
  }

  void _loadCountryCodeList() async {
    _updateCountryList(IsLoadingLoadDataResult<List<String>>());
    _updateCountryList(
      await getCountryListUseCase.execute(
        CountryListParameter()
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('country-list').value
      ).map<List<String>>(
        (value) => value.map(
          (country) => country.phoneCode
        ).toList()..add("62")
      )
    );
  }

  ForgotPasswordController setForgotPasswordDelegate(ForgotPasswordDelegate forgotPasswordDelegate) {
    _forgotPasswordDelegate = forgotPasswordDelegate;
    return this;
  }

  void forgotPassword(bool isCalledInCallback) async {
    if (_forgotPasswordDelegate != null) {
      _forgotPasswordDelegate!.onUnfocusAllWidget();
      if (forgotPasswordValidatorGroup.validate()) {
        if (_validationResult == null) {
          _forgotPasswordDelegate!.onShowForgotPasswordRequestProcessFailedCallback(
            MultiLanguageMessageError(
              title: MultiLanguageString({
                Constant.textInIdLanguageKey: "Hasil Validasi Tidak Ada",
                Constant.textEnUsLanguageKey: "Validation Result Is Null"
              }),
              message: MultiLanguageString({
                Constant.textInIdLanguageKey: "Untuk sekarang, hasil validasi tidak ada.",
                Constant.textEnUsLanguageKey: "For now, validation result is null."
              }),
            )
          );
          return;
        }
        _forgotPasswordDelegate!.onShowForgotPasswordRequestProcessLoadingCallback();
        late FutureProcessing<LoadDataResult<ForgotPasswordResponse>> forgotPasswordLoadDataResultFutureProcessing;
        String getEffectiveEmailOrPhoneNumber() {
          return StringUtil.effectiveEmailOrPhoneNumber(
            _forgotPasswordDelegate!.onGetEmailOrPhoneNumberForgotPasswordInput(),
            _emailOrPhoneNumberValidator
          );
        }
        if (_validationResult is IsEmailSuccessValidationResult) {
          forgotPasswordLoadDataResultFutureProcessing = forgotPasswordUseCase.execute(
            ForgotPasswordParameter(
              email: getEffectiveEmailOrPhoneNumber()
            )
          );
        } else if (_validationResult is IsPhoneNumberSuccessValidationResult) {
          forgotPasswordLoadDataResultFutureProcessing = whatsappForgotPasswordUseCase.execute(
            WhatsappForgotPasswordParameter(
              phoneNumber: getEffectiveEmailOrPhoneNumber()
            )
          ).map(
            onMap: (loadDataResult) => loadDataResult.map(
              (value) => ForgotPasswordResponse()
            )
          );
        } else {
          _forgotPasswordDelegate!.onShowForgotPasswordRequestProcessFailedCallback(
            MultiLanguageMessageError(
              title: MultiLanguageString({
                Constant.textInIdLanguageKey: "Hasil Validasi Tidak Sesuai",
                Constant.textEnUsLanguageKey: "Validation Result Is Not Suitable"
              }),
              message: MultiLanguageString({
                Constant.textInIdLanguageKey: "Untuk sekarang, hasil validasi tidak sesuai.",
                Constant.textEnUsLanguageKey: "For now, validation result is not suitable."
              }),
            )
          );
          Get.back();
          return;
        }
        LoadDataResult<ForgotPasswordResponse> forgotPasswordLoadDataResult = await forgotPasswordLoadDataResultFutureProcessing.future(
          parameter: apiRequestManager.addRequestToCancellationPart('forgot-password').value
        );
        Get.back();
        if (forgotPasswordLoadDataResult.isSuccess) {
          if (isCalledInCallback) {
            _forgotPasswordDelegate!.onForgotPasswordCalledFromCallbackRequestProcessSuccessCallback(_validationResult);
          } else {
            _forgotPasswordDelegate!.onForgotPasswordRequestProcessSuccessCallback(_validationResult);
          }
        } else {
          _forgotPasswordDelegate!.onShowForgotPasswordRequestProcessFailedCallback(forgotPasswordLoadDataResult.resultIfFailed);
        }
      }
    }
  }
}

class ForgotPasswordDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnGetForgotPasswordInput onGetEmailOrPhoneNumberForgotPasswordInput;
  _OnForgotPasswordBack onLoginBack;
  _OnShowForgotPasswordRequestProcessLoadingCallback onShowForgotPasswordRequestProcessLoadingCallback;
  _OnForgotPasswordRequestProcessSuccessCallback onForgotPasswordRequestProcessSuccessCallback;
  _OnForgotPasswordRequestProcessSuccessCallback onForgotPasswordCalledFromCallbackRequestProcessSuccessCallback;
  _OnShowForgotPasswordRequestProcessFailedCallback onShowForgotPasswordRequestProcessFailedCallback;

  ForgotPasswordDelegate({
    required this.onUnfocusAllWidget,
    required this.onGetEmailOrPhoneNumberForgotPasswordInput,
    required this.onLoginBack,
    required this.onShowForgotPasswordRequestProcessLoadingCallback,
    required this.onForgotPasswordRequestProcessSuccessCallback,
    required this.onShowForgotPasswordRequestProcessFailedCallback,
    required this.onForgotPasswordCalledFromCallbackRequestProcessSuccessCallback
  });
}