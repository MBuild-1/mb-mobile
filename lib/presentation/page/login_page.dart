import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:masterbagasi/misc/temp_login_data_while_input_pin_helper.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../controller/login_controller.dart';
import '../../domain/entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../../domain/usecase/login_use_case.dart';
import '../../domain/usecase/login_with_google_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/inputdecoration/default_input_decoration.dart';
import '../../misc/load_data_result.dart';
import '../../misc/login_helper.dart';
import '../../misc/main_route_observer.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/routeargument/login_route_argument.dart';
import '../../misc/validation/validator/validator.dart';
import '../notifier/login_notifier.dart';
import '../notifier/notification_notifier.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/field.dart';
import '../widget/modified_text_field.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/normal_text_style_for_appbar.dart';
import '../widget/password_obscurer.dart';
import '../widget/rx_consumer.dart';
import 'accountsecurity/modify_pin_page.dart';
import 'forgot_password_page.dart';
import 'getx_page.dart';
import 'register_page.dart';

class LoginPage extends RestorableGetxPage<_LoginPageRestoration> {
  late final ControllerMember<LoginController> _loginController = ControllerMember<LoginController>().addToControllerManager(controllerManager);

  final _StatefulLoginControllerMediatorWidgetDelegate _statefulLoginControllerMediatorWidgetDelegate = _StatefulLoginControllerMediatorWidgetDelegate();

  LoginPage({Key? key}) : super(key: key, pageRestorationId: () => "login-page");

  @override
  void onSetController() {
    _loginController.controller = GetExtended.put<LoginController>(
      LoginController(
        controllerManager,
        Injector.locator<LoginUseCase>(),
        Injector.locator<LoginWithGoogleUseCase>()
      ), tag: pageName
    );
  }

  @override
  _LoginPageRestoration createPageRestoration() => _LoginPageRestoration(
    onCompleteInputPin: (result) {
      if (result != null) {
        if (result) {
          if (_statefulLoginControllerMediatorWidgetDelegate.onLoginProcess != null) {
            _statefulLoginControllerMediatorWidgetDelegate.onLoginProcess!();
          }
        }
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulLoginControllerMediatorWidget(
        loginController: _loginController.controller,
        statefulLoginControllerMediatorWidgetDelegate: _statefulLoginControllerMediatorWidgetDelegate
      ),
    );
  }
}

class _LoginPageRestoration extends MixableGetxPageRestoration with RegisterPageRestorationMixin, ForgotPasswordPageRestorationMixin, ModifyPinPageRestorationMixin {
  final RouteCompletionCallback<bool?>? _onCompleteInputPin;

  _LoginPageRestoration({
    RouteCompletionCallback<bool?>? onCompleteInputPin
  }) : _onCompleteInputPin = onCompleteInputPin;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteInputPin = _onCompleteInputPin;
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

class LoginPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => LoginPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(LoginPage()));
}

