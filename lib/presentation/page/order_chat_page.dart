import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/order_chat_controller.dart';
import '../../domain/entity/chat/order/answer_order_conversation_parameter.dart';
import '../../domain/entity/chat/order/combined_order_from_message.dart';
import '../../domain/entity/chat/order/get_order_message_by_combined_order_parameter.dart';
import '../../domain/entity/chat/order/get_order_message_by_combined_order_response.dart';
import '../../domain/entity/chat/order/get_order_message_by_user_parameter.dart';
import '../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../domain/entity/chat/user_message_response_wrapper.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/usecase/answer_order_conversation_use_case.dart';
import '../../domain/usecase/create_order_conversation_use_case.dart';
import '../../domain/usecase/get_order_message_by_combined_order_use_case.dart';
import '../../domain/usecase/get_order_message_by_user_use_case.dart';
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
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_svg_picture.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/tap_area.dart';
import 'getx_page.dart';

class OrderChatPage extends RestorableGetxPage<_OrderChatPageRestoration> {
  final String combinedOrderId;

  late final ControllerMember<OrderChatController> _orderChatController = ControllerMember<OrderChatController>().addToControllerManager(controllerManager);

  OrderChatPage({Key? key, required this.combinedOrderId}) : super(key: key, pageRestorationId: () => "order-chat-page");

  @override
  void onSetController() {
    _orderChatController.controller = GetExtended.put<OrderChatController>(
      OrderChatController(
        controllerManager,
        Injector.locator<GetOrderMessageByUserUseCase>(),
        Injector.locator<GetOrderMessageByCombinedOrderUseCase>(),
        Injector.locator<CreateOrderConversationUseCase>(),
        Injector.locator<AnswerOrderConversationUseCase>(),
        Injector.locator<GetUserUseCase>(),
      ),
      tag: pageName
    );
  }

  @override
  _OrderChatPageRestoration createPageRestoration() => _OrderChatPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulOrderChatControllerMediatorWidget(
        combinedOrderId: combinedOrderId,
        orderChatController: _orderChatController.controller,
      ),
    );
  }
}

class _OrderChatPageRestoration extends MixableGetxPageRestoration with OrderChatPageRestorationMixin {
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

class OrderChatPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final String combinedOrderId;

  OrderChatPageGetPageBuilderAssistant({
    required this.combinedOrderId
  });

  @override
  GetPageBuilder get pageBuilder => (() => OrderChatPage(combinedOrderId: combinedOrderId));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(OrderChatPage(combinedOrderId: combinedOrderId)));
}

