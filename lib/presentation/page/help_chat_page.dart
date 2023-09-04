import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/controller/help_chat_controller.dart';
import 'package:masterbagasi/domain/entity/chat/user_message.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/getextended/get_extended.dart';
import 'package:masterbagasi/misc/getextended/get_restorable_route_future.dart';
import 'package:masterbagasi/misc/manager/controller_manager.dart';
import 'package:masterbagasi/misc/paging/pagingresult/paging_data_result.dart';
import 'package:masterbagasi/presentation/widget/modified_paged_list_view.dart';
import 'package:masterbagasi/presentation/widget/modifiedappbar/modified_app_bar.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../domain/entity/chat/help/answer_help_conversation_parameter.dart';
import '../../domain/entity/chat/help/create_help_conversation_parameter.dart';
import '../../domain/entity/chat/help/create_help_conversation_response.dart';
import '../../domain/entity/chat/help/get_help_message_by_user_parameter.dart';
import '../../domain/entity/chat/help/get_help_message_by_user_response.dart';
import '../../domain/entity/chat/help/help_message.dart';
import '../../domain/entity/chat/user_chat.dart';
import '../../domain/entity/chat/user_message_response_wrapper.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/getuser/get_user_response.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/answer_help_conversation_use_case.dart';
import '../../domain/usecase/create_help_conversation_use_case.dart';
import '../../domain/usecase/get_help_message_by_user_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/chatlistitemcontrollerstate/chat_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/empty_chat_error.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/chat_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/response_wrapper.dart';
import '../widget/modified_loading_indicator.dart';
import '../widget/modified_shimmer.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/tap_area.dart';
import 'getx_page.dart';

class HelpChatPage extends RestorableGetxPage<_HelpChatPageRestoration> {
  late final ControllerMember<HelpChatController> _helpChatController = ControllerMember<HelpChatController>().addToControllerManager(controllerManager);

  HelpChatPage({Key? key}) : super(key: key, pageRestorationId: () => "help-chat-page");

  @override
  void onSetController() {
    _helpChatController.controller = GetExtended.put<HelpChatController>(
      HelpChatController(
        controllerManager,
        Injector.locator<GetHelpMessageByUserUseCase>(),
        Injector.locator<CreateHelpConversationUseCase>(),
        Injector.locator<AnswerHelpConversationUseCase>(),
        Injector.locator<GetUserUseCase>()
      ),
      tag: pageName
    );
  }

  @override
  _HelpChatPageRestoration createPageRestoration() => _HelpChatPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: StatefulHelpChatControllerMediatorWidget(
        helpChatController: _helpChatController.controller,
      ),
    );
  }
}

class _HelpChatPageRestoration extends MixableGetxPageRestoration with HelpChatPageRestorationMixin {
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

class HelpChatPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  @override
  GetPageBuilder get pageBuilder => (() => HelpChatPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(HelpChatPage()));
}

