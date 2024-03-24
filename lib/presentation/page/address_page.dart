import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../controller/address_controller.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/address_list_parameter.dart';
import '../../domain/usecase/get_address_list_use_case.dart';
import '../../domain/usecase/get_address_paging_use_case.dart';
import '../../domain/usecase/remove_address_use_case.dart';
import '../../domain/usecase/update_current_selected_address_use_case.dart';
import '../../misc/constant.dart';
import '../../misc/controllerstate/listitemcontrollerstate/addresslistitemcontrollerstate/address_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/error/message_error.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/itemtypelistsubinterceptor/address_item_type_list_sub_interceptor.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/page_restoration_helper.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../../misc/string_util.dart';
import '../../misc/toast_helper.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modified_scaffold.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import '../widget/normal_text_style_for_appbar.dart';
import 'getx_page.dart';
import 'modify_address_page.dart';

class AddressPage extends RestorableGetxPage<_AddressPageRestoration> {
  late final ControllerMember<AddressController> _addressController = ControllerMember<AddressController>().addToControllerManager(controllerManager);

  final AddressPageParameter addressPageParameter;
  final _StatefulAddressControllerMediatorWidgetDelegate _statefulAddressControllerMediatorWidgetDelegate = _StatefulAddressControllerMediatorWidgetDelegate();

  AddressPage({
    Key? key,
    required this.addressPageParameter
  }) : super(key: key, pageRestorationId: () => "address-page");

  @override
  void onSetController() {
    _addressController.controller = GetExtended.put<AddressController>(
      AddressController(
        controllerManager,
        Injector.locator<GetAddressPagingUseCase>(),
        Injector.locator<GetAddressListUseCase>(),
        Injector.locator<UpdateCurrentSelectedAddressUseCase>(),
        Injector.locator<RemoveAddressUseCase>()
      ), tag: pageName
    );
  }

  @override
  _AddressPageRestoration createPageRestoration() => _AddressPageRestoration(
    onCompleteModifyAddress: (result) {
      if (result != null) {
        if (result) {
          if (_statefulAddressControllerMediatorWidgetDelegate.onRefreshAddressList != null) {
            _statefulAddressControllerMediatorWidgetDelegate.onRefreshAddressList!();
          }
        }
      }
    }
  );

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulAddressControllerMediatorWidget(
      addressController: _addressController.controller,
      addressPageParameter: addressPageParameter,
      statefulAddressControllerMediatorWidgetDelegate: _statefulAddressControllerMediatorWidgetDelegate
    );
  }
}

class _AddressPageRestoration extends ExtendedMixableGetxPageRestoration with ModifyAddressPageRestorationMixin {
  final RouteCompletionCallback<bool?>? _onCompleteModifyAddress;

  _AddressPageRestoration({
    RouteCompletionCallback<bool?>? onCompleteModifyAddress
  }) : _onCompleteModifyAddress = onCompleteModifyAddress;

  @override
  // ignore: unnecessary_overrides
  void initState() {
    onCompleteModifyAddress = _onCompleteModifyAddress;
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

class AddressPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  final AddressPageParameter addressPageParameter;

  AddressPageGetPageBuilderAssistant({
    required this.addressPageParameter
  });

  @override
  GetPageBuilder get pageBuilder => (() => AddressPage(
    addressPageParameter: addressPageParameter
  ));

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(
    AddressPage(addressPageParameter: addressPageParameter)
  ));
}

mixin AddressPageRestorationMixin on MixableGetxPageRestoration {
  RouteCompletionCallback<bool?>? onCompleteSelectAddress;

  late AddressPageRestorableRouteFuture addressPageRestorableRouteFuture;

  @override
  void initState() {
    super.initState();
    addressPageRestorableRouteFuture = AddressPageRestorableRouteFuture(
      restorationId: restorationIdWithPageName('address-route'),
      onComplete: onCompleteSelectAddress
    );
  }

  @override
  void restoreState(Restorator restorator, RestorationBucket? oldBucket, bool initialRestore) {
    super.restoreState(restorator, oldBucket, initialRestore);
    addressPageRestorableRouteFuture.restoreState(restorator, oldBucket, initialRestore);
  }

  @override
  void dispose() {
    super.dispose();
    addressPageRestorableRouteFuture.dispose();
  }
}

