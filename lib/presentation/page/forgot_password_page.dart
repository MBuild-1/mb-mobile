import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../controller/forgot_password_controller.dart';
import '../../domain/usecase/forgot_password_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/inputdecoration/default_input_decoration.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/toast_helper.dart';
import '../../misc/validation/validator/validator.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/field.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modified_text_field.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/rx_consumer.dart';
import 'getx_page.dart';

class ForgotPasswordPage extends RestorableGetxPage<_ForgotPasswordPageRestoration> {
  late final ControllerMember<ForgotPasswordController> _forgotPasswordPageController = ControllerMember<ForgotPasswordController>().addToControllerManager(controllerManager);

  ForgotPasswordPage({Key? key}) : super(key: key, pageRestorationId: () => "forgot-password-page");

  @override
  void onSetController() {
    _forgotPasswordPageController.controller = GetExtended.put<ForgotPasswordController>(
      ForgotPasswordController(
        controllerManager,
        Injector.locator<ForgotPasswordUseCase>(),
      ),
      tag: pageName
    );
  }

  @override
  _ForgotPasswordPageRestoration createPageRestoration() => _ForgotPasswordPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulForgotPasswordControllerMediatorWidget(
      forgotPasswordController: _forgotPasswordPageController.controller,
    );
  }
}

class _ForgotPasswordPageRestoration extends ExtendedMixableGetxPageRestoration {
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

class ForgotPasswordPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => ForgotPasswordPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ForgotPasswordPage()));
}

mixin ForgotPasswordPageRestorationMixin on MixableGetxPageRestoration {
  late ForgotPasswordPageRestorableRouteFuture forgotPasswordPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    forgotPasswordPageRestorableRouteFuture = ForgotPasswordPageRestorableRouteFuture(restorationId: restorationIdWithPageName('forgot-password-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    forgotPasswordPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    forgotPasswordPageRestorableRouteFuture.dispose();
  }
}

class ForgotPasswordPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ForgotPasswordPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ForgotPasswordPageGetPageBuilderAssistant()),
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

class _StatefulForgotPasswordControllerMediatorWidget extends StatefulWidget {
  final ForgotPasswordController forgotPasswordController;

  const _StatefulForgotPasswordControllerMediatorWidget({
    required this.forgotPasswordController
  });

  @override
  State<_StatefulForgotPasswordControllerMediatorWidget> createState() => _StatefulForgotPasswordControllerMediatorWidgetState();
}

class _StatefulForgotPasswordControllerMediatorWidgetState extends State<_StatefulForgotPasswordControllerMediatorWidget> {
  final TextEditingController _emailTextEditingController = TextEditingController();
  dynamic _failedLoginError;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.forgotPasswordController.setForgotPasswordDelegate(
      ForgotPasswordDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetEmailForgotPasswordInput: () => _emailTextEditingController.text.trim(),
        onLoginBack: () => Get.back(),
        onShowForgotPasswordRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowForgotPasswordRequestProcessFailedCallback: (e) async {
          setState(() => _failedLoginError = e);
        },
        onForgotPasswordRequestProcessSuccessCallback: () async {
          Get.back();
          ToastHelper.showToast("${"Please check your email for next step".tr}.");
        },
      )
    );
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Forgot Password".tr),
            Expanded(
              child: title ?? Container()
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
                  rxValue: widget.forgotPasswordController.emailValidatorRx,
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
                SizedOutlineGradientButton(
                  width: double.infinity,
                  onPressed: widget.forgotPasswordController.forgotPassword,
                  text: "Submit".tr,
                ),
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
    super.dispose();
  }
}