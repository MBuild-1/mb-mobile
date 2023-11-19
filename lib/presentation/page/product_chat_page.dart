import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../controller/product_chat_controller.dart';
import '../../domain/entity/chat/product/answer_product_conversation_parameter.dart';
import '../../domain/entity/chat/product/create_product_conversation_parameter.dart';
import '../../domain/entity/chat/product/create_product_conversation_response.dart';
import '../../domain/entity/chat/product/get_product_message_by_product_parameter.dart';
import '../../domain/entity/chat/product/get_product_message_by_product_response.dart';
import '../../domain/entity/chat/product/product_message.dart';
import '../../domain/entity/chat/user_chat.dart';
import '../../domain/entity/chat/user_message_response_wrapper.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/answer_product_conversation_use_case.dart';
import '../../domain/usecase/create_product_conversation_use_case.dart';
import '../../domain/usecase/get_product_message_by_product_use_case.dart';
import '../../domain/usecase/get_product_message_by_user_use_case.dart';
import '../../domain/usecase/get_user_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/chatlistitemcontrollerstate/chat_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/error/empty_chat_error.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/chat_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/pusher_helper.dart';
import '../../misc/routeargument/product_chat_route_argument.dart';
import '../widget/modified_loading_indicator.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/tap_area.dart';
import 'getx_page.dart';

class ProductChatPage extends RestorableGetxPage<_ProductChatPageRestoration> {
  final String productId;

  late final ControllerMember<ProductChatController> _productChatController = ControllerMember<ProductChatController>().addToControllerManager(controllerManager);

  ProductChatPage({Key? key, required this.productId}) : super(key: key, pageRestorationId: () => "product-chat-page");

  @override
  void onSetController() {
    _productChatController.controller = GetExtended.put<ProductChatController>(
      ProductChatController(
        controllerManager,
        Injector.locator<GetProductMessageByUserUseCase>(),
        Injector.locator<GetProductMessageByProductUseCase>(),
        Injector.locator<CreateProductConversationUseCase>(),
        Injector.locator<AnswerProductConversationUseCase>(),
        Injector.locator<GetUserUseCase>(),
      ),
      tag: pageName
    );
  }

  @override
  _ProductChatPageRestoration createPageRestoration() => _ProductChatPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulProductChatControllerMediatorWidget(
        productId: productId,
        productChatController: _productChatController.controller,
      ),
    );
  }
}

class _ProductChatPageRestoration extends ExtendedMixableGetxPageRestoration with ProductChatPageRestorationMixin {
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

class ProductChatPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String productId;

  ProductChatPageGetPageBuilderAssistant({
    required this.productId
  });

