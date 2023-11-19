import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chathistorycontroller/chat_history_controller.dart';
import '../../../controller/chathistorycontroller/chathistorysubpagecontroller/help_chat_history_sub_controller.dart';
import '../../../controller/chathistorycontroller/chathistorysubpagecontroller/order_chat_history_sub_controller.dart';
import '../../../controller/chathistorycontroller/chathistorysubpagecontroller/product_chat_history_sub_controller.dart';
import '../../../controller/help_chat_controller.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/getextended/get_restorable_route_future.dart';
import '../../../misc/manager/controller_manager.dart';
import '../../widget/modified_tab_bar.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../getx_page.dart';
import '../help_chat_page.dart';
import '../order_chat_page.dart';
import '../product_chat_page.dart';
import 'chathistorysubpage/help_chat_history_sub_page.dart';
import 'chathistorysubpage/order_chat_history_sub_page.dart';
import 'chathistorysubpage/product_chat_history_sub_page.dart';

class ChatHistoryPage extends RestorableGetxPage<_ChatHistoryPageRestoration> {
  late final ControllerMember<ChatHistoryController> _chatHistoryController = ControllerMember<ChatHistoryController>().addToControllerManager(controllerManager);
  late final List<List<dynamic>> _chatHistorySubControllerList;

  ChatHistoryPage({Key? key}) : super(key: key, pageRestorationId: () => "chat-history-page") {
    _chatHistorySubControllerList = [
      [
        null,
        () => ControllerMember<HelpChatController>().addToControllerManager(controllerManager),
        null
      ],
      [
        null,
        () => ControllerMember<ProductChatHistorySubController>().addToControllerManager(controllerManager),
        null
      ],
      [
        null,
        () => ControllerMember<OrderChatHistorySubController>().addToControllerManager(controllerManager),
        null
      ],
    ];
    _chatHistorySubControllerList[0][2] = () {
      if (_chatHistorySubControllerList[0][0] == null) {
        _chatHistorySubControllerList[0][0] = _chatHistorySubControllerList[0][1]();
      }
      return _chatHistorySubControllerList[0][0];
    };
    _chatHistorySubControllerList[1][2] = () {
      if (_chatHistorySubControllerList[1][0] == null) {
        _chatHistorySubControllerList[1][0] = _chatHistorySubControllerList[1][1]();
      }
      return _chatHistorySubControllerList[1][0];
    };
    _chatHistorySubControllerList[2][2] = () {
      if (_chatHistorySubControllerList[2][0] == null) {
        _chatHistorySubControllerList[2][0] = _chatHistorySubControllerList[2][1]();
      }
      return _chatHistorySubControllerList[2][0];
    };
  }

  @override
  void onSetController() {
    _chatHistoryController.controller = GetExtended.put<ChatHistoryController>(
      ChatHistoryController(
        controllerManager,
      ),
      tag: pageName
    );
  }

  @override
  _ChatHistoryPageRestoration createPageRestoration() => _ChatHistoryPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulChatHistoryControllerMediatorWidget(
      chatHistoryController: _chatHistoryController.controller,
      chatHistorySubControllerList: _chatHistorySubControllerList,
      pageName: pageName
    );
  }
}

class _ChatHistoryPageRestoration extends ExtendedMixableGetxPageRestoration with HelpChatPageRestorationMixin, ProductChatPageRestorationMixin, OrderChatPageRestorationMixin {
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

class ChatHistoryPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => ChatHistoryPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ChatHistoryPage()));
}

mixin ChatHistoryPageRestorationMixin on MixableGetxPageRestoration {
  late ChatHistoryPageRestorableRouteFuture chatHistoryPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    chatHistoryPageRestorableRouteFuture = ChatHistoryPageRestorableRouteFuture(restorationId: restorationIdWithPageName('chat-history-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    chatHistoryPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    chatHistoryPageRestorableRouteFuture.dispose();
  }
}

class ChatHistoryPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ChatHistoryPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ChatHistoryPageGetPageBuilderAssistant()),
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

class _StatefulChatHistoryControllerMediatorWidget extends StatefulWidget {
  final ChatHistoryController chatHistoryController;
  final List<List<dynamic>> chatHistorySubControllerList;
  final String pageName;

  const _StatefulChatHistoryControllerMediatorWidget({
    required this.chatHistoryController,
    required this.chatHistorySubControllerList,
    required this.pageName
  });

  @override
  State<_StatefulChatHistoryControllerMediatorWidget> createState() => _StatefulChatHistoryControllerMediatorWidgetState();
}

class _StatefulChatHistoryControllerMediatorWidgetState extends State<_StatefulChatHistoryControllerMediatorWidget> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int _tabControllerIndex = 0;
  FocusNode? _textFocusNode;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      _textFocusNode?.unfocus();
      setState(() => _tabControllerIndex = _tabController.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Chat History".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ModifiedTabBar(
              controller: _tabController,
              tabs: <Widget>[
                Tab(
                  text: "Help".tr,
                ),
                Tab(
                  text: "Product".tr
                ),
                Tab(
                  text: "Order".tr
                )
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _tabControllerIndex,
                children: [
                  HelpChatHistorySubPage(
                    ancestorPageName: widget.pageName,
                    onAddControllerMember: () => widget.chatHistorySubControllerList[0][2]() as ControllerMember<HelpChatController>,
                    onGetTextFocusNode: (focusNode) => _textFocusNode = focusNode,
                  ),
                  ProductChatHistorySubPage(
                    ancestorPageName: widget.pageName,
                    onAddControllerMember: () => widget.chatHistorySubControllerList[1][2]() as ControllerMember<ProductChatHistorySubController>,
                  ),
                  OrderChatHistorySubPage(
                    ancestorPageName: widget.pageName,
                    onAddControllerMember: () => widget.chatHistorySubControllerList[2][2]() as ControllerMember<OrderChatHistorySubController>,
                  )
                ],
              )
            )
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}