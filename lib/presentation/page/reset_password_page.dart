import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/navigator_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sizer/sizer.dart';

import '../../controller/reset_password_controller.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../../domain/entity/resetpassword/check/check_reset_password_response.dart';
import '../../domain/usecase/check_reset_password_use_case.dart';
import '../../domain/usecase/reset_password_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/inputdecoration/default_input_decoration.dart';
import '../../misc/load_data_result.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/routeargument/forgot_password_route_argument.dart';
import '../../misc/routeargument/reset_password_route_argument.dart';
import '../../misc/string_util.dart';
import '../../misc/toast_helper.dart';
import '../../misc/validation/validationresult/is_phone_number_success_validation_result.dart';
import '../../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/field.dart';
import '../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modified_text_field.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/password_obscurer.dart';
import '../widget/rx_consumer.dart';
import 'getx_page.dart';

class ResetPasswordPage extends RestorableGetxPage<_ResetPasswordPageRestoration> {
  late final ControllerMember<ResetPasswordController> _resetPasswordController = ControllerMember<ResetPasswordController>().addToControllerManager(controllerManager);

  final ResetPasswordPageParameter resetPasswordPageParameter;

  ResetPasswordPage({
    Key? key,
    required this.resetPasswordPageParameter
  }) : super(key: key, pageRestorationId: () => "reset-password-page");

  @override
  void onSetController() {
    _resetPasswordController.controller = GetExtended.put<ResetPasswordController>(
      ResetPasswordController(
        controllerManager,
        Injector.locator<ResetPasswordUseCase>(),
        Injector.locator<CheckResetPasswordUseCase>(),
      ),
      tag: pageName
    );
  }

  @override
  _ResetPasswordPageRestoration createPageRestoration() => _ResetPasswordPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulResetPasswordControllerMediatorWidget(
      resetPasswordController: _resetPasswordController.controller,
      resetPasswordPageParameter: resetPasswordPageParameter,
      pageName: pageName
    );
  }
}

class _ResetPasswordPageRestoration extends ExtendedMixableGetxPageRestoration {
  @override
  // ignore: unnecessary_overrides
  void initState() {
    super.initState();
  }

  @override
  // ignore: unnecessary_overrides
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  // ignore: unnecessary_overrides
  void dispose() {
    super.dispose();
  }
}

class ResetPasswordPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final ResetPasswordPageParameter resetPasswordPageParameter;

  ResetPasswordPageGetPageBuilderAssistant({
    required this.resetPasswordPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => ResetPasswordPage(
    resetPasswordPageParameter: resetPasswordPageParameter
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    ResetPasswordPage(
      resetPasswordPageParameter: resetPasswordPageParameter
    )
  ));
}

mixin ResetPasswordPageRestorationMixin on MixableGetxPageRestoration {
  late ResetPasswordPageRestorableRouteFuture resetPasswordPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    resetPasswordPageRestorableRouteFuture = ResetPasswordPageRestorableRouteFuture(restorationId: restorationIdWithPageName('reset-password-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    resetPasswordPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    resetPasswordPageRestorableRouteFuture.dispose();
  }
}

class ResetPasswordPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ResetPasswordPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    ResetPasswordPageParameter resetPasswordPageParameter = arguments.toResetPasswordPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        ResetPasswordPageGetPageBuilderAssistant(
          resetPasswordPageParameter: resetPasswordPageParameter
        )
      ),
      arguments: ResetPasswordRouteArgument()
    );
  }

  @pragma('vm:entry-point')
  static Route<void> _pageRouteBuilder(BuildContext context, Object? arguments) {
    return _getRoute(arguments)!;
  }

  @override
  bool checkBeforePresent([Object? arguments]) => _getRoute(arguments) != null;

  @override
  void presentIfCheckIsPassed([Object? arguments]) => _pageRoute.present(arguments);

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    restorator.registerForRestoration(_pageRoute, restorationId);
  }

  @override
  void dispose() {
    _pageRoute.dispose();
  }
}

class _StatefulResetPasswordControllerMediatorWidget extends StatefulWidget {
  final ResetPasswordController resetPasswordController;
  final ResetPasswordPageParameter resetPasswordPageParameter;
  final String pageName;

