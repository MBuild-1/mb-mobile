import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/modaldialogcontroller/auth_identity_modal_dialog_controller.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/auth_identity_parameter_and_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/parameter/auth_identity_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/parameter/email_auth_identity_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/parameter/phone_auth_identity_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/auth_identity_change_input_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/email_auth_identity_change_input_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/phone_auth_identity_change_input_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/auth_identity_change_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/email_auth_identity_change_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/phone_auth_identity_change_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/auth_identity_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/email_auth_identity_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/phone_auth_identity_verify_otp_parameter.dart';
import '../../../domain/usecase/auth_identity_change_input_use_case.dart';
import '../../../domain/usecase/auth_identity_change_use_case.dart';
import '../../../domain/usecase/auth_identity_change_verify_otp_use_case.dart';
import '../../../domain/usecase/auth_identity_send_verify_otp_use_case.dart';
import '../../../domain/usecase/auth_identity_verify_otp_use_case.dart';
import '../../../domain/usecase/get_country_list_use_case.dart';
import '../../../misc/authidentitystep/auth_identity_step.dart';
import '../../../misc/authidentitystep/auth_identity_step_wrapper.dart';
import '../../../misc/authidentitystep/changeauthidentitystep/change_auth_identity_step.dart';
import '../../../misc/authidentitystep/changeauthidentitystep/email_change_auth_identity_step.dart';
import '../../../misc/authidentitystep/changeauthidentitystep/phone_change_auth_identity_step.dart';
import '../../../misc/authidentitystep/choose_verification_method_auth_identity_step.dart';
import '../../../misc/authidentitystep/failed_auth_identity_step.dart';
import '../../../misc/authidentitystep/is_loading_auth_identity_step.dart';
import '../../../misc/authidentitystep/verifyauthidentitystep/change_input_verify_auth_identity_step.dart';
import '../../../misc/authidentitystep/verifyauthidentitystep/choose_verification_verify_auth_identity_step.dart';
import '../../../misc/authidentitystep/verifyauthidentitystep/verify_auth_identity_step.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/validation/validator/validator.dart';
import '../../../misc/widget_helper.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/field.dart';
import '../../widget/modified_loading_indicator.dart';
import '../../widget/modified_shimmer.dart';
import '../../widget/modified_svg_picture.dart';
import '../../widget/modified_text_field.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../../widget/rx_consumer.dart';
import 'modal_dialog_page.dart';

class AuthIdentityModalDialogPage extends ModalDialogPage<AuthIdentityModalDialogController> {
  final AuthIdentityModalDialogPageAction authIdentityModalDialogPageAction;

  AuthIdentityModalDialogPage({
    super.key,
    required this.authIdentityModalDialogPageAction
  });

  AuthIdentityModalDialogController get authIdentityModalDialogController => modalDialogController.controller;

  @override
  AuthIdentityModalDialogController onCreateModalDialogController() {
    return AuthIdentityModalDialogController(
      controllerManager,
      Injector.locator<AuthIdentitySendVerifyOtpUseCase>(),
      Injector.locator<AuthIdentityVerifyOtpUseCase>(),
      Injector.locator<AuthIdentityChangeInputUseCase>(),
      Injector.locator<AuthIdentityChangeVerifyOtpUseCase>(),
      Injector.locator<AuthIdentityChangeUseCase>(),
      Injector.locator<GetCountryListUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulAuthIdentityControllerMediatorWidget(
      authIdentityModalDialogController: authIdentityModalDialogController,
      authIdentityModalDialogPageAction: authIdentityModalDialogPageAction
    );
  }
}

class _StatefulAuthIdentityControllerMediatorWidget extends StatefulWidget {
  final AuthIdentityModalDialogController authIdentityModalDialogController;
  final AuthIdentityModalDialogPageAction authIdentityModalDialogPageAction;

  const _StatefulAuthIdentityControllerMediatorWidget({
    required this.authIdentityModalDialogController,
    required this.authIdentityModalDialogPageAction
  });

