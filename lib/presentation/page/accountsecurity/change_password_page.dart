import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/error_provider_ext.dart';
import 'package:masterbagasi/misc/ext/validation_result_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../controller/accountsecuritycontroller/change_password_controller.dart';
import '../../../domain/usecase/change_password_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/injector.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../../misc/toast_helper.dart';
import '../../../misc/validation/validator/compoundvalidator/password_compound_validator.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/field.dart';
import '../../widget/modified_text_field.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../../widget/password_obscurer.dart';
import '../../widget/rx_consumer.dart';
import '../getx_page.dart';

class ChangePasswordPage extends RestorableGetxPage<_ChangePasswordPageRestoration> {
  late final ControllerMember<ChangePasswordController> _changePasswordController = ControllerMember<ChangePasswordController>().addToControllerManager(controllerManager);

  ChangePasswordPage({Key? key}) : super(key: key, pageRestorationId: () => "change-password-page");

  @override
  void onSetController() {
    _changePasswordController.controller = GetExtended.put<ChangePasswordController>(
      ChangePasswordController(
        controllerManager,
        Injector.locator<ChangePasswordUseCase>()
      ), tag: pageName
    );
  }

  @override
  _ChangePasswordPageRestoration createPageRestoration() => _ChangePasswordPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulChangePasswordControllerMediatorWidget(
        changePasswordController: _changePasswordController.controller,
      ),
    );
  }
}

class _ChangePasswordPageRestoration extends MixableGetxPageRestoration {
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

class ChangePasswordPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => ChangePasswordPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ChangePasswordPage()));
}

mixin ChangePasswordPageRestorationMixin on MixableGetxPageRestoration {
  late ChangePasswordPageRestorableRouteFuture changePasswordPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    changePasswordPageRestorableRouteFuture = ChangePasswordPageRestorableRouteFuture(restorationId: restorationIdWithPageName('change-password-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    changePasswordPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    changePasswordPageRestorableRouteFuture.dispose();
  }
}

class ChangePasswordPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ChangePasswordPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ChangePasswordPageGetPageBuilderAssistant())
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

class _StatefulChangePasswordControllerMediatorWidget extends StatefulWidget {
  final ChangePasswordController changePasswordController;

  const _StatefulChangePasswordControllerMediatorWidget({
    required this.changePasswordController
  });

  @override
  State<_StatefulChangePasswordControllerMediatorWidget> createState() => _StatefulChangePasswordControllerMediatorWidgetState();
}

class _StatefulChangePasswordControllerMediatorWidgetState extends State<_StatefulChangePasswordControllerMediatorWidget> {
  final TextEditingController _newPasswordTextEditingController = TextEditingController();
  final TextEditingController _confirmNewPasswordTextEditingController = TextEditingController();
  dynamic _failedLoginError;
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.changePasswordController.setChangePasswordDelegate(
      ChangePasswordDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetNewPasswordInput: () => _newPasswordTextEditingController.text,
        onGetConfirmNewPasswordInput: () => _confirmNewPasswordTextEditingController.text,
        onChangePasswordBack: () => Get.back(),
        onShowChangePasswordRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowChangePasswordRequestProcessFailedCallback: (e) async {
          setState(() => _failedLoginError = e);
        },
        onChangePasswordRequestProcessSuccessCallback: () async {
          Get.back();
          ToastHelper.showToast("${"Success change password".tr}.");
        }
      )
    );
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Change Password".tr),
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
                RxConsumer<PasswordCompoundValidator>(
                  rxValue: widget.changePasswordController.passwordCompoundValidatorRx,
                  onConsumeValue: (context, passwordCompoundValidator) => Field(
                    child: (context, validationResult, validator) => ModifiedTextField(
                      isError: validationResult.isFailed,
                      controller: _newPasswordTextEditingController,
                      decoration: DefaultInputDecoration(
                        label: Text("New Password".tr),
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
                  rxValue: widget.changePasswordController.passwordCompoundValidatorRx,
                  onConsumeValue: (context, passwordCompoundValidator) => Field(
                    child: (context, validationResult, validator) => ModifiedTextField(
                      isError: validationResult.isFailed,
                      controller: _confirmNewPasswordTextEditingController,
                      decoration: DefaultInputDecoration(
                        label: Text("New Password Confirmation".tr),
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
                      onEditingComplete: widget.changePasswordController.changePassword,
                    ),
                    validator: passwordCompoundValidator.passwordConfirmationValidator,
                  )
                ),
                SizedBox(height: 3.h),
                SizedOutlineGradientButton(
                  width: double.infinity,
                  onPressed: widget.changePasswordController.changePassword,
                  text: "Change Password".tr,
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
    _newPasswordTextEditingController.dispose();
    _confirmNewPasswordTextEditingController.dispose();
    super.dispose();
  }
}