  const _StatefulResetPasswordControllerMediatorWidget({
    required this.resetPasswordController,
    required this.resetPasswordPageParameter,
    required this.pageName
  });

  @override
  State<_StatefulResetPasswordControllerMediatorWidget> createState() => _StatefulResetPasswordControllerMediatorWidgetState();
}

class _StatefulResetPasswordControllerMediatorWidgetState extends State<_StatefulResetPasswordControllerMediatorWidget> {
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _passwordConfirmationTextEditingController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;
  dynamic _failedLoginError;

  final TapGestureRecognizer _resendVerificationTapGestureRecognizer = TapGestureRecognizer();
  final int _maxCountdownTimerValue = 120;
  int _countdownTimerValue = 0;
  Timer? _resendVerificationCountdownTimer;
  late ResetPasswordPageParameterType _resetPasswordPageParameterType;
  int _step = 0;

  final FocusNode _verificationOtpFocusNode = FocusNode();
  final TextEditingController _verificationOtpTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initVerificationCountdownTimer();
    String? forgotPasswordPageRouteKey = _getForgotPasswordPageRouteKey();
    if (forgotPasswordPageRouteKey.isNotEmptyString) {
      MainRouteObserver.onResendForgotPasswordWhatsappPhoneNumberCallbackOtp[forgotPasswordPageRouteKey!] = (typeValidationResult) {
        if (typeValidationResult is IsPhoneNumberSuccessValidationResult) {
          setState(() {});
          _initVerificationCountdownTimer();
        }
      };
    }
    _resetPasswordPageParameterType = widget.resetPasswordPageParameter.resetPasswordPageParameterType;
    if (_resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
      _step = 1;
    } else {
      _step = 2;
    }
  }

  void _initVerificationCountdownTimer() {
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

  String? _getForgotPasswordPageRouteKey() {
    Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
    List<String> routeKeyList = List.of(routeMap.keys);
    int i = 0;
    int? foundedI;
    for (var element in routeMap.entries) {
      var arguments = element.value?.route?.settings.arguments;
      if (arguments is ForgotPasswordRouteArgument) {
        foundedI = i;
        break;
      }
      i++;
    }
    if (foundedI != null) {
      String mainMenuRouteKey = routeKeyList[foundedI];
      return mainMenuRouteKey;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    widget.resetPasswordController.setResetPasswordDelegate(
      ResetPasswordDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetCode: () {
          ResetPasswordPageParameterType resetPasswordPageParameterType = _resetPasswordPageParameterType;
          if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
            return _verificationOtpTextEditingController.text;
          } else {
            return widget.resetPasswordPageParameter.code;
          }
        },
        onGetNewPasswordInput: () => _passwordTextEditingController.text,
        onGetConfirmNewPasswordInput: () => _passwordConfirmationTextEditingController.text,
        onResetPasswordBack: () => Get.back(),
        onShowResetPasswordRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowResetPasswordRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onResetPasswordRequestProcessSuccessCallback: (resetPasswordResponse) async {
          if (_resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
            Navigator.of(context).popUntilLogin();
          } else {
            Get.back();
          }
          ToastHelper.showToast("${"Success reset password".tr}.");
        },
        onShowCheckPasswordRequestProcessFailedCallback: (e) async {
          Get.back();
          ToastHelper.showToast(
            Injector.locator<ErrorProvider>()
              .onGetErrorProviderResult(e)
              .toErrorProviderResultNonNull()
              .message
          );
        },
        onShowSubmitWhatsappPhoneNumberOtpRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onSubmitWhatsappPhoneNumberOtpRequestProcessSuccessCallback: (e) async {
          _step = 2;
          if (_resendVerificationCountdownTimer != null) {
            _resendVerificationCountdownTimer!.cancel();
          }
          _countdownTimerValue = _maxCountdownTimerValue;
          setState(() {});
        },
        onShowSubmitWhatsappPhoneNumberOtpRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onGetResetPasswordPageParameterType: () => _resetPasswordPageParameterType
      )
    );
    ResetPasswordPageParameterType resetPasswordPageParameterType = _resetPasswordPageParameterType;
    if (resetPasswordPageParameterType is EmailResetPasswordPageParameterType) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.resetPasswordController.checkResetPassword();
      });
    }
    return WillPopScope(
      onWillPop: () async {
        DialogHelper.showPromptCancelResetPassword(
          context,
          () => Navigator.of(context).popUntilLogin()
        );
        return false;
      },
      child: ModifiedScaffold(
        appBar: ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Reset Password".tr),
              Expanded(
                child: title ?? Container()
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(4.w),
            child: Builder(
              builder: (context) {
                if (_step == 1) {
                  if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Builder(
                          builder: (context) {
                            Widget icon(Widget icon) {
                              return Column(
                                children: [
                                  icon,
                                  const SizedBox(height: 10)
                                ]
                              );
                            }
                            return icon(
                              ModifiedSvgPicture.asset(
                                Constant.vectorWhatsappLogo,
                                width: 36.0
                              )
                            );
                          }
                        ),
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
                            String type = "WhatsApp";
                            return Text(
                              MultiLanguageString({
                                Constant.textInIdLanguageKey: "Kode verifikasi telah dikirim melalui $type ke ${resetPasswordPageParameterType.phoneNumber}",
                                Constant.textEnUsLanguageKey: "A verification code has been sent via $type to ${resetPasswordPageParameterType.phoneNumber}"
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
                            controller: _verificationOtpTextEditingController,
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
                              String? forgotPasswordRouteKey = _getForgotPasswordPageRouteKey();
                              if (forgotPasswordRouteKey.isNotEmptyString) {
                                if (MainRouteObserver.onResendForgotPasswordWhatsappPhoneNumberOtp[forgotPasswordRouteKey] != null) {
                                  MainRouteObserver.onResendForgotPasswordWhatsappPhoneNumberOtp[forgotPasswordRouteKey]!();
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
                      ]
                    );
                  } else {
                    return const SizedBox();
                  }
                } else if (_step == 2) {
                  return RxConsumer<LoadDataResultWrapper<CheckResetPasswordResponse>>(
                    rxValue: widget.resetPasswordController.checkResetPasswordLoadDataResultWrapperRx,
                    onConsumeValue: (context, value) => LoadDataResultImplementer<CheckResetPasswordResponse>(
                      loadDataResult: value.loadDataResult,
                      errorProvider: Injector.locator<ErrorProvider>(),
                      onSuccessLoadDataResultWidget: (user) {
                        return NotificationListener<OverscrollIndicatorNotification>(
                          onNotification: (OverscrollIndicatorNotification overscroll) {
                            overscroll.disallowIndicator();
                            return false;
                          },
                          child: Column(
                            children: [
                              if (_failedLoginError != null) ...[
                                Builder(
                                  builder: (context) {
                                    ErrorProviderResult errorProviderResult = Injector.locator<ErrorProvider>()
                                      .onGetErrorProviderResult(_failedLoginError)
                                      .toErrorProviderResultNonNull();
                                    return Container(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          errorProviderResult.message,
                                          style: const TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16.0),
                                        color: Constant.colorRedDanger
                                      ),
                                    );
                                  }
                                ),
                                SizedBox(height: 3.h),
                              ],
                              RxConsumer<PasswordCompoundValidator>(
                                rxValue: widget.resetPasswordController.resetPasswordCompoundValidatorRx,
                                onConsumeValue: (context, passwordCompoundValidator) => Field(
                                  child: (context, validationResult, validator) => ModifiedTextField(
                                    isError: validationResult.isFailed,
                                    controller: _passwordTextEditingController,
                                    decoration: DefaultInputDecoration(
                                      label: Text("Password".tr),
                                      labelStyle: const TextStyle(color: Colors.black),
                                      floatingLabelStyle: const TextStyle(color: Colors.black),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      suffixIcon: PasswordObscurer(
                                        obscurePassword: _obscurePassword,
                                        onObscurePassword: () => setState(() => _obscurePassword = !_obscurePassword),
                                      )
                                    ),
                                    obscureText: _obscurePassword,
                                    onChanged: (value) => passwordCompoundValidator.validate(),
                                    textInputAction: TextInputAction.next,
                                  ),
                                  validator: passwordCompoundValidator.passwordValidator,
                                )
                              ),
                              SizedBox(height: 3.h),
                              RxConsumer<PasswordCompoundValidator>(
                                rxValue: widget.resetPasswordController.resetPasswordCompoundValidatorRx,
                                onConsumeValue: (context, passwordCompoundValidator) => Field(
                                  child: (context, validationResult, validator) => ModifiedTextField(
                                    isError: validationResult.isFailed,
                                    controller: _passwordConfirmationTextEditingController,
                                    decoration: DefaultInputDecoration(
                                      label: Text("Password Confirmation".tr),
                                      labelStyle: const TextStyle(color: Colors.black),
                                      floatingLabelStyle: const TextStyle(color: Colors.black),
                                      floatingLabelBehavior: FloatingLabelBehavior.always,
                                      suffixIcon: PasswordObscurer(
                                        obscurePassword: _obscurePasswordConfirmation,
                                        onObscurePassword: () => setState(() => _obscurePasswordConfirmation = !_obscurePasswordConfirmation),
                                      )
                                    ),
                                    obscureText: _obscurePasswordConfirmation,
                                    onChanged: (value) => passwordCompoundValidator.validate(),
                                    textInputAction: TextInputAction.done,
                                    onEditingComplete: widget.resetPasswordController.resetPassword,
                                  ),
                                  validator: passwordCompoundValidator.passwordConfirmationValidator,
                                )
                              ),
                              SizedBox(height: 3.h),
                              SizedOutlineGradientButton(
                                width: double.infinity,
                                onPressed: widget.resetPasswordController.resetPassword,
                                text: "Submit".tr,
                              ),
                            ],
                          ),
                        );
                      },
                      onFailedLoadDataResultWidget: (_, __, ___) => const SizedBox()
                    )
                  );
                } else {
                  return const SizedBox();
                }
              }
            )
          )
        )
      ),
    );
  }

  void _onCompleted(String value) {
    if (_resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
      widget.resetPasswordController.submitWhatsappPhoneNumberOtp();
    }
  }

  @override
  void dispose() {
    _resendVerificationCountdownTimer?.cancel();
    _verificationOtpFocusNode.dispose();
    _passwordTextEditingController.dispose();
    _passwordConfirmationTextEditingController.dispose();
    super.dispose();
  }
}

