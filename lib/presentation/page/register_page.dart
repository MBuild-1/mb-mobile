import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../controller/login_controller.dart';
import '../../controller/register_controller.dart';
import '../../domain/entity/register/register_first_step_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/email_send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/wa_send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/email_send_register_otp_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/wa_send_register_otp_response.dart';
import '../../domain/entity/register/verify_register_parameter.dart';
import '../../domain/usecase/get_country_list_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../domain/usecase/register_first_step_use_case.dart';
import '../../domain/usecase/register_second_step_use_case.dart';
import '../../domain/usecase/register_use_case.dart';
import '../../domain/usecase/register_with_google_use_case.dart';
import '../../domain/usecase/send_register_otp_use_case.dart';
import '../../domain/usecase/verify_register_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/inputdecoration/default_input_decoration.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/navigation_helper.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/recognizer/sign_up_recognizer.dart';
import '../../misc/registerstep/first_register_step.dart';
import '../../misc/registerstep/register_step.dart';
import '../../misc/registerstep/register_step_wrapper.dart';
import '../../misc/registerstep/second_register_step.dart';
import '../../misc/registerstep/send_register_otp_register_step.dart';
import '../../misc/registerstep/verify_register_step.dart';
import '../../misc/string_util.dart';
import '../../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../../misc/validation/validator/validator.dart';
import '../../misc/web_helper.dart';
import '../../misc/widget_helper.dart';
import '../notifier/login_notifier.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/field.dart';
import '../widget/modified_shimmer.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modified_text_field.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/normal_text_style_for_appbar.dart';
import '../widget/password_obscurer.dart';
import '../widget/rx_consumer.dart';
import '../widget/something_counter.dart';
import '../widget/tap_area.dart';
import 'getx_page.dart';
import 'web_viewer_page.dart';

class RegisterPage extends RestorableGetxPage<_RegisterPageRestoration> {
  late final ControllerMember<RegisterController> _registerController = ControllerMember<RegisterController>().addToControllerManager(controllerManager);

  RegisterPage({Key? key}) : super(key: key, pageRestorationId: () => "register-page");

  @override
  void onSetController() {
    _registerController.controller = GetExtended.put<RegisterController>(
      RegisterController(
        controllerManager,
        Injector.locator<RegisterUseCase>(),
        Injector.locator<RegisterWithGoogleUseCase>(),
        Injector.locator<RegisterFirstStepUseCase>(),
        Injector.locator<SendRegisterOtpUseCase>(),
        Injector.locator<VerifyRegisterUseCase>(),
        Injector.locator<RegisterSecondStepUseCase>(),
        Injector.locator<GetCountryListUseCase>(),
        Injector.locator<GetUserUseCase>()
      ), tag: pageName
    );
  }

  @override
  _RegisterPageRestoration createPageRestoration() => _RegisterPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulRegisterControllerMediatorWidget(
        registerController: _registerController.controller,
      ),
    );
  }
}

class _RegisterPageRestoration extends ExtendedMixableGetxPageRestoration with WebViewerPageRestorationMixin {
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

class RegisterPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => RegisterPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(RegisterPage()));
}

