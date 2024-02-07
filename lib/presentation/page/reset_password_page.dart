import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../controller/reset_password_controller.dart';
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
import '../../misc/manager/controller_manager.dart';
import '../../misc/routeargument/reset_password_route_argument.dart';
import '../../misc/toast_helper.dart';
import '../../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../../misc/validation/validator/validator.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/field.dart';
import '../widget/loaddataresultimplementer/load_data_result_implementer.dart';
import '../widget/modified_scaffold.dart';
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
      resetPasswordPageParameter: resetPasswordPageParameter
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
          resetPasswordPageParameter: ResetPasswordPageParameter(
            code: resetPasswordPageParameter.code
          )
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

  const _StatefulResetPasswordControllerMediatorWidget({
    required this.resetPasswordController,
    required this.resetPasswordPageParameter
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.resetPasswordController.setResetPasswordDelegate(
      ResetPasswordDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetCode: () => widget.resetPasswordPageParameter.code,
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
          Get.back();
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
      )
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      widget.resetPasswordController.checkResetPassword();
    });
    return ModifiedScaffold(
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
        child: RxConsumer<LoadDataResultWrapper<CheckResetPasswordResponse>>(
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
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
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
                ),
              );
            },
            onFailedLoadDataResultWidget: (_, __, ___) => const SizedBox()
          )
        )
      )
    );
  }

  @override
  void dispose() {
    _passwordTextEditingController.dispose();
    _passwordConfirmationTextEditingController.dispose();
    super.dispose();
  }
}