import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/page_restoration_helper.dart';
import 'package:sizer/sizer.dart';

import '../../../../controller/chathistorycontroller/chathistorysubpagecontroller/help_chat_history_sub_controller.dart';
import '../../../../controller/help_chat_controller.dart';
import '../../../../domain/usecase/answer_help_conversation_use_case.dart';
import '../../../../domain/usecase/answer_help_conversation_version_1_point_1_use_case.dart';
import '../../../../domain/usecase/create_help_conversation_use_case.dart';
import '../../../../domain/usecase/get_help_message_by_user_use_case.dart';
import '../../../../domain/usecase/get_user_use_case.dart';
import '../../../../misc/constant.dart';
import '../../../../misc/dialog_helper.dart';
import '../../../../misc/getextended/get_extended.dart';
import '../../../../misc/injector.dart';
import '../../../../misc/manager/controller_manager.dart';
import '../../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../../widget/modified_svg_picture.dart';
import '../../getx_page.dart';
import '../../help_chat_page.dart';

class HelpChatHistorySubPage extends DefaultGetxPage {
  late final ControllerMember<HelpChatController> _helpChatController;
  final String ancestorPageName;
  final ControllerMember<HelpChatController> Function() onAddControllerMember;
  final void Function(FocusNode) onGetTextFocusNode;

  HelpChatHistorySubPage({
    Key? key,
    required this.ancestorPageName,
    required this.onAddControllerMember,
    required this.onGetTextFocusNode
  }) : super(key: key) {
    _helpChatController = onAddControllerMember();
  }

  @override
  void onSetController() {
    _helpChatController.controller = GetExtended.put<HelpChatController>(
      HelpChatController(
        controllerManager,
        Injector.locator<GetHelpMessageByUserUseCase>(),
        Injector.locator<CreateHelpConversationUseCase>(),
        Injector.locator<AnswerHelpConversationUseCase>(),
        Injector.locator<AnswerHelpConversationVersion1Point1UseCase>(),
        Injector.locator<GetUserUseCase>()
      ),
      tag: ancestorPageName
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulHelpChatHistorySubControllerMediatorWidget(
      helpChatController: _helpChatController.controller,
      onGetTextFocusNode: onGetTextFocusNode
    );
  }
}

class _StatefulHelpChatHistorySubControllerMediatorWidget extends StatefulWidget {
  final HelpChatController helpChatController;
  final void Function(FocusNode)? onGetTextFocusNode;

  const _StatefulHelpChatHistorySubControllerMediatorWidget({
    required this.helpChatController,
    this.onGetTextFocusNode
  });

  @override
  State<_StatefulHelpChatHistorySubControllerMediatorWidget> createState() => _StatefulHelpChatHistorySubControllerMediatorWidgetState();
}

class _StatefulHelpChatHistorySubControllerMediatorWidgetState extends State<_StatefulHelpChatHistorySubControllerMediatorWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulHelpChatControllerMediatorWidget(
      helpChatController: widget.helpChatController,
      withAppBar: false,
      onGetTextFocusNode: widget.onGetTextFocusNode
    );
  }
}