mixin LoginPageRestorationMixin on MixableGetxPageRestoration {
  late LoginPageRestorableRouteFuture loginPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    loginPageRestorableRouteFuture = LoginPageRestorableRouteFuture(restorationId: restorationIdWithPageName('login-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    loginPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    loginPageRestorableRouteFuture.dispose();
  }
}

class LoginPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  LoginPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
      GetxPageBuilder.buildRestorableGetxPageBuilder(LoginPageGetPageBuilderAssistant()),
      arguments: LoginRouteArgument(),
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

class _StatefulLoginControllerMediatorWidgetDelegate {
  Future<void> Function()? onLoginProcess;
}

class _StatefulLoginControllerMediatorWidget extends StatefulWidget {
  final LoginController loginController;
  final _StatefulLoginControllerMediatorWidgetDelegate statefulLoginControllerMediatorWidgetDelegate;

  const _StatefulLoginControllerMediatorWidget({
    required this.loginController,
    required this.statefulLoginControllerMediatorWidgetDelegate
  });

  @override
  State<_StatefulLoginControllerMediatorWidget> createState() => _StatefulLoginControllerMediatorWidgetState();
}

class _StatefulLoginControllerMediatorWidgetState extends State<_StatefulLoginControllerMediatorWidget> {
  late LoginNotifier _loginNotifier;
  late NotificationNotifier _notificationNotifier;
  final TextEditingController _emailTextEditingController = TextEditingController();
  final TextEditingController _passwordTextEditingController = TextEditingController();
  final TapGestureRecognizer _forgotPasswordTapGestureRecognizer = TapGestureRecognizer();
  final TapGestureRecognizer _signUpTapGestureRecognizer = TapGestureRecognizer();
  late final GoogleSignIn _googleSignIn;
  late Future<void> Function() _onLoginRequestProcessSuccessCallback;
  dynamic _failedLoginError;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _onLoginRequestProcessSuccessCallback = () async {
      _loginNotifier.loadProfile();
      _notificationNotifier.loadAllNotification();
      Map<String, RouteWrapper?> routeMap = MainRouteObserver.routeMap;
      for (var element in routeMap.entries) {
        element.value?.requestLoginChangeValue = 1;
      }
      Get.back();
    };
    _loginNotifier = Provider.of<LoginNotifier>(context, listen: false);
    _notificationNotifier = Provider.of<NotificationNotifier>(context, listen: false);
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    widget.statefulLoginControllerMediatorWidgetDelegate.onLoginProcess = () async {
      DialogHelper.showLoadingDialog(context);
      if (await widget.loginController.loginOneSignal()) {
        return;
      }
      await LoginHelper.saveToken(
        TempLoginDataWhileInputPinHelper.getTempLoginDataWhileInputPin().result
      ).future();
      Get.back();
      _onLoginRequestProcessSuccessCallback();
    };
  }

  @override
  Widget build(BuildContext context) {
    widget.loginController.setLoginDelegate(
      LoginDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetEmailLoginInput: () => _emailTextEditingController.text.trim(),
        onGetPasswordLoginInput: () => _passwordTextEditingController.text,
        onLoginBack: () => Get.back(),
        onShowLoginRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowLoginRequestProcessFailedCallback: (e) async {
          setState(() => _failedLoginError = e);
        },
        onLoginRequestProcessSuccessCallback: _onLoginRequestProcessSuccessCallback,
        onRequestPin: (requestPinParameter) {
          ModifyPinPageParameter modifyPinPageParameter = ModifyPinPageParameter(
            modifyPinType: ModifyPinType.validatePinWhileLogin
          );
          PageRestorationHelper.toModifyPinPage(context, modifyPinPageParameter);
        },
        onLoginWithGoogle: () async {
          GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
          if (googleSignInAccount == null) {
            return null;
          }
          GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
          return googleSignInAuthentication.idToken;
        },
        onSaveTempData: (data) async {
          await TempLoginDataWhileInputPinHelper.saveTempLoginDataWhileInputPin(data).future();
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
        onGetPushNotificationSubscriptionId: () => OneSignal.User.pushSubscription.id.toEmptyStringNonNull
      )
    );
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Login".tr),
            Expanded(
              child: title ?? Container()
            ),
            NormalTextStyleForAppBar(
              style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              child: GestureDetector(
                onTap: () => PageRestorationHelper.toRegisterPage(context),
                child: Text("Register".tr),
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
                if (_failedLoginError != null)
                  ...[
                    SizedBox(height: 3.h),
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
                  ],
                SizedBox(height: 3.h),
                RxConsumer<Validator>(
                  rxValue: widget.loginController.emailValidatorRx,
                  onConsumeValue: (context, value) => Field(
                    child: (context, validationResult, validator) => ModifiedTextField(
                      isError: validationResult.isFailed,
                      controller: _emailTextEditingController,
                      decoration: DefaultInputDecoration(
                        label: Text("Email".tr),
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
                RxConsumer<Validator>(
                  rxValue: widget.loginController.passwordValidatorRx,
                  onConsumeValue: (context, value) => Field(
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
                      onChanged: (value) => validator?.validate(),
                      textInputAction: TextInputAction.done,
                      onEditingComplete: widget.loginController.login,
                    ),
                    validator: value,
                  )
                ),
                SizedBox(height: 2.h),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Builder(
                      builder: (context) {
                        _forgotPasswordTapGestureRecognizer.onTap = () {
                          PageRestorationHelper.toForgotPasswordPage(context);
                        };
                        return Text.rich("Forgot Password".trTextSpan(parameter: _forgotPasswordTapGestureRecognizer));
                      }
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                SizedOutlineGradientButton(
                  width: double.infinity,
                  onPressed: widget.loginController.login,
                  text: "Login".tr,
                ),
                if (Platform.isAndroid) ...[
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider()
                      ),
                      SizedBox(width: 6.w),
                      Text("or login with".tr, style: TextStyle(
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
                    onPressed: widget.loginController.loginWithGoogle,
                    text: "Login With Google".tr,
                  ),
                ],
                SizedBox(height: 2.h),
                Builder(
                  builder: (context) {
                    _signUpTapGestureRecognizer.onTap = () {
                      PageRestorationHelper.toRegisterPage(context);
                    };
                    return Text.rich("New to MasterBagasi".trTextSpan(parameter: _signUpTapGestureRecognizer));
                  }
                )
              ],
            ),
          ),
        )
      )
    );
  }

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _forgotPasswordTapGestureRecognizer.dispose();
    _signUpTapGestureRecognizer.dispose();
    super.dispose();
  }
}