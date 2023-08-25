import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/page_restoration_helper.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/chathistorycontroller/chathistorysubpagecontroller/help_chat_history_sub_controller.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/dialog_helper.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../../widget/modified_svg_picture.dart';
import '../../getx_page.dart';

class HelpChatHistorySubPage extends DefaultGetxPage {
  late final ControllerMember<HelpChatHistorySubController> _helpChatHistorySubController;
  final String ancestorPageName;
  final ControllerMember<HelpChatHistorySubController> Function() onAddControllerMember;

  HelpChatHistorySubPage({
    Key? key,
    required this.ancestorPageName,
    required this.onAddControllerMember
  }) : super(key: key) {
    _helpChatHistorySubController = onAddControllerMember();
  }

  @override
  void onSetController() {
    _helpChatHistorySubController.controller = Injector.locator<HelpChatHistorySubControllerInjectionFactory>().inject(controllerManager, ancestorPageName);
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulHelpChatHistorySubControllerMediatorWidget(
      helpChatHistorySubController: _helpChatHistorySubController.controller
    );
  }
}

class _StatefulHelpChatHistorySubControllerMediatorWidget extends StatefulWidget {
  final HelpChatHistorySubController helpChatHistorySubController;

  const _StatefulHelpChatHistorySubControllerMediatorWidget({
    required this.helpChatHistorySubController
  });

  @override
  State<_StatefulHelpChatHistorySubControllerMediatorWidget> createState() => _StatefulHelpChatHistorySubControllerMediatorWidgetState();
}

class _StatefulHelpChatHistorySubControllerMediatorWidgetState extends State<_StatefulHelpChatHistorySubControllerMediatorWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 30.h,
                  child: ClipOval(
                    child: ModifiedSvgPicture.asset(
                      Constant.vectorDirectChat,
                      overrideDefaultColorWithSingleColor: false
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: SizedOutlineGradientButton(
                    onPressed: () => PageRestorationHelper.toHelpChatPage(context),
                    text: "Support Message".tr,
                    outlineGradientButtonType: OutlineGradientButtonType.solid,
                    outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                  ),
                ),
              ]
            )
          ),
        )
      ]
    );
  }
}