import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/delivery_controller.dart';
import '../../domain/entity/additionalitem/add_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/add_additional_item_response.dart';
import '../../domain/entity/additionalitem/additional_item.dart';
import '../../domain/entity/additionalitem/additional_item_list_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/change_additional_item_response.dart';
import '../../domain/entity/additionalitem/remove_additional_item_parameter.dart';
import '../../domain/entity/additionalitem/remove_additional_item_response.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/current_selected_address_parameter.dart';
import '../../domain/entity/address/current_selected_address_response.dart';
import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/cart/cart_paging_parameter.dart';
import '../../domain/entity/cart/support_cart.dart';
import '../../domain/usecase/add_additional_item_use_case.dart';
import '../../domain/usecase/change_additional_item_use_case.dart';
import '../../domain/usecase/get_additional_item_use_case.dart';
import '../../domain/usecase/get_cart_summary_use_case.dart';
import '../../domain/usecase/get_current_selected_address_use_case.dart';
import '../../domain/usecase/get_my_cart_use_case.dart';
import '../../domain/usecase/remove_additional_item_use_case.dart';
import '../../misc/additionalloadingindicatorchecker/cart_additional_paging_result_parameter_checker.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/vertical_cart_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/deliverycartlistitemcontrollerstate/delivery_cart_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/page_keyed_list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/cart_item_type_list_sub_interceptor.dart';
import '../../misc/itemtypelistsubinterceptor/delivery_cart_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/string_util.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'address_page.dart';
import 'getx_page.dart';
import 'modaldialogpage/add_cart_note_modal_dialog_page.dart';
import 'web_viewer_page.dart';

// ignore: must_be_immutable
class DeliveryPage extends RestorableGetxPage<_DeliveryPageRestoration> {
  late final ControllerMember<DeliveryController> _deliveryController = ControllerMember<DeliveryController>().addToControllerManager(controllerManager);
  final List<String> selectedCartIdList;
  _StatefulDeliveryControllerMediatorWidgetDelegate _statefulDeliveryControllerMediatorWidgetDelegate = _StatefulDeliveryControllerMediatorWidgetDelegate();

  DeliveryPage({
    Key? key,
    required this.selectedCartIdList
  }) : super(key: key, pageRestorationId: () => "delivery-page");

  @override
  void onSetController() {
    _deliveryController.controller = GetExtended.put<DeliveryController>(
      DeliveryController(
        controllerManager,
        Injector.locator<GetMyCartUseCase>(),
        Injector.locator<GetCurrentSelectedAddressUseCase>(),
        Injector.locator<GetCartSummaryUseCase>(),
        Injector.locator<GetAdditionalItemUseCase>(),
        Injector.locator<AddAdditionalItemUseCase>(),
        Injector.locator<ChangeAdditionalItemUseCase>(),
        Injector.locator<RemoveAdditionalItemUseCase>()
      ), tag: pageName
    );
  }