mixin HelpChatPageRestorationMixin on MixableGetxPageRestoration {
  late HelpChatPageRestorableRouteFuture helpChatPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    helpChatPageRestorableRouteFuture = HelpChatPageRestorableRouteFuture(restorationId: restorationIdWithPageName('help-chat-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    helpChatPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    helpChatPageRestorableRouteFuture.dispose();
  }
}

class HelpChatPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  HelpChatPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<void>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
    );
  }

  static Route<void>? _getRoute([Object? arguments]) {
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(HelpChatPageGetPageBuilderAssistant())
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

class StatefulHelpChatControllerMediatorWidget extends StatefulWidget {
  final HelpChatController helpChatController;
  final bool withAppBar;
  final void Function(FocusNode)? onGetTextFocusNode;

  const StatefulHelpChatControllerMediatorWidget({
    super.key,
    required this.helpChatController,
    this.withAppBar = true,
    this.onGetTextFocusNode
  });

  @override
  State<StatefulHelpChatControllerMediatorWidget> createState() => _StatefulHelpChatControllerMediatorWidgetState();
}

class _StatefulHelpChatControllerMediatorWidgetState extends State<StatefulHelpChatControllerMediatorWidget> {
  late final ScrollController _helpChatScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _helpChatListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _helpChatListItemPagingControllerState;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final TextEditingController _helpTextEditingController = TextEditingController();
  final FocusNode _helpTextFocusNode = FocusNode();
  bool _isFirstEmpty = false;
  bool _showLoadingIndicatorInTextField = false;
  String _helpConversationId = "";
  User? _loggedUser;
  final DefaultChatContainerInterceptingActionListItemControllerState _defaultChatContainerInterceptingActionListItemControllerState = DefaultChatContainerInterceptingActionListItemControllerState();

  void _scrollToDown() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _helpChatScrollController.jumpTo(0);
    });
  }

  @override
  void initState() {
    super.initState();
    _helpChatScrollController = ScrollController();
    _helpChatListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.helpChatController.apiRequestManager
    );
    _helpChatListItemPagingControllerState = PagingControllerState(
      pagingController: _helpChatListItemPagingController,
      scrollController: _helpChatScrollController,
      isPagingControllerExist: false
    );
    _helpChatListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _helpChatListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _helpChatListItemPagingControllerState.isPagingControllerExist = true;
    if (widget.onGetTextFocusNode != null) {
      widget.onGetTextFocusNode!(_helpTextFocusNode);
    }
  }

  Future<UserMessageResponseWrapper<GetHelpMessageByUserResponse>> getHelpMessageByUser() async {
    LoadDataResult<User> getUserLoadDataResult = await widget.helpChatController.getUser(
      GetUserParameter()
    ).map<User>((value) => value.user);
    if (getUserLoadDataResult.isFailed) {
      Future<LoadDataResult<GetHelpMessageByUserResponse>> returnUserLoadFailed() async {
        return getUserLoadDataResult.map<GetHelpMessageByUserResponse>(
          // This is for required argument purposes only, not will be used for further process
          (_) => GetHelpMessageByUserResponse(
            id: "",
            userOne: null,
            userTwo: null,
            unreadMessagesCount: 1,
            helpMessageList: []
          )
        );
      }
      return UserMessageResponseWrapper(
        userLoadDataResult: getUserLoadDataResult,
        valueLoadDataResult: await returnUserLoadFailed()
      );
    }
    return UserMessageResponseWrapper(
      userLoadDataResult: getUserLoadDataResult,
      valueLoadDataResult: await widget.helpChatController.getHelpMessageByUser(
        GetHelpMessageByUserParameter()
      )
    );
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _helpChatListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    UserMessageResponseWrapper<GetHelpMessageByUserResponse> getHelpMessageByUserResponseLoadDataResult = await getHelpMessageByUser();
    if (getHelpMessageByUserResponseLoadDataResult.valueLoadDataResult.isFailed) {
      dynamic e = getHelpMessageByUserResponseLoadDataResult.valueLoadDataResult.resultIfFailed;
      if (e is EmptyChatError) {
        _isFirstEmpty = true;
        User user = getHelpMessageByUserResponseLoadDataResult.userLoadDataResult.resultIfSuccess!;
        _loggedUser = user;
        return SuccessLoadDataResult(
          value: PagingDataResult<ListItemControllerState>(
            itemList: [
              ChatContainerListItemControllerState(
                userMessageList: [],
                loggedUser: user,
                chatContainerInterceptingActionListItemControllerState: _defaultChatContainerInterceptingActionListItemControllerState,
                onUpdateState: () => setState(() {})
              )
            ],
            page: 1,
            totalPage: 1,
            totalItem: 1
          )
        );
      }
    }
    if (getHelpMessageByUserResponseLoadDataResult.valueLoadDataResult.isSuccess) {
      await PusherHelper.connectChatPusherChannel(
        pusherChannelsFlutter: _pusher,
        onEvent: _onEvent,
        chatPusherChannelType: ChatPusherChannelType.help,
        conversationId: getHelpMessageByUserResponseLoadDataResult.valueLoadDataResult.resultIfSuccess!.id,
      );
    }
    return getHelpMessageByUserResponseLoadDataResult.valueLoadDataResult.map<PagingResult<ListItemControllerState>>((getHelpMessageByUserResponse) {
      _helpConversationId = getHelpMessageByUserResponse.id;
      User user = getHelpMessageByUserResponseLoadDataResult.userLoadDataResult.resultIfSuccess!;
      _loggedUser = user;
      _scrollToDown();
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          ChatContainerListItemControllerState(
            userMessageList: getHelpMessageByUserResponse.helpMessageList,
            loggedUser: user,
            chatContainerInterceptingActionListItemControllerState: _defaultChatContainerInterceptingActionListItemControllerState,
            onUpdateState: () => setState(() {})
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.withAppBar ? ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Mista".tr),
          ],
        ),
      ) : null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                reverse: true,
                pagingControllerState: _helpChatListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: false
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Constant.colorGrey4
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: _helpTextFocusNode,
                        controller: _helpTextEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: "Type Chat".tr,
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5
                      ),
                    ),
                    SizedBox(
                      width: 23,
                      height: 23,
                      child: _showLoadingIndicatorInTextField ? const ModifiedLoadingIndicator() : TapArea(
                        onTap: () async {
                          if (_isFirstEmpty) {
                            setState(() => _showLoadingIndicatorInTextField = true);
                            LoadDataResult<CreateHelpConversationResponse> createHelpConversationResponseLoadDataResult = await widget.helpChatController.createHelpConversation(
                              CreateHelpConversationParameter(
                                message: _helpTextEditingController.text
                              )
                            );
                            if (createHelpConversationResponseLoadDataResult.isSuccess) {
                              _helpConversationId = createHelpConversationResponseLoadDataResult.resultIfSuccess!.helpConversationId;
                            }
                            await PusherHelper.connectChatPusherChannel(
                              pusherChannelsFlutter: _pusher,
                              onEvent: _onEvent,
                              chatPusherChannelType: ChatPusherChannelType.help,
                              conversationId: _helpConversationId,
                            );
                            _isFirstEmpty = false;
                            setState(() => _showLoadingIndicatorInTextField = false);
                          } else {
                            widget.helpChatController.answerHelpConversation(
                              AnswerHelpConversationParameter(
                                helpConversationId: _helpConversationId,
                                message: _helpTextEditingController.text
                              )
                            );
                          }
                          if (_defaultChatContainerInterceptingActionListItemControllerState.onAddUserMessage != null) {
                            _defaultChatContainerInterceptingActionListItemControllerState.onAddUserMessage!(
                              HelpMessage(
                                id: "-1",
                                helpConversationId: _helpConversationId,
                                userId: (_loggedUser?.id).toEmptyStringNonNull,
                                message: _helpTextEditingController.text, //_helpTextEditingController.text,
                                readStatus: 1,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                                deletedAt: DateTime.now(),
                                userChat: UserChat(
                                  id: "",
                                  name: "",
                                  role: 1,
                                  email: ""
                                ),
                                isLoading: true
                              )
                            );
                          }
                          _refreshChat();
                          _helpTextEditingController.clear();
                          _scrollToDown();
                        },
                        child: ModifiedSvgPicture.asset(Constant.vectorSendMessage, overrideDefaultColorWithSingleColor: false),
                      )
                    )
                  ],
                )
              )
            )
          ]
        )
      ),
    );
  }

  Future<void> _refreshChat() async {
    var productResponse = await getHelpMessageByUser();
    if (productResponse.valueLoadDataResult.isSuccess) {
      if (_defaultChatContainerInterceptingActionListItemControllerState.onUpdateUserMessage != null) {
        _defaultChatContainerInterceptingActionListItemControllerState.onUpdateUserMessage!(
          productResponse.valueLoadDataResult.resultIfSuccess!.helpMessageList
        );
      }
    }
  }

  void _onEvent(PusherEvent event) {
    _refreshChat();
  }

  @override
  void dispose() {
    _helpTextFocusNode.dispose();
    _helpTextEditingController.dispose();
    _pusher.disconnect();
    super.dispose();
  }
}