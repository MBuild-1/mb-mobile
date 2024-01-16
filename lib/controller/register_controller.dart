import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';

import '../domain/entity/address/country_list_parameter.dart';
import '../domain/entity/register/register_first_step_parameter.dart';
import '../domain/entity/register/register_first_step_response.dart';
import '../domain/entity/register/register_parameter.dart';
import '../domain/entity/register/register_response.dart';
import '../domain/entity/register/register_second_step_parameter.dart';
import '../domain/entity/register/register_second_step_response.dart';
import '../domain/entity/register/register_with_google_parameter.dart';
import '../domain/entity/register/register_with_google_response.dart';
import '../domain/entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../domain/entity/register/verify_register_parameter.dart';
import '../domain/entity/register/verify_register_response.dart';
import '../domain/entity/user/getuser/get_user_parameter.dart';
import '../domain/entity/user/user.dart';
import '../domain/usecase/get_country_list_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../domain/usecase/register_first_step_use_case.dart';
import '../domain/usecase/register_second_step_use_case.dart';
import '../domain/usecase/register_use_case.dart';
import '../domain/usecase/register_with_google_use_case.dart';
import '../domain/usecase/send_register_otp_use_case.dart';
import '../domain/usecase/verify_register_use_case.dart';
import '../misc/constant.dart';
import '../misc/error/validation_error.dart';
import '../misc/load_data_result.dart';
import '../misc/manager/controller_manager.dart';
import '../misc/multi_language_string.dart';
import '../misc/registerstep/first_register_step.dart';
import '../misc/registerstep/register_step.dart';
import '../misc/registerstep/register_step_wrapper.dart';
import '../misc/registerstep/second_register_step.dart';
import '../misc/registerstep/send_register_otp_register_step.dart';
import '../misc/registerstep/verify_register_step.dart';
import '../misc/string_util.dart';
import '../misc/typedef.dart';
import '../misc/validation/validation_result.dart';
import '../misc/validation/validationresult/is_phone_number_success_validation_result.dart';
import '../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../misc/validation/validator/email_or_phone_number_validator.dart';
import '../misc/validation/validator/validator.dart';
import '../misc/validation/validatorgroup/register_second_step_validator_group.dart';
import '../misc/validation/validatorgroup/register_validator_group.dart';
import 'base_getx_controller.dart';

typedef _OnGetRegisterInput = String Function();
typedef _OnRegisterBack = void Function();
typedef _OnShowRegisterRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRegisterRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowRegisterRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowRegisterFirstStepRequestProcessLoadingCallback = Future<void> Function();
typedef _OnRegisterFirstStepRequestProcessSuccessCallback = Future<void> Function(RegisterFirstStepResponse);
typedef _OnShowRegisterFirstStepRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowSendRegisterOtpRequestProcessLoadingCallback = Future<void> Function();
typedef _OnSendRegisterOtpRequestProcessSuccessCallback = Future<void> Function(SendRegisterOtpResponse);
typedef _OnShowVerifyRegisterRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowVerifyRegisterRequestProcessLoadingCallback = Future<void> Function();
typedef _OnVerifyRegisterRequestProcessSuccessCallback = Future<void> Function(VerifyRegisterResponse);
typedef _OnShowSendRegisterOtpRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnRegisterWithGoogle = Future<String?> Function();
typedef _OnSaveToken = Future<void> Function(String);

class RegisterController extends BaseGetxController {
  final RegisterUseCase registerUseCase;
  final RegisterWithGoogleUseCase registerWithGoogleUseCase;
  final RegisterFirstStepUseCase registerFirstStepUseCase;
  final SendRegisterOtpUseCase sendRegisterOtpUseCase;
  final VerifyRegisterUseCase verifyRegisterUseCase;
  final RegisterSecondStepUseCase registerSecondStepUseCase;
  final GetCountryListUseCase getCountryListUseCase;
  final GetUserUseCase getUserUseCase;