  @override
  _DeliveryPageRestoration createPageRestoration() => _DeliveryPageRestoration(
    onCompleteAddressPage: (result) {
      if (result != null) {
        if (result) {
          if (_statefulDeliveryControllerMediatorWidgetDelegate.onRefreshDelivery != null) {
            _statefulDeliveryControllerMediatorWidgetDelegate.onRefreshDelivery!();
          }
        }
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    return Scaffold(
      body: _StatefulDeliveryControllerMediatorWidget(
        deliveryController: _deliveryController.controller,
        selectedCartIdList: selectedCartIdList,
        statefulDeliveryControllerMediatorWidgetDelegate: _statefulDeliveryControllerMediatorWidgetDelegate,
      ),
    );
  }
}

class _DeliveryPageRestoration extends MixableGetxPageRestoration with DeliveryPageRestorationMixin, WebViewerPageRestorationMixin, AddressPageRestorationMixin {
  final RouteCompletionCallback<bool?>? _onCompleteAddressPage;

  _DeliveryPageRestoration({
    RouteCompletionCallback<bool?>? onCompleteAddressPage,
  }) : _onCompleteAddressPage = onCompleteAddressPage;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteSelectAddress = _onCompleteAddressPage;
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

class DeliveryPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final List<String> selectedCartIdList;

  DeliveryPageGetPageBuilderAssistant({
    required this.selectedCartIdList
  });

  @override
  GetPageBuilder get pageBuilder => (() => DeliveryPage(
    selectedCartIdList: selectedCartIdList
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(DeliveryPage(
    selectedCartIdList: selectedCartIdList
  )));
}

mixin DeliveryPageRestorationMixin on MixableGetxPageRestoration {
  late DeliveryPageRestorableRouteFuture deliveryPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    deliveryPageRestorableRouteFuture = DeliveryPageRestorableRouteFuture(restorationId: restorationIdWithPageName('delivery-route'));
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    deliveryPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    deliveryPageRestorableRouteFuture.dispose();
  }
}

class DeliveryPageRestorableRouteFuture extends GetRestorableRouteFuture {
  late RestorableRouteFuture<void> _pageRoute;

  DeliveryPageRestorableRouteFuture({required String restorationId}) : super(restorationId: restorationId) {
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
    List<String> selectedCartIdList = arguments.toDeliveryPageParameter().selectedCartIdList;
    return GetExtended.toWithGetPageRouteReturnValue<void>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        DeliveryPageGetPageBuilderAssistant(
          selectedCartIdList: selectedCartIdList
        )
      ),
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

class _StatefulDeliveryControllerMediatorWidgetDelegate {
  void Function()? onRefreshDelivery;
}

class _StatefulDeliveryControllerMediatorWidget extends StatefulWidget {
  final DeliveryController deliveryController;
  final List<String> selectedCartIdList;
  final _StatefulDeliveryControllerMediatorWidgetDelegate statefulDeliveryControllerMediatorWidgetDelegate;

  const _StatefulDeliveryControllerMediatorWidget({
    required this.deliveryController,
    required this.selectedCartIdList,
    required this.statefulDeliveryControllerMediatorWidgetDelegate
  });

  @override
  State<_StatefulDeliveryControllerMediatorWidget> createState() => _StatefulDeliveryControllerMediatorWidgetState();
}

class _StatefulDeliveryControllerMediatorWidgetState extends State<_StatefulDeliveryControllerMediatorWidget> {
  late final ScrollController _deliveryScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _deliveryListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _deliveryListItemPagingControllerState;
  late int _selectedCartCount = 0;
  late double _selectedCartShoppingTotal = 0;
  List<AdditionalItem> _additionalItemList = [];

  @override
  void initState() {
    super.initState();
    _deliveryScrollController = ScrollController();
    _deliveryListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.deliveryController.apiRequestManager,
      additionalPagingResultParameterChecker: Injector.locator<CartAdditionalPagingResultParameterChecker>()
    );
    _deliveryListItemPagingControllerState = PagingControllerState(
      pagingController: _deliveryListItemPagingController,
      scrollController: _deliveryScrollController,
      isPagingControllerExist: false
    );
    _deliveryListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _deliveryListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _deliveryListItemPagingControllerState.isPagingControllerExist = true;
    widget.statefulDeliveryControllerMediatorWidgetDelegate.onRefreshDelivery = () => _deliveryListItemPagingController.refresh();
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _deliveryListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? cartListItemControllerStateList) async {
    LoadDataResult<PagingDataResult<Cart>> cartPagingLoadDataResult = await widget.deliveryController.getDeliveryCartPaging(
      CartPagingParameter(page: pageKey)
    );
    return cartPagingLoadDataResult.map<PagingResult<ListItemControllerState>>((cartPaging) {
      List<CartListItemControllerState> newCartListItemControllerStateList = [];
      for (var iteratedCart in cartPaging.itemList) {
        for (var iteratedCartId in widget.selectedCartIdList) {
          if (iteratedCart.id == iteratedCartId) {
            newCartListItemControllerStateList.add(
              VerticalCartListItemControllerState(
                isSelected: true,
                cart: iteratedCart,
                showCheck: false,
                showDefaultCart: false,
                onRemoveFromNotes: () async {
                  iteratedCart.notes = null;
                  setState(() {});
                },
                onAddToNotes: () async {
                  dynamic result = await DialogHelper.showModalDialogPage<String, String>(
                    context: context,
                    modalDialogPageBuilder: (context, parameter) => AddCartNoteModalDialogPage(),
                  );
                  if (result != null) {
                    iteratedCart.notes = result;
                    setState(() {});
                  }
                },
              )
            );
          }
        }
      }
      if (pageKey == 1) {
        return PagingDataResult<ListItemControllerState>(
          itemList: [
            DeliveryCartContainerListItemControllerState(
              selectedCartIdList: widget.selectedCartIdList,
              cartListItemControllerStateList: newCartListItemControllerStateList,
              onUpdateState: () => setState(() {}),
              onScrollToAdditionalItemsSection: () => _deliveryScrollController.jumpTo(
                _deliveryScrollController.position.maxScrollExtent
              ),
              additionalItemList: _additionalItemList,
              onChangeSelected: (cartList) {
                setState(() {
                  _selectedCartCount = cartList.length;
                  _selectedCartShoppingTotal = 0;
                  for (Cart cart in cartList) {
                    SupportCart supportCart = cart.supportCart;
                    _selectedCartShoppingTotal += supportCart.cartPrice * cart.quantity.toDouble();
                  }
                });
              },
              deliveryCartContainerStateStorageListItemControllerState: DefaultDeliveryCartContainerStateStorageListItemControllerState(),
              deliveryCartContainerActionListItemControllerState: _DefaultDeliveryCartContainerActionListItemControllerState(
                getAdditionalItemList: (additionalItemListParameter) => widget.deliveryController.getAdditionalItem(additionalItemListParameter),
                addAdditionalItem: (addAdditionalItemParameter) => widget.deliveryController.addAdditionalItem(addAdditionalItemParameter),
                changeAdditionalItem: (changeAdditionalItemParameter) => widget.deliveryController.changeAdditionalItem(changeAdditionalItemParameter),
                removeAdditionalItem: (removeAdditionalItemParameter) => widget.deliveryController.removeAdditionalItem(removeAdditionalItemParameter),
                getCurrentSelectedAddress: (currentSelectedAddressParameter) => widget.deliveryController.getCurrentSelectedAddress(currentSelectedAddressParameter),
              )
            )
          ],
          page: cartPaging.page,
          totalPage: cartPaging.totalPage,
          totalItem: 1
        );
      } else {
        if (cartListItemControllerStateList != null) {
          if (cartListItemControllerStateList.isNotEmpty) {
            ListItemControllerState cartListItemControllerState = cartListItemControllerStateList.first;
            if (cartListItemControllerState is PageKeyedListItemControllerState) {
              if (cartListItemControllerState.listItemControllerState != null) {
                cartListItemControllerState = cartListItemControllerState.listItemControllerState!;
              }
            }
            if (cartListItemControllerState is CartContainerListItemControllerState) {
              cartListItemControllerState.cartListItemControllerStateList.addAll(
                newCartListItemControllerStateList
              );
            }
          }
        }
        return PagingDataResult<ListItemControllerState>(
          itemList: [],
          page: cartPaging.page,
          totalPage: cartPaging.totalPage,
          totalItem: 0
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Delivery".tr),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                pagingControllerState: _deliveryListItemPagingControllerState,
                onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                  pagingControllerState: pagingControllerState!
                ),
                pullToRefresh: true
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Shopping Total".tr),
                            const SizedBox(height: 4),
                            Text(_selectedCartShoppingTotal.toRupiah(), style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            )),
                          ]
                        )
                      ),
                      SizedOutlineGradientButton(
                        onPressed: _selectedCartCount == 0 ? null : () {
                          PageRestorationHelper.toWebViewerPage(
                            context,
                            {Constant.textEncodedUrlKey: StringUtil.encodeBase64String("")}
                          );
                        },
                        width: 120,
                        text: "${"Pay".tr} ($_selectedCartCount)",
                        outlineGradientButtonType: OutlineGradientButtonType.solid,
                        outlineGradientButtonVariation: OutlineGradientButtonVariation.variation2,
                      )
                    ],
                  )
                ]
              ),
            )
          ]
        )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class DeliveryPageParameter {
  List<String> selectedCartIdList;

  DeliveryPageParameter({
    required this.selectedCartIdList
  });
}