mixin RegisterPageRestorationMixin on MixableGetxPageRestoration {
  late RegisterPageRestorableRouteFuture registerPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    registerPageRestorableRouteFuture = RegisterPageRestorableRouteFuture(restorationId: restorationIdWithPageName('register-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    registerPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    registerPageRestorableRouteFuture.dispose();
  }
}

class RegisterPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  RegisterPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        if (arguments is String) {
          if (arguments == Constant.restorableRouteFuturePushAndRemoveUntil) {
            return navigator.restorablePushAndRemoveUntil(_pageRouteBuilder, (route) => false, arguments: arguments);
          } else {
            return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
          }
        } else {
          return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
        }
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(RegisterPageGetPageBuilderAssistant())
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

class _StatefulRegisterControllerMediatorWidget extends StatefulWidget {
  final RegisterController registerController;

  const _StatefulRegisterControllerMediatorWidget({
    required this.registerController
  });

  @override
  State<_StatefulRegisterControllerMediatorWidget> createState() => _StatefulRegisterControllerMediatorWidgetState();
}

class _StatefulRegisterControllerMediatorWidgetState extends State<_StatefulRegisterControllerMediatorWidget> {
  late LoginNotifier _loginNotifier;
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _nameTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TextEditingController _passwordConfirmationTextEditingController = TextEditingController();
  final TapGestureRecognizer _termAndConditionsTapGestureRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _privacyPolicyTapGestureRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _resendVerificationTapGestureRecognizer = TapGestureRecognizer();
  final FocusNode _verificationOtpFocusNode = FocusNode();
  final TextEditingController _verificationOtpTextEditingController = TextEditingController();
  late final GoogleSignIn _googleSignIn;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;
  final int _maxCountdownTimerValue = 120;
  int _countdownTimerValue = 0;
  Timer? _resendVerificationCountdownTimer;

  @override
  void initState() {
    super.initState();
    _loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.registerController.setRegisterDelegate(
      RegisterDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetEmailOrPhoneNumberRegisterInput: () => _emailTextEditingController.text,
        onGetNameRegisterInput: () => _nameTextEditingController.text,
        onGetPasswordRegisterInput: () => _passwordTextEditingController.text,
        onGetPasswordConfirmationRegisterInput: () => _passwordConfirmationTextEditingController.text,
        onRegisterBack: () => Get.back(),
        onShowRegisterRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowRegisterRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onRegisterRequestProcessSuccessCallback: () async {
          _loginNotifier.loadProfile();
          Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
          for (var element in routeMap.entries) {
            element.value?.requestLoginChangeValue = 1;
          }
          NavigationHelper.navigationAfterRegisterProcess(context);
        },
        onShowRegisterFirstStepRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowRegisterFirstStepRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onRegisterFirstStepRequestProcessSuccessCallback: (registerFirstStepResponse) async {
          // Nothing
        },
        onShowSendRegisterOtpRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowSendRegisterOtpRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onSendRegisterOtpRequestProcessSuccessCallback: (sendRegisterOtpResponse) async {
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
        },
        onShowVerifyRegisterRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowVerifyRegisterRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onVerifyRegisterRequestProcessSuccessCallback: (verifyRegisterRequestResponse) async {
          // Reset reset verification countdown timer to default
          if (_resendVerificationCountdownTimer != null) {
            _resendVerificationCountdownTimer!.cancel();
          }
          _countdownTimerValue = _maxCountdownTimerValue;
        },
        onRegisterWithGoogle: () async {
          GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
          if (googleSignInAccount == null) {
            return null;
          }
          GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
          return googleSignInAuthentication.idToken;
        },
        onLoginIntoOneSignal: (externalId) async {
          try {
            await OneSignal.login(externalId);
            return SuccessLoadDataResult<String>(
              value: externalId
            );
          } catch (e, stackTrace) {
            return FailedLoadDataResult<String>(
              e: e,
              stackTrace: stackTrace
            );
          }
        },
        onSaveToken: (token) => LoginHelper.saveToken(token).future(),
        onGetPushNotificationSubscriptionId: () => OneSignal.User.pushSubscription.id.toEmptyStringNonNull,
        onSubscribeChatCountRealtimeChannel: (userId) async => await SomethingCounter.of(context)?.subscribeChatCount(userId),
        onSubscribeNotificationCountRealtimeChannel: (userId) async => await SomethingCounter.of(context)?.subscribeNotificationCount(userId),
      )
    );
    return WillPopScope(
      onWillPop: () async {
        var registerStepWrapper = widget.registerController.registerStepWrapperRx.value;
        RegisterStep registerStep = registerStepWrapper.registerStep;
        if (registerStep.stepNumber > 1) {
          DialogHelper.showPromptCancelRegister(context, () => Get.back());
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Register".tr),
              Expanded(
                child: title ?? Container()
              ),
              NormalTextStyleForAppBar(
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text("Login".tr),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return false;
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 30.h,
                    child: FittedBox(
                      child: Image.asset(Constant.imageLogin),
                    )
                  ),
                  SizedBox(height: 3.h),
                  RxConsumer<RegisterStepWrapper>(
                    rxValue: widget.registerController.registerStepWrapperRx,
                    onConsumeValue: (context, value) {
                      RegisterStep registerStep = value.registerStep;
                      if (registerStep is FirstRegisterStep) {
                        return Builder(
                          builder: (context) {
                            LoadDataResult<List<String>> countryCodeListLoadDataResult = registerStep.countryCodeListLoadDataResult;
                            bool isLoading = !countryCodeListLoadDataResult.isSuccess;
                            Widget result = Column(
                              children: [
                                if (!isLoading) ...[
                                  RxConsumer<Validator>(
                                    rxValue: widget.registerController.emailOrPhoneNumberValidatorRx,
                                    onConsumeValue: (context, value) => Field(
                                      child: (context, validationResult, validator) => ModifiedTextField(
                                        isError: validationResult.isFailed,
                                        controller: _emailTextEditingController,
                                        decoration: DefaultInputDecoration(
                                          label: Text("Email Or Phone Number".tr),
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
                                  ),
                                ] else ...[
                                  Container(
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: Constant.inputBorderRadius
                                    ),
                                  )
                                ],
                                SizedBox(height: 3.h),
                                SizedOutlineGradientButton(
                                  width: double.infinity,
                                  onPressed: widget.registerController.registerFirstStep,
                                  text: "Register".tr,
                                ),
                              ]
                            );
                            return isLoading ? ModifiedShimmer.fromColors(child: result) : result;
                          }
                        );
                      } else if (registerStep is SendRegisterOtpRegisterStep) {
                        RegisterFirstStepResponse registerFirstStepResponse = registerStep.registerFirstStepResponse;
                        return Column(
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
                            if (registerFirstStepResponse.emailActive) ...[
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
                                description: Text(registerFirstStepResponse.credential),
                                onTap: () => widget.registerController.sendRegisterOtp(
                                  EmailSendRegisterOtpParameter(
                                    credential: registerFirstStepResponse.credential
                                  )
                                )
                              )
                            ] else if (registerFirstStepResponse.phoneActive) ...[
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
                                description: Text(registerFirstStepResponse.credential),
                                onTap: () => widget.registerController.sendRegisterOtp(
                                  WaSendRegisterOtpParameter(
                                    credential: registerFirstStepResponse.credential
                                  )
                                )
                              )
                            ],
                          ]
                        );
                      } else if (registerStep is VerifyRegisterStep) {
                        SendRegisterOtpResponse sendRegisterOtpResponse = registerStep.sendRegisterOtpResponse;
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
                                if (sendRegisterOtpResponse is EmailSendRegisterOtpResponse) {
                                  return icon(
                                    const Icon(
                                      Icons.mail_outline,
                                      size: 36.0,
                                    ),
                                  );
                                } else if (sendRegisterOtpResponse is WaSendRegisterOtpResponse) {
                                  return icon(
                                    ModifiedSvgPicture.asset(
                                      Constant.vectorWhatsappLogo,
                                      width: 36.0
                                    )
                                  );
                                } else {
                                  return Container();
                                }
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
                                late String type;
                                if (sendRegisterOtpResponse is EmailSendRegisterOtpResponse) {
                                  type = "e-mail";
                                } else if (sendRegisterOtpResponse is WaSendRegisterOtpResponse) {
                                  type = "WhatsApp";
                                } else {
                                  type = MultiLanguageString({
                                    Constant.textInIdLanguageKey: "(Tidak Diketahui)",
                                    Constant.textEnUsLanguageKey: "(Unknown)"
                                  }).toEmptyStringNonNull;
                                }
                                return Text(
                                  MultiLanguageString({
                                    Constant.textInIdLanguageKey: "Kode verifikasi telah dikirim melalui $type ke ${sendRegisterOtpResponse.credential}",
                                    Constant.textEnUsLanguageKey: "A verification code has been sent via $type to ${sendRegisterOtpResponse.credential}"
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
                                _resendVerificationTapGestureRecognizer.onTap = widget.registerController.resendRegisterOtp;
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
                      } else if (registerStep is SecondRegisterStep) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RxConsumer<Validator>(
                              rxValue: widget.registerController.nameValidatorRx,
                              onConsumeValue: (context, value) => Field(
                                child: (context, validationResult, validator) => ModifiedTextField(
                                  isError: validationResult.isFailed,
                                  controller: _nameTextEditingController,
                                  decoration: DefaultInputDecoration(
                                    label: Text("Name".tr),
                                    labelStyle: const TextStyle(color: Colors.black),
                                    floatingLabelStyle: const TextStyle(color: Colors.black),
                                    floatingLabelBehavior: FloatingLabelBehavior.always,
                                  ),
                                  onChanged: (value) => validator?.validate(),
                                  textInputAction: TextInputAction.next,
                                ),
                                validator: value,
                              ),
                            ),
                            SizedBox(height: 3.h),
                            RxConsumer<PasswordCompoundValidator>(
                              rxValue: widget.registerController.passwordCompoundValidatorRx,
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
                              rxValue: widget.registerController.passwordCompoundValidatorRx,
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
                                  onEditingComplete: widget.registerController.register,
                                ),
                                validator: passwordCompoundValidator.passwordConfirmationValidator,
                              )
                            ),
                            SizedBox(height: 3.h),
                            SizedOutlineGradientButton(
                              width: double.infinity,
                              onPressed: widget.registerController.registerSecondStep,
                              text: "Register".tr,
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    }
                  ),
                  if (Platform.isAndroid) ...[
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider()
                        ),
                        SizedBox(width: 6.w),
                        Text("or register with".tr, style: TextStyle(
                          color: Theme.of(context).dividerTheme.color
                        )),
                        SizedBox(width: 6.w),
                        const Expanded(
                          child: Divider()
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    SizedOutlineGradientButton(
                      width: double.infinity,
                      outlineGradientButtonType: OutlineGradientButtonType.outline,
                      onPressed: widget.registerController.registerWithGoogle,
                      text: "Register With Google".tr,
                    ),
                  ],
                  SizedBox(height: 2.h),
                  Builder(
                    builder: (context) {
                      _termAndConditionsTapGestureRecognizer.onTap = () {
                        WebHelper.launchUrl(Uri.parse(Constant.textTermAndConditionsUrl));
                      };
                      _privacyPolicyTapGestureRecognizer.onTap = () {
                        WebHelper.launchUrl(Uri.parse(Constant.textPrivacyPolicyUrl));
                      };
                      return Text.rich(
                        "By signing up".trTextSpan(
                          parameter: SignUpRecognizer(
                            termAndConditionsTapGestureRecognizer: _termAndConditionsTapGestureRecognizer,
                            privacyPolicyTapGestureRecognizer: _privacyPolicyTapGestureRecognizer
                          ),
                        ),
                        textAlign: TextAlign.center,
                      );
                    }
                  )
                ],
              ),
            ),
          )
        )
      ),
    );
  }

  void _onCompleted(String value) {
    RegisterStepWrapper registerStepWrapper = widget.registerController.registerStepWrapperRx.value;
    RegisterStep registerStep = registerStepWrapper.registerStep;
    if (registerStep is VerifyRegisterStep) {
      SendRegisterOtpResponse sendRegisterOtpResponse = registerStep.sendRegisterOtpResponse;
      widget.registerController.verifyRegister(
        VerifyRegisterParameter(
          credential: sendRegisterOtpResponse.credential,
          otp: value
        )
      );
    }
  }

  @override
  void dispose() {
    _resendVerificationCountdownTimer?.cancel();
    _emailTextEditingController.dispose();
    _nameTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _passwordConfirmationTextEditingController.dispose();
    _termAndConditionsTapGestureRecognizer.dispose();
    _privacyPolicyTapGestureRecognizer.dispose();
    _verificationOtpTextEditingController.dispose();
    _verificationOtpFocusNode.dispose();
    super.dispose();
  }
}