  late final Validator _emailOrPhoneNumberValidator;

  // Register Step
  late Rx<RegisterStepWrapper> registerStepWrapperRx;
  late List<RegisterStep> _registerStepList;

  // Register
  late Rx<Validator> emailOrPhoneNumberValidatorRx;
  late final RegisterValidatorGroup registerValidatorGroup;

  // Register Second Step
  late Rx<Validator> nameValidatorRx;
  late Rx<Validator> genderValidatorRx;
  late Rx<PasswordCompoundValidator> passwordCompoundValidatorRx;
  late final RegisterSecondStepValidatorGroup registerSecondStepValidatorGroup;

  String? _credential;

  RegisterDelegate? _registerDelegate;

  RegisterController(
    ControllerManager? controllerManager,
    this.registerUseCase,
    this.registerWithGoogleUseCase,
    this.registerFirstStepUseCase,
    this.sendRegisterOtpUseCase,
    this.verifyRegisterUseCase,
    this.registerSecondStepUseCase,
    this.getCountryListUseCase,
    this.getUserUseCase
  ) : super(controllerManager) {
    // Register step
    RegisterStep firstRegisterStep = FirstRegisterStep(
      countryCodeListLoadDataResult: NoLoadDataResult<List<String>>()
    );
    registerStepWrapperRx = RegisterStepWrapper(firstRegisterStep).obs;
    _registerStepList = [firstRegisterStep];

    _emailOrPhoneNumberValidator = EmailOrPhoneNumberValidator(
      emailOrPhoneNumber: () => _registerDelegate!.onGetEmailOrPhoneNumberRegisterInput()
    );

    // Register validator group
    registerValidatorGroup = RegisterValidatorGroup(
      emailOrPhoneNumberValidator: Validator(
        onValidate: () {
          String emailOrPhoneNumber = _registerDelegate!.onGetEmailOrPhoneNumberRegisterInput();
          // ignore: invalid_use_of_protected_member
          ValidationResult validationResult = _emailOrPhoneNumberValidator.validating();
          if (validationResult.isSuccess) {
            RegisterStepWrapper registerStepWrapper = registerStepWrapperRx.value;
            RegisterStep registerStep = registerStepWrapper.registerStep;
            if (registerStep is FirstRegisterStep) {
              LoadDataResult<List<String>> countryCodeListLoadDataResult = registerStep.countryCodeListLoadDataResult;
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
            } else {
              return FailedValidationResult(
                e: ValidationError(
                  message: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Make sure this register is in first step while running this validation.",
                    Constant.textInIdLanguageKey: "Pastikan pendaftaran ini di langkah pertama ketika menjalankan validasi ini."
                  }).toStringNonNull
                )
              );
            }
          }
          return validationResult;
        }
      ),
    );
    emailOrPhoneNumberValidatorRx = registerValidatorGroup.emailOrPhoneNumberValidator.obs;

    // Register second step validator group
    registerSecondStepValidatorGroup = RegisterSecondStepValidatorGroup(
      nameValidator: Validator(
        onValidate: () => !_registerDelegate!.onGetNameRegisterInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Name is required".tr}."))
      ),
      genderValidator: Validator(
        onValidate: () => !_registerDelegate!.onGetGenderRegisterInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Gender is required".tr}."))
      ),
      passwordCompoundValidator: PasswordCompoundValidator(
        passwordValidator: Validator(
          onValidate: () => !_registerDelegate!.onGetPasswordRegisterInput().isEmptyString ? SuccessValidationResult() : FailedValidationResult(e: ValidationError(message: "${"Password is required".tr}."))
        ),
        passwordConfirmationValidator: Validator(
          onValidate: () {
            String password = _registerDelegate!.onGetPasswordRegisterInput();
            String passwordConfirmation = _registerDelegate!.onGetPasswordConfirmationRegisterInput();
            if (password != passwordConfirmation) {
              return FailedValidationResult(e: ValidationError(message: "${"Password must be same with password confirmation".tr}."));
            } else {
              return SuccessValidationResult();
            }
          }
        )
      )
    );
    nameValidatorRx = registerSecondStepValidatorGroup.nameValidator.obs;
    genderValidatorRx = registerSecondStepValidatorGroup.genderValidator.obs;
    passwordCompoundValidatorRx = registerSecondStepValidatorGroup.passwordCompoundValidator.obs;
  }

  @override
  void onInitController() {
    _loadCountryCodeList();
  }

  void _loadCountryCodeList() async {
    _updateRegisterStep(
      FirstRegisterStep(
        countryCodeListLoadDataResult: IsLoadingLoadDataResult<List<String>>()
      )
    );
    _updateRegisterStep(
      FirstRegisterStep(
        countryCodeListLoadDataResult: await getCountryListUseCase.execute(
          CountryListParameter()
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('country-list').value
        ).map<List<String>>(
          (value) => value.map(
            (country) => country.phoneCode
          ).toList()..add("62")
        )
      )
    );
  }

  RegisterController setRegisterDelegate(RegisterDelegate registerDelegate) {
    _registerDelegate = registerDelegate;
    return this;
  }

  void registerFirstStep() async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      if (registerValidatorGroup.validate()) {
        _registerDelegate!.onShowRegisterRequestProcessLoadingCallback();
        LoadDataResult<RegisterFirstStepResponse> registerFirstStepLoadDataResult = await registerFirstStepUseCase.execute(
          RegisterFirstStepParameter(
            emailOrPhoneNumber: StringUtil.effectiveEmailOrPhoneNumber(
              _registerDelegate!.onGetEmailOrPhoneNumberRegisterInput(),
              _emailOrPhoneNumberValidator
            )
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('register-first-step').value
        );
        _registerDelegate!.onRegisterBack();
        if (registerFirstStepLoadDataResult.isSuccess) {
          _updateRegisterStep(
            SendRegisterOtpRegisterStep(
              registerFirstStepResponse: registerFirstStepLoadDataResult.resultIfSuccess!
            )
          );
        } else {
          _registerDelegate!.onShowRegisterRequestProcessFailedCallback(registerFirstStepLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void sendRegisterOtp(SendRegisterOtpParameter sendRegisterOtpParameter) async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      _registerDelegate!.onShowSendRegisterOtpRequestProcessLoadingCallback();
      LoadDataResult<SendRegisterOtpResponse> sendRegisterOtpLoadDataResult = await sendRegisterOtpUseCase.execute(
        sendRegisterOtpParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('send-register-otp').value
      );
      _registerDelegate!.onRegisterBack();
      if (sendRegisterOtpLoadDataResult.isSuccess) {
        SendRegisterOtpResponse sendRegisterOtpResponse = sendRegisterOtpLoadDataResult.resultIfSuccess!;
        _updateRegisterStep(
          VerifyRegisterStep(
            sendRegisterOtpParameter: sendRegisterOtpParameter,
            sendRegisterOtpResponse: sendRegisterOtpResponse
          )
        );
        _registerDelegate!.onSendRegisterOtpRequestProcessSuccessCallback(sendRegisterOtpResponse);
      } else {
        _registerDelegate!.onShowSendRegisterOtpRequestProcessFailedCallback(sendRegisterOtpLoadDataResult.resultIfFailed);
      }
    }
  }

  void resendRegisterOtp() async {
    VerifyRegisterStep? foundedVerifyRegisterStep;
    int i = 0;
    while (i < _registerStepList.length) {
      RegisterStep iteratedRegisterStep = _registerStepList[i];
      if (iteratedRegisterStep is VerifyRegisterStep) {
        foundedVerifyRegisterStep = iteratedRegisterStep;
        break;
      }
      i++;
    }
    if (foundedVerifyRegisterStep != null) {
      sendRegisterOtp(foundedVerifyRegisterStep.sendRegisterOtpParameter);
    }
  }

  void verifyRegister(VerifyRegisterParameter verifyRegisterParameter) async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      _registerDelegate!.onShowVerifyRegisterRequestProcessLoadingCallback();
      LoadDataResult<VerifyRegisterResponse> verifyRegisterOtpLoadDataResult = await verifyRegisterUseCase.execute(
        verifyRegisterParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('verify-register').value
      );
      _registerDelegate!.onRegisterBack();
      if (verifyRegisterOtpLoadDataResult.isSuccess) {
        VerifyRegisterResponse verifyRegisterResponse = verifyRegisterOtpLoadDataResult.resultIfSuccess!;
        _credential = verifyRegisterResponse.credential;
        _updateRegisterStep(
          SecondRegisterStep()
        );
        _registerDelegate!.onVerifyRegisterRequestProcessSuccessCallback(verifyRegisterOtpLoadDataResult.resultIfSuccess!);
      } else {
        _registerDelegate!.onShowVerifyRegisterRequestProcessFailedCallback(verifyRegisterOtpLoadDataResult.resultIfFailed);
      }
    }
  }

  void registerSecondStep() async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      if (registerSecondStepValidatorGroup.validate()) {
        _registerDelegate!.onShowRegisterRequestProcessLoadingCallback();
        LoadDataResult<RegisterSecondStepResponse> registerSecondStepLoadDataResult = await registerSecondStepUseCase.execute(
          RegisterSecondStepParameter(
            credential: _credential.toEmptyStringNonNull,
            name: _registerDelegate!.onGetNameRegisterInput(),
            password: _registerDelegate!.onGetPasswordRegisterInput(),
            passwordConfirmation: _registerDelegate!.onGetPasswordConfirmationRegisterInput(),
            pushNotificationSubscriptionId: _registerDelegate!.onGetPushNotificationSubscriptionId(),
            gender: _registerDelegate!.onGetGenderRegisterInput()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('register-second-step').value
        );
        if (registerSecondStepLoadDataResult.isSuccess) {
          if (await loginOneSignal(registerSecondStepLoadDataResult.resultIfSuccess!.userId)) {
            return;
          }
          await _registerDelegate!.onSaveToken(registerSecondStepLoadDataResult.resultIfSuccess!.token);
          LoadDataResult<User> userLoadDataResult = await getUserUseCase.execute(
            GetUserParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('get-user-after-register').value
          ).map<User>(
            (getUserResponse) => getUserResponse.user
          );
          if (userLoadDataResult.isSuccess) {
            User user = userLoadDataResult.resultIfSuccess!;
            await _registerDelegate!.onSubscribeChatCountRealtimeChannel(user.id);
            await _registerDelegate!.onSubscribeNotificationCountRealtimeChannel(user.id);
          }
          _registerDelegate!.onRegisterBack();
          _registerDelegate!.onRegisterRequestProcessSuccessCallback();
        } else {
          _registerDelegate!.onRegisterBack();
          _registerDelegate!.onShowRegisterRequestProcessFailedCallback(registerSecondStepLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void register() async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      if (registerValidatorGroup.validate()) {
        _registerDelegate!.onShowRegisterRequestProcessLoadingCallback();
        LoadDataResult<RegisterResponse> registerLoadDataResult = await registerUseCase.execute(
          RegisterParameter(
            email: _registerDelegate!.onGetEmailOrPhoneNumberRegisterInput(),
            name: _registerDelegate!.onGetNameRegisterInput(),
            password: _registerDelegate!.onGetPasswordRegisterInput(),
            passwordConfirmation: _registerDelegate!.onGetPasswordConfirmationRegisterInput(),
            pushNotificationSubscriptionId: _registerDelegate!.onGetPushNotificationSubscriptionId()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('register').value
        );
        if (registerLoadDataResult.isSuccess) {
          if (await loginOneSignal(registerLoadDataResult.resultIfSuccess!.userId)) {
            return;
          }
          await _registerDelegate!.onSaveToken(registerLoadDataResult.resultIfSuccess!.token);
          LoadDataResult<User> userLoadDataResult = await getUserUseCase.execute(
            GetUserParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('get-user-after-register').value
          ).map<User>(
            (getUserResponse) => getUserResponse.user
          );
          if (userLoadDataResult.isSuccess) {
            User user = userLoadDataResult.resultIfSuccess!;
            await _registerDelegate!.onSubscribeChatCountRealtimeChannel(user.id);
            await _registerDelegate!.onSubscribeNotificationCountRealtimeChannel(user.id);
          }
          _registerDelegate!.onRegisterBack();
          _registerDelegate!.onRegisterRequestProcessSuccessCallback();
        } else {
          _registerDelegate!.onRegisterBack();
          _registerDelegate!.onShowRegisterRequestProcessFailedCallback(registerLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void registerWithGoogle() async {
    if (_registerDelegate != null) {
      _registerDelegate!.onUnfocusAllWidget();
      String? idToken = await _registerDelegate!.onRegisterWithGoogle();
      if (idToken.isNotEmptyString) {
        _registerDelegate!.onShowRegisterRequestProcessLoadingCallback();
        LoadDataResult<RegisterWithGoogleResponse> registerWithGoogleLoadDataResult = await registerWithGoogleUseCase.execute(
          RegisterWithGoogleParameter(
            idToken: idToken!,
            pushNotificationSubscriptionId: _registerDelegate!.onGetPushNotificationSubscriptionId()
          )
        ).future(
          parameter: apiRequestManager.addRequestToCancellationPart('register-with-google').value
        );
        if (registerWithGoogleLoadDataResult.isSuccess) {
          if (await loginOneSignal(registerWithGoogleLoadDataResult.resultIfSuccess!.userId)) {
            return;
          }
          await _registerDelegate!.onSaveToken(registerWithGoogleLoadDataResult.resultIfSuccess!.token);
          LoadDataResult<User> userLoadDataResult = await getUserUseCase.execute(
            GetUserParameter()
          ).future(
            parameter: apiRequestManager.addRequestToCancellationPart('get-user-after-register').value
          ).map<User>(
            (getUserResponse) => getUserResponse.user
          );
          if (userLoadDataResult.isSuccess) {
            User user = userLoadDataResult.resultIfSuccess!;
            await _registerDelegate!.onSubscribeChatCountRealtimeChannel(user.id);
            await _registerDelegate!.onSubscribeNotificationCountRealtimeChannel(user.id);
          }
          _registerDelegate!.onRegisterBack();
          _registerDelegate!.onRegisterRequestProcessSuccessCallback();
        } else {
          _registerDelegate!.onRegisterBack();
          _registerDelegate!.onShowRegisterRequestProcessFailedCallback(registerWithGoogleLoadDataResult.resultIfFailed);
        }
      }
    }
  }

  void _updateRegisterStep(RegisterStep registerStep) {
    registerStepWrapperRx.valueFromLast(
      (value) => RegisterStepWrapper(registerStep)
    );
    bool isExist = false;
    int i = 0;
    while (i < _registerStepList.length) {
      RegisterStep iteratedRegisterStep = _registerStepList[i];
      if (iteratedRegisterStep.stepNumber == registerStep.stepNumber) {
        isExist = true;
        break;
      }
      i++;
    }
    if (!isExist) {
      _registerStepList.add(registerStep);
    }
    update();
  }

  Future<bool> loginOneSignal(String userId) async {
    LoadDataResult<String> oneSignalLoginResult = await _registerDelegate!.onLoginIntoOneSignal(userId);
    if (oneSignalLoginResult.isFailed) {
      Get.back();
      _registerDelegate!.onShowRegisterRequestProcessFailedCallback(oneSignalLoginResult.resultIfFailed);
      return true;
    }
    return false;
  }
}

class RegisterDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnRegisterBack onRegisterBack;
  _OnGetRegisterInput onGetEmailOrPhoneNumberRegisterInput;
  _OnGetRegisterInput onGetNameRegisterInput;
  _OnGetRegisterInput onGetGenderRegisterInput;
  _OnGetRegisterInput onGetPasswordRegisterInput;
  _OnGetRegisterInput onGetPasswordConfirmationRegisterInput;
  _OnShowRegisterRequestProcessLoadingCallback onShowRegisterRequestProcessLoadingCallback;
  _OnRegisterRequestProcessSuccessCallback onRegisterRequestProcessSuccessCallback;
  _OnShowRegisterRequestProcessFailedCallback onShowRegisterRequestProcessFailedCallback;
  _OnShowRegisterFirstStepRequestProcessLoadingCallback onShowRegisterFirstStepRequestProcessLoadingCallback;
  _OnRegisterFirstStepRequestProcessSuccessCallback onRegisterFirstStepRequestProcessSuccessCallback;
  _OnShowRegisterFirstStepRequestProcessFailedCallback onShowRegisterFirstStepRequestProcessFailedCallback;
  _OnShowSendRegisterOtpRequestProcessLoadingCallback onShowSendRegisterOtpRequestProcessLoadingCallback;
  _OnSendRegisterOtpRequestProcessSuccessCallback onSendRegisterOtpRequestProcessSuccessCallback;
  _OnShowSendRegisterOtpRequestProcessFailedCallback onShowSendRegisterOtpRequestProcessFailedCallback;
  _OnShowVerifyRegisterRequestProcessLoadingCallback onShowVerifyRegisterRequestProcessLoadingCallback;
  _OnVerifyRegisterRequestProcessSuccessCallback onVerifyRegisterRequestProcessSuccessCallback;
  _OnShowVerifyRegisterRequestProcessFailedCallback onShowVerifyRegisterRequestProcessFailedCallback;
  _OnRegisterWithGoogle onRegisterWithGoogle;
  _OnSaveToken onSaveToken;
  OnLoginIntoOneSignal onLoginIntoOneSignal;
  OnGetPushNotificationSubscriptionId onGetPushNotificationSubscriptionId;
  Future<void> Function(String) onSubscribeChatCountRealtimeChannel;
  Future<void> Function(String) onSubscribeNotificationCountRealtimeChannel;

  RegisterDelegate({
    required this.onUnfocusAllWidget,
    required this.onRegisterBack,
    required this.onGetEmailOrPhoneNumberRegisterInput,
    required this.onGetNameRegisterInput,
    required this.onGetGenderRegisterInput,
    required this.onGetPasswordRegisterInput,
    required this.onGetPasswordConfirmationRegisterInput,
    required this.onShowRegisterRequestProcessLoadingCallback,
    required this.onRegisterRequestProcessSuccessCallback,
    required this.onShowRegisterRequestProcessFailedCallback,
    required this.onShowRegisterFirstStepRequestProcessLoadingCallback,
    required this.onRegisterFirstStepRequestProcessSuccessCallback,
    required this.onShowRegisterFirstStepRequestProcessFailedCallback,
    required this.onShowSendRegisterOtpRequestProcessLoadingCallback,
    required this.onSendRegisterOtpRequestProcessSuccessCallback,
    required this.onShowSendRegisterOtpRequestProcessFailedCallback,
    required this.onShowVerifyRegisterRequestProcessLoadingCallback,
    required this.onVerifyRegisterRequestProcessSuccessCallback,
    required this.onShowVerifyRegisterRequestProcessFailedCallback,
    required this.onRegisterWithGoogle,
    required this.onSaveToken,
    required this.onLoginIntoOneSignal,
    required this.onGetPushNotificationSubscriptionId,
    required this.onSubscribeChatCountRealtimeChannel,
    required this.onSubscribeNotificationCountRealtimeChannel
  });
}