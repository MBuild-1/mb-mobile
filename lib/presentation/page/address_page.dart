import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../controller/address_controller.dart';
import '../../domain/entity/address/address.dart';
import '../../domain/entity/address/address_list_parameter.dart';
import '../../domain/usecase/get_address_list_use_case.dart';
import '../../domain/usecase/get_address_paging_use_case.dart';
import '../../domain/usecase/update_current_selected_address_use_case.dart';
import '../../misc/controllerstate/listitemcontrollerstate/addresslistitemcontrollerstate/address_container_list_item_controller_state.dart';
import '../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../misc/controllerstate/paging_controller_state.dart';
import '../../misc/dialog_helper.dart';
import '../../misc/errorprovider/error_provider.dart';
import '../../misc/getextended/get_extended.dart';
import '../../misc/getextended/get_restorable_route_future.dart';
import '../../misc/injector.dart';
import '../../misc/load_data_result.dart';
import '../../misc/manager/controller_manager.dart';
import '../../misc/paging/modified_paging_controller.dart';
import '../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/paging/pagingresult/paging_result.dart';
import '../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../widget/modified_paged_list_view.dart';
import '../widget/modifiedappbar/modified_app_bar.dart';
import 'getx_page.dart';

class AddressPage extends RestorableGetxPage<_AddressPageRestoration> {
  late final ControllerMember<AddressController> _addressController = ControllerMember<AddressController>().addToControllerManager(controllerManager);

  AddressPage({
    Key? key
  }) : super(key: key, pageRestorationId: () => "address-page");

  @override
  void onSetController() {
    _addressController.controller = GetExtended.put<AddressController>(
      AddressController(
        controllerManager,
        Injector.locator<GetAddressPagingUseCase>(),
        Injector.locator<GetAddressListUseCase>(),
        Injector.locator<UpdateCurrentSelectedAddressUseCase>()
      ), tag: pageName
    );
  }

  @override
  _AddressPageRestoration createPageRestoration() => _AddressPageRestoration();

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulAddressControllerMediatorWidget(
      addressController: _addressController.controller
    );
  }
}

class _AddressPageRestoration extends MixableGetxPageRestoration {
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

class AddressPageGetPageBuilderAssistant extends GetPageBuilderAssistant {
  AddressPageGetPageBuilderAssistant();

  @override
  GetPageBuilder get pageBuilder => (() => AddressPage());

  @override
  GetPageBuilder get pageWithOuterGetxBuilder => (() => GetxPageBuilder.buildRestorableGetxPage(AddressPage()));
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
    return GetExtended.toWithGetPageRouteReturnValue<bool?>(
      GetxPageBuilder.buildRestorableGetxPageBuilder(
        AddressPageGetPageBuilderAssistant()
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

class _StatefulAddressControllerMediatorWidget extends StatefulWidget {
  final AddressController addressController;

  const _StatefulAddressControllerMediatorWidget({
    required this.addressController
  });

  @override
  State<_StatefulAddressControllerMediatorWidget> createState() => _StatefulAddressControllerMediatorWidgetState();
}

class _StatefulAddressControllerMediatorWidgetState extends State<_StatefulAddressControllerMediatorWidget> {
  late final ModifiedPagingController<int, ListItemControllerState> _addressListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _addressListItemPagingControllerState;
  Address? _selectAddress;

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
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _addressListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    LoadDataResult<List<Address>> addressListLoadDataResult = await widget.addressController.getAddressList(AddressListParameter());
    return addressListLoadDataResult.map<PagingResult<ListItemControllerState>>((addressList) {
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          AddressContainerListItemControllerState(
            address: addressList,
            onUpdateState: () => setState(() {}),
            onSelectAddress: (address) {
              setState(() {
                _selectAddress = address;
              });
            }
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
        onShowAddressRequestProcessFailedCallback: (e) async => DialogHelper.showFailedModalBottomDialogFromErrorProvider(
          context: context,
          errorProvider: Injector.locator<ErrorProvider>(),
          e: e
        ),
        onAddressRequestProcessSuccessCallback: () async => Get.back(result: true),
      )
    );
    return Scaffold(
      appBar: ModifiedAppBar(
        titleInterceptor: (context, title) => Row(
          children: [
            Text("Address".tr),
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
            if (_selectAddress != null)
              Container(
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
              )
          ]
        )
      )
    );
  }
}