mixin OrderChatPageRestorationMixin on MixableGetxPageRestoration {
  late OrderChatPageRestorableRouteFuture orderChatPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    orderChatPageRestorableRouteFuture = OrderChatPageRestorableRouteFuture(restorationId: restorationIdWithPageName('order-chat-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    orderChatPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    orderChatPageRestorableRouteFuture.dispose();
  }
}

class OrderChatPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  OrderChatPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
      GetxPageBuilder.buildRestorableGetxPageBuilder(OrderChatPageGetPageBuilderAssistant(combinedOrderId: arguments))
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

class _StatefulOrderChatControllerMediatorWidget extends StatefulWidget {
  final String combinedOrderId;
  final OrderChatController orderChatController;

  const _StatefulOrderChatControllerMediatorWidget({
    required this.combinedOrderId,
    required this.orderChatController
  });

  @override
  State<_StatefulOrderChatControllerMediatorWidget> createState() => _StatefulOrderChatControllerMediatorWidgetState();
}

class _StatefulOrderChatControllerMediatorWidgetState extends State<_StatefulOrderChatControllerMediatorWidget> {
  late final ScrollController _orderChatScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _orderChatListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _orderChatListItemPagingControllerState;

  final TextEditingController _orderChatTextEditingController = TextEditingController();
  bool _isFirstEmpty = false;
  String _orderConversationId = "";

  final DefaultChatContainerInterceptingActionListItemControllerState _defaultChatContainerInterceptingActionListItemControllerState = DefaultChatContainerInterceptingActionListItemControllerState();

  @override
  void initState() {
    super.initState();
    _orderChatScrollController = ScrollController();
    _orderChatListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.orderChatController.apiRequestManager
    );
    _orderChatListItemPagingControllerState = PagingControllerState(
      pagingController: _orderChatListItemPagingController,
      isPagingControllerExist: false
    );
    _orderChatListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _helpChatListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _orderChatListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<UserMessageResponseWrapper<GetOrderMessageByCombinedOrderResponse>> getOrderMessageByCombinedOrder() async {
    LoadDataResult<User> getUserLoadDataResult = await widget.orderChatController.getUser(
      GetUserParameter()
    ).map<User>((value) => value.user);
    if (getUserLoadDataResult.isFailed) {
      Future<LoadDataResult<GetOrderMessageByCombinedOrderResponse>> returnUserLoadFailed() async {
        return getUserLoadDataResult.map<GetOrderMessageByCombinedOrderResponse>(
          // This is for required argument purposes only, not will be used for further process
          (_) => GetOrderMessageByCombinedOrderResponse(
            getOrderMessageByCombinedOrderResponseMember: GetOrderMessageByCombinedOrderResponseMember(
              id: "",
              userOne: null,
              userTwo: null,
              unreadMessagesCount: 1,
              order: CombinedOrderFromMessage(
                id: "",
                orderCode: ""
              ),
              orderMessageList: []
            )
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
      valueLoadDataResult: await widget.orderChatController.getOrderMessageByCombinedOrder(
        GetOrderMessageByCombinedOrderParameter(combinedOrderId: widget.combinedOrderId)
      )
    );
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _helpChatListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    UserMessageResponseWrapper<GetOrderMessageByCombinedOrderResponse> getOrderMessageByCombinedOrderResponseLoadDataResult = await getOrderMessageByCombinedOrder();
    if (getOrderMessageByCombinedOrderResponseLoadDataResult.valueLoadDataResult.isFailed) {
      dynamic e = getOrderMessageByCombinedOrderResponseLoadDataResult.valueLoadDataResult.resultIfFailed;
      if (e is EmptyChatError) {
        _isFirstEmpty = true;
        User user = getOrderMessageByCombinedOrderResponseLoadDataResult.userLoadDataResult.resultIfSuccess!;
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
    return getOrderMessageByCombinedOrderResponseLoadDataResult.valueLoadDataResult.map<PagingResult<ListItemControllerState>>((getOrderMessageByUserResponse) {
      _orderConversationId = getOrderMessageByUserResponse.getOrderMessageByCombinedOrderResponseMember.id;
      User user = getOrderMessageByCombinedOrderResponseLoadDataResult.userLoadDataResult.resultIfSuccess!;
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          ChatContainerListItemControllerState(
            userMessageList: getOrderMessageByUserResponse.getOrderMessageByCombinedOrderResponseMember.orderMessageList,
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
            Text("Order Chat".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _orderChatListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
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
                        controller: _orderChatTextEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: "Type Chat".tr,
                        ),
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        minLines: 1,
                        maxLines: 5
                      ),
                    ),
                    TapArea(
                      onTap: () async {
                        if (_isFirstEmpty) {
                          _isFirstEmpty = false;
                          var productResponse = await getOrderMessageByCombinedOrder();
                          if (productResponse.valueLoadDataResult.isSuccess) {
                            if (_defaultChatContainerInterceptingActionListItemControllerState.onUpdateUserMessage != null) {
                              _defaultChatContainerInterceptingActionListItemControllerState.onUpdateUserMessage!(
                                productResponse.valueLoadDataResult.resultIfSuccess!.getOrderMessageByCombinedOrderResponseMember.orderMessageList
                              );
                            }
                          }
                        } else {
                          widget.orderChatController.answerOrderConversation(
                            AnswerOrderConversationParameter(
                              orderConversationId: _orderConversationId,
                              message: _orderChatTextEditingController.text
                            )
                          );
                        }
                      },
                      child: ModifiedSvgPicture.asset(Constant.vectorSendMessage, overrideDefaultColorWithSingleColor: false),
                    )
                  ]
                )
              )
            )
          ]
        )
      ),
    );
  }
}