  @override
  State<_StatefulAuthIdentityControllerMediatorWidget> createState() => _StatefulAuthIdentityControllerMediatorWidgetState();
}

class _StatefulAuthIdentityControllerMediatorWidgetState extends State<_StatefulAuthIdentityControllerMediatorWidget> {
  final FocusNode _verificationOtpFocusNode = FocusNode();
  final TextEditingController _authIdentityOtpTextEditingController = TextEditingController();
  final TapGestureRecognizer _resendVerificationTapGestureRecognizer = TapGestureRecognizer();
  Timer? _resendVerificationCountdownTimer;
  final int _maxCountdownTimerValue = 120;
  int _countdownTimerValue = 0;

  final TextEditingController _authIdentityChangeTextEditingController = TextEditingController();

  AuthIdentityParameterAndResponse? _authIdentityParameterAndResponse;

  @override
  void initState() {
    widget.authIdentityModalDialogPageAction._changeAuthIdentityStep = (authIdentityStep) {
      if (authIdentityStep is ChooseVerificationMethodAuthIdentityStep) {
        _authIdentityParameterAndResponse = authIdentityStep.authIdentityParameterAndResponse;
      }
      widget.authIdentityModalDialogController.updateAuthIdentityStep(authIdentityStep);
    };
    super.initState();
  }