class AddressPageRestorableRouteFuture extends GetRestorableRouteFuture {
  final RouteCompletionCallback<bool?>? onComplete;

  late RestorableRouteFuture<bool?> _pageRoute;

  AddressPageRestorableRouteFuture({
    required String restorationId,
    this.onComplete
  }) : super(restorationId: restorationId) {
    _pageRoute = RestorableRouteFuture<bool?>(
      onPresent: (NavigatorState navigator, Object? arguments) {
        return navigator.restorablePush(_pageRouteBuilder, arguments: arguments);
      },
      onComplete: onComplete
    );
  }

  static Route<bool?>? _getRoute([Object? arguments]) {
    if (arguments is! String) {
      throw MessageError(message: "Arguments must be a String");
    }
    AddressPageParameter addressPageParameter = arguments.toAddressPageParameter();
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        AddressPageGetPageBuilderAssistant(
          addressPageParameter: addressPageParameter
        )
      ),
    );
  }

  @pragma('vm:entry-point')
  static Route<bool?> _pageRouteBuilder(BuildContext context, Object? arguments) {
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

class _StatefulAddressControllerMediatorWidgetDelegate {
  void Function()? onRefreshAddressList;
}

class _StatefulAddressControllerMediatorWidget extends StatefulWidget {
  final AddressController addressController;
  final AddressPageParameter addressPageParameter;
  final _StatefulAddressControllerMediatorWidgetDelegate statefulAddressControllerMediatorWidgetDelegate;

  const _StatefulAddressControllerMediatorWidget({
    required this.addressController,
    required this.addressPageParameter,
    required this.statefulAddressControllerMediatorWidgetDelegate
  });

  @override
  State<_StatefulAddressControllerMediatorWidget> createState() => _StatefulAddressControllerMediatorWidgetState();
}

class _StatefulAddressControllerMediatorWidgetState extends State<_StatefulAddressControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _addressListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _addressListItemPagingControllerState;
  Address? _selectAddress;
  final AddressContainerInterceptingActionListItemControllerState _addressContainerInterceptingActionListItemControllerState = DefaultAddressContainerInterceptingActionListItemControllerState();
  LoadDataResult<List<Address>> _addressListLoadDataResult = NoLoadDataResult<List<Address>>();

  @override
  void initState() {
    super.initState();
    _addressListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.addressController.apiRequestManager,
    );
    _addressListItemPagingControllerState = PagingControllerState(
      pagingController: _addressListItemPagingController,
      isPagingControllerExist: false
    );
    _addressListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _addressListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _addressListItemPagingControllerState.isPagingControllerExist = true;
    widget.statefulAddressControllerMediatorWidgetDelegate.onRefreshAddressList = () => _addressListItemPagingController.refresh();
    if (widget.addressPageParameter.directToAddAddress) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _gotoModifyAddressPage();
      });
    }
  }

  void _gotoModifyAddressPage() {
    PageRestorationHelper.toModifyAddressPage(
      context,
      ModifyAddressPageParameter(
        modifyAddressPageParameterValue: null
      )
    );
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _addressListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    _addressListLoadDataResult = await widget.addressController.getAddressList(AddressListParameter());
    return _addressListLoadDataResult.map<PagingResult<ListItemControllerState>>((addressList) {
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          AddressContainerListItemControllerState(
            address: addressList,
            onUpdateState: () => setState(() {}),
            addressContainerStorageListItemControllerState: DefaultAddressContainerStorageListItemControllerState(),
            addressContainerInterceptingActionListItemControllerState: _addressContainerInterceptingActionListItemControllerState,
            onSelectAddress: (address) {
              setState(() {
                _selectAddress = address;
              });
            },
            onRemoveAddress: (address) => widget.addressController.removeAddress(address)
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
    widget.addressController.setAddressDelegate(
      AddressDelegate(
        onUnfocusAllWidget: () => FocusScope.of(context).unfocus(),
        onGetAddressInput: () => _selectAddress!,
        onAddressBack: () => Get.back(),
        onShowAddressRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onShowAddressRequestProcessFailedCallback: (e) async {
          if (e is DioError) {
            dynamic message = e.response?.data["meta"]["message"];
            if (message is String) {
              if (message.toLowerCase().contains(Constant.textLowerCaseAddressAlreadySetPrimary)) {
                Get.back(result: true);
                return;
              }
            }
          }
          DialogHelper.showFailedModalBottomDialogFromErrorProvider(
            context: context,
            errorProvider: Injector.locator<ErrorProvider>(),
            e: e
          );
        },
        onAddressRequestProcessSuccessCallback: () async => Get.back(result: true),
        onRemoveAddressRequestProcessSuccessCallback: (address) async {
          ToastHelper.showToast("${"Success remove address".tr}.");
          if (_addressContainerInterceptingActionListItemControllerState.removeAddress != null) {
            _addressContainerInterceptingActionListItemControllerState.removeAddress!(address);
            if (_addressListLoadDataResult.isSuccess) {
              List<Address> addressList = _addressListLoadDataResult.resultIfSuccess!;
              if (addressList.isEmpty) {
                _addressListItemPagingController.refresh();
              }
            }
          }
        }
      )
    );
    return WillPopScope(
      onWillPop: () async {
        Get.back(result: true);
        return false;
      },
      child: ModifiedScaffold(
        appBar: ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Address List".tr),
              Expanded(
                child: title ?? Container()
              ),
              NormalTextStyleForAppBar(
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                child: GestureDetector(
                  onTap: _gotoModifyAddressPage,
                  child: Text("Add Address".tr),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
                  pagingControllerState: _addressListItemPagingControllerState,
                  onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                    pagingControllerState: pagingControllerState!
                  ),
                  pullToRefresh: true
                ),
              ),
              Builder(
                builder: (context) {
                  bool isShowChooseAddressButton = false;
                  if (!_addressListLoadDataResult.isSuccess) {
                    isShowChooseAddressButton = true;
                  } else {
                    List<Address> addressList = _addressListLoadDataResult.resultIfSuccess!;
                    if (addressList.isEmpty) {
                      isShowChooseAddressButton = true;
                    } else {
                      if (_selectAddress == null) {
                        isShowChooseAddressButton = true;
                      }
                    }
                  }
                  if (isShowChooseAddressButton) {
                    return const SizedBox();
                  }
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedOutlineGradientButton(
                          onPressed: widget.addressController.updateCurrentSelectedAddress,
                          text: "Choose Address".tr,
                          outlineGradientButtonType: OutlineGradientButtonType.solid,
                          outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                        )
                      ]
                    ),
                  );
                }
              )
            ]
          )
        )
      ),
    );
  }
}

class AddressPageParameter {
  bool directToAddAddress;

  AddressPageParameter({
    required this.directToAddAddress
  });
}

extension AddressPageParameterExt on AddressPageParameter {
  String toJsonString() => StringUtil.encodeJson(
    () {
      return <String, dynamic>{
        "direct_to_add_address": directToAddAddress ? "1" : "0",
      };
    }()
  );
}

extension AddressPageParameterStringExt on String {
  AddressPageParameter toAddressPageParameter() {
    Map<String, dynamic> result = StringUtil.decodeJson(this);
    return AddressPageParameter(
      directToAddAddress: result["direct_to_add_address"] == "1"
    );
  }
}