extension DeliveryPageParameterExt on DeliveryPageParameter {
  String toEncodeBase64String() => StringUtil.encodeBase64StringFromJson(
    <String, dynamic>{
      "selected_cart_id": selectedCartIdList,
    }
  );
}

extension DeliveryPageParameterStringExt on String {
  DeliveryPageParameter toDeliveryPageParameter() {
    dynamic result = StringUtil.decodeBase64StringToJson(this);
    return DeliveryPageParameter(
      selectedCartIdList: result['selected_cart_id'].map<String>(
        (cartIdString) => cartIdString as String
      ).toList()
    );
  }
}

class _DefaultDeliveryCartContainerActionListItemControllerState extends DeliveryCartContainerActionListItemControllerState {
  final Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter)? _getAdditionalItemList;
  final Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter)? _addAdditionalItem;
  final Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter)? _changeAdditionalItem;
  final Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter)? _removeAdditionalItem;
  final Future<LoadDataResult<Address>> Function(CurrentSelectedAddressParameter)? _getCurrentSelectedAddress;

  _DefaultDeliveryCartContainerActionListItemControllerState({
    required Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter) getAdditionalItemList,
    required Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter) addAdditionalItem,
    required Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter) changeAdditionalItem,
    required Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter) removeAdditionalItem,
    required Future<LoadDataResult<Address>> Function(CurrentSelectedAddressParameter)? getCurrentSelectedAddress
  }) : _getAdditionalItemList = getAdditionalItemList,
        _addAdditionalItem = addAdditionalItem,
        _changeAdditionalItem = changeAdditionalItem,
        _removeAdditionalItem = removeAdditionalItem,
        _getCurrentSelectedAddress = getCurrentSelectedAddress;

  @override
  Future<LoadDataResult<List<AdditionalItem>>> Function(AdditionalItemListParameter) get getAdditionalItemList => _getAdditionalItemList ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<AddAdditionalItemResponse>> Function(AddAdditionalItemParameter) get addAdditionalItem => _addAdditionalItem ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<ChangeAdditionalItemResponse>> Function(ChangeAdditionalItemParameter) get changeAdditionalItem => _changeAdditionalItem ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<RemoveAdditionalItemResponse>> Function(RemoveAdditionalItemParameter) get removeAdditionalItem => _removeAdditionalItem ?? (throw UnimplementedError());

  @override
  Future<LoadDataResult<Address>> Function(CurrentSelectedAddressParameter) get getCurrentSelectedAddress => _getCurrentSelectedAddress ?? (throw UnimplementedError());
}