  @override
  GetPageBuilder get pageBuilder => (() => ProductChatPage(productId: productId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(ProductChatPage(productId: productId)));
}

mixin ProductChatPageRestorationMixin on MixableGetxPageRestoration {
  late ProductChatPageRestorableRouteFuture productChatPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    productChatPageRestorableRouteFuture = ProductChatPageRestorableRouteFuture(restorationId: restorationIdWithPageName('product-chat-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    productChatPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    productChatPageRestorableRouteFuture.dispose();
  }
}

class ProductChatPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  ProductChatPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(ProductChatPageGetPageBuilderAssistant(productId: arguments)),
      arguments: ProductChatRouteArgument()
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

class _StatefulProductChatControllerMediatorWidget extends StatefulWidget {
  final String productId;
  final ProductChatController productChatController;

  const _StatefulProductChatControllerMediatorWidget({
    required this.productId,
    required this.productChatController
  });

  @override
  State<_StatefulProductChatControllerMediatorWidget> createState() => _StatefulProductChatControllerMediatorWidgetState();
}

class _StatefulProductChatControllerMediatorWidgetState extends State<_StatefulProductChatControllerMediatorWidget> {
  late final ScrollController _productChatScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _productChatListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _productChatListItemPagingControllerState;
  final PusherChannelsFlutter _pusher = PusherChannelsFlutter.getInstance();

  final TextEditingController _productChatTextEditingController = TextEditingController();
  bool _isFirstEmpty = false;
  bool _showLoadingIndicatorInTextField = false;
  String _productConversationId = "";
  User? _loggedUser;
  final DefaultChatContainerInterceptingActionListItemControllerState _defaultChatContainerInterceptingActionListItemControllerState = DefaultChatContainerInterceptingActionListItemControllerState();

  void _scrollToDown() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _productChatScrollController.jumpTo(0);
    });
  }

  @override
  void initState() {
    super.initState();
    _productChatScrollController = ScrollController();
    _productChatListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.productChatController.apiRequestManager
    );
    _productChatListItemPagingControllerState = PagingControllerState(
      pagingController: _productChatListItemPagingController,
      scrollController: _productChatScrollController,
      isPagingControllerExist: false
    );
    _productChatListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _helpChatListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _productChatListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<UserMessageResponseWrapper<GetProductMessageByProductResponse>> getProductMessageByProduct() async {
    LoadDataResult<User> getUserLoadDataResult = await widget.productChatController.getUser(
      GetUserParameter()
    ).map<User>((value) => value.user);
    if (getUserLoadDataResult.isFailed) {
      Future<LoadDataResult<GetProductMessageByProductResponse>> returnUserLoadFailed() async {
        return getUserLoadDataResult.map<GetProductMessageByProductResponse>(
          // This is for required argument purposes only, not will be used for further process
          (_) => GetProductMessageByProductResponse(
            id: "",
            userOne: null,
            userTwo: null,
            unreadMessagesCount: 1,
            productMessageList: []
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
      valueLoadDataResult: await widget.productChatController.getProductMessageByProduct(
        GetProductMessageByProductParameter(productId: widget.productId)
      )
    );
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _helpChatListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    UserMessageResponseWrapper<GetProductMessageByProductResponse> getProductMessageByProductResponseLoadDataResult = await getProductMessageByProduct();
    if (getProductMessageByProductResponseLoadDataResult.valueLoadDataResult.isFailed) {
      dynamic e = getProductMessageByProductResponseLoadDataResult.valueLoadDataResult.resultIfFailed;
      if (e is EmptyChatError) {
        _isFirstEmpty = true;
        User user = getProductMessageByProductResponseLoadDataResult.userLoadDataResult.resultIfSuccess!;
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
    if (getProductMessageByProductResponseLoadDataResult.valueLoadDataResult.isSuccess) {
      await PusherHelper.subscribeChatPusherChannel(
        pusherChannelsFlutter: _pusher,
        onEvent: _onEvent,
        chatPusherChannelType: ChatPusherChannelType.product,
        conversationId: getProductMessageByProductResponseLoadDataResult.valueLoadDataResult.resultIfSuccess!.id,
      );
    }
    return getProductMessageByProductResponseLoadDataResult.valueLoadDataResult.map<PagingResult<ListItemControllerState>>((getProductMessageByUserResponse) {
      _productConversationId = getProductMessageByUserResponse.id;
      User user = getProductMessageByProductResponseLoadDataResult.userLoadDataResult.resultIfSuccess!;
      _loggedUser = user;
      _scrollToDown();
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          ChatContainerListItemControllerState(
            userMessageList: getProductMessageByUserResponse.productMessageList,
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
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Product Chat".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                reverse: true,
                pagingControllerState: _productChatListItemPagingControllerState,
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
                        controller: _productChatTextEditingController,
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
                            LoadDataResult<CreateProductConversationResponse> createProductConversationResponseLoadDataResult = await widget.productChatController.createChatConversation(
                              CreateProductConversationParameter(
                                productId: widget.productId,
                                message: _productChatTextEditingController.text
                              )
                            );
                            if (createProductConversationResponseLoadDataResult.isSuccess) {
                              _productConversationId = createProductConversationResponseLoadDataResult.resultIfSuccess!.productConversationId;
                            }
                            await PusherHelper.subscribeChatPusherChannel(
                              pusherChannelsFlutter: _pusher,
                              onEvent: _onEvent,
                              chatPusherChannelType: ChatPusherChannelType.product,
                              conversationId: _productConversationId,
                            );
                            _isFirstEmpty = false;
                            setState(() => _showLoadingIndicatorInTextField = false);
                          } else {
                            widget.productChatController.answerProductConversation(
                              AnswerProductConversationParameter(
                                productConversationId: _productConversationId,
                                message: _productChatTextEditingController.text
                              )
                            );
                          }
                          if (_defaultChatContainerInterceptingActionListItemControllerState.onAddUserMessage != null) {
                            _defaultChatContainerInterceptingActionListItemControllerState.onAddUserMessage!(
                              ProductMessage(
                                id: "-1",
                                productConversationId: _productConversationId,
                                userId: (_loggedUser?.id).toEmptyStringNonNull,
                                message: _productChatTextEditingController.text, //_helpTextEditingController.text,
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
                          _productChatTextEditingController.clear();
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
    var productResponse = await getProductMessageByProduct();
    if (productResponse.valueLoadDataResult.isSuccess) {
      if (_defaultChatContainerInterceptingActionListItemControllerState.onUpdateUserMessage != null) {
        _defaultChatContainerInterceptingActionListItemControllerState.onUpdateUserMessage!(
          productResponse.valueLoadDataResult.resultIfSuccess!.productMessageList
        );
      }
    }
  }

  dynamic _onEvent(dynamic event) {
    _refreshChat();
  }

  @override
  void dispose() {
    _productChatTextEditingController.dispose();
    PusherHelper.unsubscribeChatPusherChannel(
      pusherChannelsFlutter: _pusher,
      chatPusherChannelType: ChatPusherChannelType.product,
      conversationId: _productConversationId
    );
    super.dispose();
  }
}