  void _resetAuthIdentityVerifyOtpScreenConfig() {
    _authIdentityOtpTextEditingController.text = "";
    if (_resendVerificationCountdownTimer != null) {
      _resendVerificationCountdownTimer!.cancel();
    }
    _countdownTimerValue = _maxCountdownTimerValue;
    _resendVerificationCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() => _countdownTimerValue -= 1);
        if (_countdownTimerValue <= 0) {
          timer.cancel();
        }
      }
    );
  }

  void _cancelVerificationCountdownTimer() {
    if (_resendVerificationCountdownTimer != null) {
      _resendVerificationCountdownTimer!.cancel();
    }
    _countdownTimerValue = _maxCountdownTimerValue;
  }

  @override
  Widget build(BuildContext context) {
    widget.authIdentityModalDialogController.setAuthIdentityDelegate(
      AuthIdentityDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onAuthIdentityBack: () => Get.back(),
        onGetAuthIdentityChangeVerifyOtpInput: () => _authIdentityOtpTextEditingController.text,
        onGetAuthIdentityChangeInput: () => _authIdentityChangeTextEditingController.text,
        onGetAuthIdentitySendVerifyOtpInput: () => _authIdentityOtpTextEditingController.text,
        onShowAuthIdentitySendVerifyProcessLoadingCallback: () async {
          DialogHelper.showLoadingDialog(context);
        },
        onShowAuthIdentitySendVerifyProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onAuthIdentitySendVerifyProcessSuccessCallback: (authIdentitySendVerifyOtpResponse) async {
          if (_authIdentityParameterAndResponse != null) {
            _resetAuthIdentityVerifyOtpScreenConfig();
            widget.authIdentityModalDialogController.updateAuthIdentityStep(
              ChooseVerificationVerifyAuthIdentityStep()
            );
          }
        },
        onShowAuthIdentityVerifyOtpProcessLoadingCallback: () async {
          DialogHelper.showLoadingDialog(context);
        },
        onShowAuthIdentityVerifyOtpProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onAuthIdentityVerifyOtpProcessSuccessCallback: (authIdentityVerifyOtpResponse) async {
          if (_authIdentityParameterAndResponse != null) {
            AuthIdentityParameter authIdentityParameter = _authIdentityParameterAndResponse!.authIdentityParameter;
            _authIdentityChangeTextEditingController.text = "";
            late ChangeAuthIdentityStep changeAuthIdentityStep;
            if (authIdentityParameter is EmailAuthIdentityParameter) {
              changeAuthIdentityStep = EmailChangeAuthIdentityStep();
            } else if (authIdentityParameter is PhoneAuthIdentityParameter) {
              changeAuthIdentityStep = PhoneChangeAuthIdentityStep(countryCodeListLoadDataResult: NoLoadDataResult<List<String>>());
            }
            widget.authIdentityModalDialogController.updateAuthIdentityStep(changeAuthIdentityStep);
          }
        },
        onShowAuthIdentityChangeInputProcessLoadingCallback: () async {
          DialogHelper.showLoadingDialog(context);
        },
        onShowAuthIdentityChangeInputProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onAuthIdentityChangeInputProcessSuccessCallback: (authIdentityChangeInputResponse) async {
          if (_authIdentityParameterAndResponse != null) {
            _resetAuthIdentityVerifyOtpScreenConfig();
            widget.authIdentityModalDialogController.updateAuthIdentityStep(
              ChangeInputVerifyAuthIdentityStep()
            );
          }
        },
        onShowAuthIdentityChangeVerifyOtpProcessLoadingCallback: () async {
          DialogHelper.showLoadingDialog(context);
        },
        onShowAuthIdentityChangeVerifyOtpProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onAuthIdentityChangeVerifyOtpProcessSuccessCallback: (authIdentityChangeVerifyResponse) async {
          _cancelVerificationCountdownTimer();
          widget.authIdentityModalDialogController.authIdentityChange(
            AuthIdentityChangeParameter(credential: _authIdentityChangeTextEditingController.text)
          );
        },
        onShowAuthIdentityChangeProcessLoadingCallback: () async {
          DialogHelper.showLoadingDialog(context);
        },
        onAuthIdentityChangeProcessSuccessCallback: (authIdentityChangeResponse) async {
          Get.back(result: true);
        },
        onShowAuthIdentityChangeProcessFailedCallback: (e) async {
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e,
            onPressed: () => Get.back(result: true)
          );
        },
      )
    );
    return RxConsumer<AuthIdentityStepWrapper>(
      rxValue: widget.authIdentityModalDialogController.authIdentityStepWrapperRx,
      onConsumeValue: (context, value) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                return ModifiedAppBar(
                  titleInterceptor: (context, title) => Row(
                    children: [
                      Builder(
                        builder: (context) {
                          String text = "";
                          return Text(text);
                        }
                      )
                    ],
                  ),
                  primary: false,
                );
              }
            ),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Builder(
                builder: (BuildContext context) {
                  AuthIdentityStep authIdentityStep = value.authIdentityStep;
                  if (authIdentityStep is IsLoadingAuthIdentityStep) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("Loading..."),
                          SizedBox(height: 12.0),
                          ModifiedLoadingIndicator()
                        ]
                      ),
                    );
                  } else if (authIdentityStep is ChooseVerificationMethodAuthIdentityStep) {
                    AuthIdentityParameter authIdentityParameter = authIdentityStep.authIdentityParameterAndResponse.authIdentityParameter;
                    AuthIdentityResponse authIdentityResponse = authIdentityStep.authIdentityParameterAndResponse.authIdentityResponse;
                    void runAuthIdentitySendVerifyOtpProcess() {
                      widget.authIdentityModalDialogController.authIdentitySendVerifyOtpProcess(
                        AuthIdentitySendVerifyOtpParameter(
                          credential: authIdentityResponse.data
                        )
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            MultiLanguageString({
                              Constant.textInIdLanguageKey: "Pilih Metode Verifikasi",
                              Constant.textEnUsLanguageKey: "Select Verification Method"
                            }).toEmptyStringNonNull,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            MultiLanguageString({
                              Constant.textInIdLanguageKey: "Pilih salah satu metode dibawah ini untuk mendapatkan kode verifikasi",
                              Constant.textEnUsLanguageKey: "Choose one of the methods below to get a verification code"
                            }).toEmptyStringNonNull,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          if (authIdentityParameter is EmailAuthIdentityParameter) ...[
                            WidgetHelper.selectVerificationMethod(
                              icon: const Icon(
                                Icons.mail_outline,
                                size: 24.0,
                              ),
                              title: Text(
                                MultiLanguageString({
                                  Constant.textInIdLanguageKey: "Email ke",
                                  Constant.textEnUsLanguageKey: "Email to"
                                }).toEmptyStringNonNull,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              description: Text(authIdentityResponse.data),
                              onTap: runAuthIdentitySendVerifyOtpProcess
                            )
                          ] else if (authIdentityParameter is PhoneAuthIdentityParameter) ...[
                            WidgetHelper.selectVerificationMethod(
                              icon: ModifiedSvgPicture.asset(
                                Constant.vectorWhatsappLogo,
                                width: 24.0
                              ),
                              title: Text(
                                MultiLanguageString({
                                  Constant.textInIdLanguageKey: "WhatsApp ke",
                                  Constant.textEnUsLanguageKey: "WhatsApp to"
                                }).toEmptyStringNonNull,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              description: Text(authIdentityResponse.data),
                              onTap: runAuthIdentitySendVerifyOtpProcess
                            )
                          ],
                        ]
                      ),
                    );
                  } else if (authIdentityStep is VerifyAuthIdentityStep) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            MultiLanguageString({
                              Constant.textInIdLanguageKey: "Masukan Kode Verifikasi",
                              Constant.textEnUsLanguageKey: "Enter Verification Code"
                            }).toEmptyStringNonNull,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
                          Builder(
                            builder: (context) {
                              AuthIdentityParameterAndResponse authIdentityParameterAndResponse = _authIdentityParameterAndResponse!;
                              AuthIdentityParameter authIdentityParameter = authIdentityParameterAndResponse.authIdentityParameter;
                              AuthIdentityResponse authIdentityResponse = authIdentityParameterAndResponse.authIdentityResponse;
                              late String type;
                              if (authIdentityParameter is EmailAuthIdentityParameter) {
                                type = "e-mail";
                              } else if (authIdentityParameter is PhoneAuthIdentityParameter) {
                                type = "WhatsApp";
                              } else {
                                type = MultiLanguageString({
                                  Constant.textInIdLanguageKey: "(Tidak Diketahui)",
                                  Constant.textEnUsLanguageKey: "(Unknown)"
                                }).toEmptyStringNonNull;
                              }
                              return Text(
                                MultiLanguageString({
                                  Constant.textInIdLanguageKey: "Kode verifikasi telah dikirim melalui $type ke ${authIdentityResponse.data}",
                                  Constant.textEnUsLanguageKey: "A verification code has been sent via $type to ${authIdentityResponse.data}"
                                }).toEmptyStringNonNull,
                                textAlign: TextAlign.center,
                              );
                            }
                          ),
                          const SizedBox(height: 14.0),
                          SizedBox(
                            width: 180,
                            child: PinCodeTextField(
                              onTap: () async {
                                WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
                                  _verificationOtpFocusNode.unfocus();
                                  await Future.delayed(const Duration(milliseconds: 10));
                                  _verificationOtpFocusNode.requestFocus();
                                });
                              },
                              focusNode: _verificationOtpFocusNode,
                              appContext: context,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.none,
                              pinTheme: PinTheme(
                                selectedColor: Constant.colorMain,
                                activeColor: Constant.colorMain,
                                inactiveColor: Constant.colorMain,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 40,
                                fieldWidth: 30,
                                activeFillColor: Colors.black,
                              ),
                              animationDuration: const Duration(milliseconds: 0),
                              enableActiveFill: false,
                              controller: _authIdentityOtpTextEditingController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              hintCharacter: '●',
                              autoDisposeControllers: false,
                              autoFocus: false,
                              autoUnfocus: false,
                              onCompleted: _onCompleted,
                              beforeTextPaste: (text) {
                                return false;
                              },
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Builder(
                            builder: (context) {
                              _resendVerificationTapGestureRecognizer.onTap = () {
                                if (_authIdentityParameterAndResponse != null) {
                                  AuthIdentityResponse authIdentityResponse = _authIdentityParameterAndResponse!.authIdentityResponse;
                                  if (authIdentityStep is ChooseVerificationVerifyAuthIdentityStep) {
                                    widget.authIdentityModalDialogController.authIdentitySendVerifyOtpProcess(
                                      AuthIdentitySendVerifyOtpParameter(
                                        credential: authIdentityResponse.data
                                      )
                                    );
                                  } else if (authIdentityStep is ChangeInputVerifyAuthIdentityStep) {
                                    late AuthIdentityChangeInputParameter authIdentityChangeInputParameter;
                                    if (authIdentityStep is EmailChangeAuthIdentityStep) {
                                      authIdentityChangeInputParameter = EmailAuthIdentityChangeInputParameter(email: _authIdentityChangeTextEditingController.text);
                                    } else if (authIdentityStep is PhoneChangeAuthIdentityStep) {
                                      authIdentityChangeInputParameter = PhoneAuthIdentityChangeInputParameter(phone: _authIdentityChangeTextEditingController.text);
                                    } else {
                                      throw MessageError(title: "Subclass of ChangeAuthIdentityStep is not suitable");
                                    }
                                    widget.authIdentityModalDialogController.authIdentityChangeInput(authIdentityChangeInputParameter);
                                  }
                                }
                              };
                              return Text.rich(
                                TextSpan(
                                  children: [
                                    if (_countdownTimerValue > 0) ...[
                                      TextSpan(
                                        text: MultiLanguageString({
                                          Constant.textInIdLanguageKey: "Mohon tunggu dalam ",
                                          Constant.textEnUsLanguageKey: "Please wait in "
                                        }).toEmptyStringNonNull
                                      ),
                                      TextSpan(
                                        text: MultiLanguageString({
                                          Constant.textInIdLanguageKey: "$_countdownTimerValue detik",
                                          Constant.textEnUsLanguageKey: "$_countdownTimerValue seconds"
                                        }).toEmptyStringNonNull,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      TextSpan(
                                        text: MultiLanguageString({
                                          Constant.textInIdLanguageKey: " untuk kirim ulang verifikasi",
                                          Constant.textEnUsLanguageKey: " for resend verification"
                                        }).toEmptyStringNonNull
                                      )
                                    ] else ...[
                                      TextSpan(
                                        text: MultiLanguageString({
                                          Constant.textInIdLanguageKey: "Kirim Ulang Verifikasi",
                                          Constant.textEnUsLanguageKey: "Resend Verification"
                                        }).toEmptyStringNonNull,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).colorScheme.primary
                                        ),
                                        recognizer: _resendVerificationTapGestureRecognizer
                                      )
                                    ]
                                  ]
                                ),
                                textAlign: TextAlign.center,
                              );
                            }
                          )
                        ],
                      )
                    );
                  } else if (authIdentityStep is ChangeAuthIdentityStep) {
                    Widget emailOrPhoneNumberValidatorWidget(String label) {
                      return RxConsumer<Validator>(
                        rxValue: widget.authIdentityModalDialogController.changeAuthIdentityValidatorRx,
                        onConsumeValue: (context, value) => Field(
                          child: (context, validationResult, validator) => ModifiedTextField(
                            isError: validationResult.isFailed,
                            controller: _authIdentityChangeTextEditingController,
                            decoration: DefaultInputDecoration(
                              label: Text(label),
                              labelStyle: const TextStyle(color: Colors.black),
                              floatingLabelStyle: const TextStyle(color: Colors.black),
                              floatingLabelBehavior: FloatingLabelBehavior.always,
                            ),
                            onChanged: (value) => validator?.validate(),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          validator: value,
                        ),
                      );
                    }
                    late String title;
                    late String description;
                    late Widget changeAuthIdentityInputWidget;
                    late AuthIdentityChangeInputParameter authIdentityChangeInputParameter;
                    if (authIdentityStep is EmailChangeAuthIdentityStep) {
                      title = MultiLanguageString({
                        Constant.textInIdLanguageKey: "Email Baru",
                        Constant.textEnUsLanguageKey: "New Email"
                      }).toEmptyStringNonNull;
                      description = MultiLanguageString({
                        Constant.textInIdLanguageKey: "Masukan email baru.",
                        Constant.textEnUsLanguageKey: "Input email baru."
                      }).toEmptyStringNonNull;
                      authIdentityChangeInputParameter = EmailAuthIdentityChangeInputParameter(email: _authIdentityChangeTextEditingController.text);
                      changeAuthIdentityInputWidget = emailOrPhoneNumberValidatorWidget("Email".tr);
                    } else if (authIdentityStep is PhoneChangeAuthIdentityStep) {
                      title = MultiLanguageString({
                        Constant.textInIdLanguageKey: "Nomor Telepon Baru",
                        Constant.textEnUsLanguageKey: "New Phone Number"
                      }).toEmptyStringNonNull;
                      description = MultiLanguageString({
                        Constant.textInIdLanguageKey: "Masukan nomor telepon baru.",
                        Constant.textEnUsLanguageKey: "Input new phone number."
                      }).toEmptyStringNonNull;
                      authIdentityChangeInputParameter = PhoneAuthIdentityChangeInputParameter(phone: _authIdentityChangeTextEditingController.text);
                      LoadDataResult<List<String>> countryCodeListLoadDataResult = authIdentityStep.countryCodeListLoadDataResult;
                      bool isLoading = !countryCodeListLoadDataResult.isSuccess;
                      changeAuthIdentityInputWidget = !isLoading ? emailOrPhoneNumberValidatorWidget("Phone Number".tr) : ModifiedShimmer.fromColors(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: Constant.inputBorderRadius
                          ),
                        ),
                      );
                    } else {
                      throw MessageError(title: "Subclass of ChangeAuthIdentityStep is not suitable");
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0).copyWith(top: 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            description,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          changeAuthIdentityInputWidget,
                          const SizedBox(height: 16.0),
                          SizedOutlineGradientButton(
                            width: double.infinity,
                            onPressed: () => widget.authIdentityModalDialogController.authIdentityChangeInput(authIdentityChangeInputParameter),
                            text: MultiLanguageString({
                              Constant.textInIdLanguageKey: "Verifikasi Lagi",
                              Constant.textEnUsLanguageKey: "Verification Again"
                            }).toEmptyStringNonNull,
                          ),
                        ],
                      ),
                    );
                  } else if (authIdentityStep is FailedAuthIdentityStep) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0).copyWith(top: 0.0),
                      child: WidgetHelper.buildFailedPromptIndicatorFromErrorProvider(
                        context: context,
                        errorProvider: Injector.locator<ErrorProvider>(),
                        e: authIdentityStep.e,
                        buttonText: "Exit".tr,
                        onPressed: () => Get.back(result: true)
                      )
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ]
        );
      }
    );
  }

  void _onCompleted(String value) {
    AuthIdentityStepWrapper authIdentityStepWrapper = widget.authIdentityModalDialogController.authIdentityStepWrapperRx.value;
    AuthIdentityStep authIdentityStep = authIdentityStepWrapper.authIdentityStep;
    if (authIdentityStep is VerifyAuthIdentityStep) {
      AuthIdentityParameterAndResponse authIdentityParameterAndResponse = _authIdentityParameterAndResponse!;
      AuthIdentityParameter authIdentityParameter = authIdentityParameterAndResponse.authIdentityParameter;
      AuthIdentityResponse authIdentityResponse = authIdentityParameterAndResponse.authIdentityResponse;
      if (authIdentityStep is ChooseVerificationVerifyAuthIdentityStep) {
        if (authIdentityParameter is EmailAuthIdentityParameter) {
          widget.authIdentityModalDialogController.authIdentityVerifyOtp(
            EmailAuthIdentityVerifyOtpParameter(
              email: authIdentityResponse.data,
              otp: _authIdentityOtpTextEditingController.text
            )
          );
        } else if (authIdentityParameter is PhoneAuthIdentityParameter) {
          widget.authIdentityModalDialogController.authIdentityVerifyOtp(
            PhoneAuthIdentityVerifyOtpParameter(
              phone: authIdentityResponse.data,
              otp: _authIdentityOtpTextEditingController.text
            )
          );
        }
      } else if (authIdentityStep is ChangeInputVerifyAuthIdentityStep) {
        if (authIdentityParameter is EmailAuthIdentityParameter) {
          widget.authIdentityModalDialogController.authIdentityChangeVerifyOtp(
            EmailAuthIdentityChangeVerifyOtpParameter(
              email: _authIdentityChangeTextEditingController.text,
              otp: _authIdentityOtpTextEditingController.text
            )
          );
        } else if (authIdentityParameter is PhoneAuthIdentityParameter) {
          widget.authIdentityModalDialogController.authIdentityChangeVerifyOtp(
            PhoneAuthIdentityChangeVerifyOtpParameter(
              phone: _authIdentityChangeTextEditingController.text,
              otp: _authIdentityOtpTextEditingController.text
            )
          );
        }
      }
    }
  }
}

class AuthIdentityModalDialogPageAction {
  void Function(AuthIdentityStep)? _changeAuthIdentityStep;

  void Function(AuthIdentityStep) get changeAuthIdentityStep => (authIdentityStep) {
    if (_changeAuthIdentityStep != null) {
      _changeAuthIdentityStep!(authIdentityStep);
    }
  };
}