import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_dropdown_menu_list_item_controller_state.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/accountsecuritycontroller/personalverificationcontroller/personal_verification_controller.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../../../../misc/dialog_helper.dart';
import '../../../../misc/getextended/get_extended.dart';
import '../../../../misc/getextended/get_restorable_route_future.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../../misc/multi_language_string.dart';
import '../../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../../widget/check_list_item.dart';
import '../../../widget/modified_divider.dart';
import '../../../widget/modified_scaffold.dart';
import '../../../widget/modified_svg_picture.dart';
import '../../../widget/modifiedappbar/modified_app_bar.dart';
import '../../../widget/profile_menu_item.dart';
import '../../../widget/tap_area.dart';
import '../../getx_page.dart';
import '../../notification_redirector_page.dart';

class PersonalVerificationPage extends RestorableGetxPage<_PersonalVerificationPageRestoration> {
  late final ControllerMember<PersonalVerificationController> _personalVerificationController = ControllerMember<PersonalVerificationController>().addToControllerManager(controllerManager);

  PersonalVerificationPage({
    Key? key
  }) : super(key: key, pageRestorationId: () => "personal-verification-page");

  @override
  void onSetController() {
    _personalVerificationController.controller = GetExtended.put<PersonalVerificationController>(
      PersonalVerificationController(
        controllerManager
      ), tag: pageName
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulPersonalVerificationControllerMediatorWidget(
      personalVerificationController: _personalVerificationController.controller
    );
  }

  @override
  _PersonalVerificationPageRestoration createPageRestoration() => _PersonalVerificationPageRestoration();
}

class _PersonalVerificationPageRestoration extends ExtendedMixableGetxPageRestoration {
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

class PersonalVerificationPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => PersonalVerificationPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(PersonalVerificationPage()));
}

mixin PersonalVerificationPageRestorationMixin on ExtendedMixableGetxPageRestoration {
  late PersonalVerificationPageRestorableRouteFuture personalVerificationPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    personalVerificationPageRestorableRouteFuture = PersonalVerificationPageRestorableRouteFuture(restorationId: restorationIdWithPageName('personal-verification-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    personalVerificationPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    personalVerificationPageRestorableRouteFuture.dispose();
  }
}

class PersonalVerificationPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  PersonalVerificationPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(PersonalVerificationPageGetPageBuilderAssistant())
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

class _StatefulPersonalVerificationControllerMediatorWidget extends StatefulWidget {
  final PersonalVerificationController personalVerificationController;

  const _StatefulPersonalVerificationControllerMediatorWidget({
    required this.personalVerificationController
  });

  @override
  State<_StatefulPersonalVerificationControllerMediatorWidget> createState() => _StatefulPersonalVerificationControllerMediatorWidgetState();
}

class _StatefulPersonalVerificationControllerMediatorWidgetState extends State<_StatefulPersonalVerificationControllerMediatorWidget> {
  bool _agreeValue = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModifiedScaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Personal Data Verification".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 4.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 30.h,
                        child: FittedBox(
                          child: Image.asset(Constant.imagePersonalVerification),
                        )
                      ),
                      const SizedBox(height: 50),
                      Text(
                        MultiLanguageString({
                          Constant.textEnUsLanguageKey: "Let's Verify Your Data",
                          Constant.textInIdLanguageKey: "Verifikasi Datamu, yuk!"
                        }).toEmptyStringNonNull,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(height: 10),
                      Text(
                        MultiLanguageString({
                          Constant.textEnUsLanguageKey: "Upload a photo of your KTP and face so you can get these benefits:",
                          Constant.textInIdLanguageKey: "Upload foto KTP dan wajah biar dapat keuntungan ini:"
                        }).toEmptyStringNonNull,
                        textAlign: TextAlign.center,
                      ),
                    ]
                  ),
                ),
                const SizedBox(height: 10),
                ProfileMenuItem(
                  onTap: null,
                  icon: (BuildContext context) => Container(),
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Enjoy Complete Features for Shopping",
                    Constant.textInIdLanguageKey: "Nikmati Fitur Lengkap Buat Belanja"
                  }).toEmptyStringNonNull,
                  description: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Shopping becomes more comfortable & profitable.",
                    Constant.textInIdLanguageKey: "Belanja jadi makin nyaman & untung deh."
                  }).toEmptyStringNonNull
                ),
                const ModifiedDivider(),
                ProfileMenuItem(
                  onTap: null,
                  icon: (BuildContext context) => Container(),
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Enjoy Complete Features for Shopping",
                    Constant.textInIdLanguageKey: "Nikmati Fitur Lengkap Buat Belanja"
                  }).toEmptyStringNonNull,
                  description: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Shopping becomes more comfortable & profitable.",
                    Constant.textInIdLanguageKey: "Belanja jadi makin nyaman & untung deh."
                  }).toEmptyStringNonNull
                ),
                const ModifiedDivider(),
                ProfileMenuItem(
                  onTap: null,
                  icon: (BuildContext context) => Container(),
                  title: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Enjoy Complete Features for Shopping",
                    Constant.textInIdLanguageKey: "Nikmati Fitur Lengkap Buat Belanja"
                  }).toEmptyStringNonNull,
                  description: MultiLanguageString({
                    Constant.textEnUsLanguageKey: "Shopping becomes more comfortable & profitable.",
                    Constant.textInIdLanguageKey: "Belanja jadi makin nyaman & untung deh."
                  }).toEmptyStringNonNull
                ),
                const ModifiedDivider(),
                const SizedBox(height: 30),
                TapArea(
                  onTap: () => DialogHelper.showPromptUnderConstruction(context),
                  child: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "View Benefits Details",
                      Constant.textInIdLanguageKey: "Lihat Detail Keuntungan"
                    }).toEmptyStringNonNull,
                    style: TextStyle(
                      color: Constant.colorMain,
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 15),
                CheckListItem(
                  value: _agreeValue,
                  showCheck: true,
                  reverse: true,
                  title: Text(
                    MultiLanguageString({
                      Constant.textEnUsLanguageKey: "I agree to share KTP data & facial photos with the Master Bagasi according to the Terms & Conditions",
                      Constant.textInIdLanguageKey: "Saya setuju untuk bagikan data KTP & foto wajah ke Master Bagasi sesuai Syarat & Ketentuan"
                    }).toEmptyStringNonNull,
                  ),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _agreeValue = value);
                    }
                  }
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedOutlineGradientButton(
                    onPressed: () => DialogHelper.showPromptUnderConstruction(context),
                    text: MultiLanguageString({
                      Constant.textEnUsLanguageKey: "Begin Verification",
                      Constant.textInIdLanguageKey: "Mulai Verifikasi"
                    }).toEmptyStringNonNull,
                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                  ),
                ),
              ],
            )
          ),
        )
      ),
    );
  }
}