class ResetPasswordPageParameter {
  String code;
  ResetPasswordPageParameterType resetPasswordPageParameterType;

  ResetPasswordPageParameter({
    required this.code,
    required this.resetPasswordPageParameterType
  });
}

abstract class ResetPasswordPageParameterType {}

class EmailResetPasswordPageParameterType extends ResetPasswordPageParameterType {}

class WhatsappPhoneNumberResetPasswordPageParameterType extends ResetPasswordPageParameterType {
  String phoneNumber;

  WhatsappPhoneNumberResetPasswordPageParameterType({
    required this.phoneNumber
  });
}

extension ResetPasswordPageParameterExt on ResetPasswordPageParameter {
  String toJsonString() => StringUtil.encodeJson(
    () {
      return <String, dynamic>{
        "code": code,
        "type": () {
          if (resetPasswordPageParameterType is EmailResetPasswordPageParameterType) {
            return "email";
          } else if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) {
            return "whatsapp-phone-number";
          } else {
            throw MessageError(title: "Reset page parameter type is not suitable");
          }
        }(),
        if (resetPasswordPageParameterType is WhatsappPhoneNumberResetPasswordPageParameterType) ...{
          "value": (resetPasswordPageParameterType as WhatsappPhoneNumberResetPasswordPageParameterType).phoneNumber
        }
      };
    }()
  );
}

extension ResetPasswordPageParameterStringExt on String {
  ResetPasswordPageParameter toResetPasswordPageParameter() {
    Map<String, dynamic> result = StringUtil.decodeJson(this);
    String? type = result["type"];
    String code = result["code"];
    late ResetPasswordPageParameterType resetPasswordPageParameterType;
    if (type == "email") {
      resetPasswordPageParameterType = EmailResetPasswordPageParameterType();
    } else if (type == "whatsapp-phone-number") {
      resetPasswordPageParameterType = WhatsappPhoneNumberResetPasswordPageParameterType(
        phoneNumber: result["value"] as String
      );
    } else {
      throw MessageError(title: "Reset page parameter type is not suitable");
    }
    return ResetPasswordPageParameter(
      code: code,
      resetPasswordPageParameterType: resetPasswordPageParameterType
    );
  }
}