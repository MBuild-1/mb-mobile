import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/select_address_modal_dialog_controller.dart';
import '../../../controller/modaldialogcontroller/select_countries_modal_dialog_controller.dart';
import '../../../domain/entity/address/address.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/usecase/get_address_list_use_case.dart';
import '../../../domain/usecase/update_current_selected_address_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/load_data_result_dynamic_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/dialog_helper.dart';
import '../../../misc/entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../misc/errorprovider/error_provider.dart';
import '../../../misc/injector.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/on_observe_load_product_delegate.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/address_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/compound_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_dynamic_item_carousel_parametered_component_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../../widget/normal_text_style_for_appbar.dart';
import 'modal_dialog_page.dart';

class SelectAddressModalDialogPage extends ModalDialogPage<SelectAddressModalDialogController> {
  SelectAddressModalDialogController get selectAddressModalDialogController => modalDialogController.controller;

  final void Function(Address)? onAddressSelectedChanged;
  final void Function()? onGotoAddAddress;
  final Future<void> Function()? onLoadingAddress;
  final Future<void> Function(LoadDataResult<List<Address>>)? onFinishLoadingAddress;
  final SelectAddressModalDialogPageActionDelegate selectAddressModalDialogPageActionDelegate;

  SelectAddressModalDialogPage({
    Key? key,
    this.onAddressSelectedChanged,
    this.onGotoAddAddress,
    this.onLoadingAddress,
    this.onFinishLoadingAddress,
    required this.selectAddressModalDialogPageActionDelegate
  }) : super(key: key);

  @override
  SelectAddressModalDialogController onCreateModalDialogController() {
    return SelectAddressModalDialogController(
      controllerManager,
      Injector.locator<GetAddressListUseCase>(),
      Injector.locator<UpdateCurrentSelectedAddressUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSelectAddressControllerMediatorWidget(
      selectAddressModalDialogController: selectAddressModalDialogController,
      onAddressSelectedChanged: onAddressSelectedChanged,
      onGotoAddAddress: onGotoAddAddress,
      onLoadingAddress: onLoadingAddress,
      onFinishLoadingAddress: onFinishLoadingAddress,
      selectAddressModalDialogPageActionDelegate: selectAddressModalDialogPageActionDelegate
    );
  }
}

class _StatefulSelectAddressControllerMediatorWidget extends StatefulWidget {
  final SelectAddressModalDialogController selectAddressModalDialogController;
  final void Function(Address)? onAddressSelectedChanged;
  final void Function()? onGotoAddAddress;
  final Future<void> Function()? onLoadingAddress;
  final Future<void> Function(LoadDataResult<List<Address>>)? onFinishLoadingAddress;
  final SelectAddressModalDialogPageActionDelegate selectAddressModalDialogPageActionDelegate;

  const _StatefulSelectAddressControllerMediatorWidget({
    required this.selectAddressModalDialogController,
    required this.onAddressSelectedChanged,
    required this.onGotoAddAddress,
    required this.onLoadingAddress,
    required this.onFinishLoadingAddress,
    required this.selectAddressModalDialogPageActionDelegate
  });

  @override
  State<_StatefulSelectAddressControllerMediatorWidget> createState() => _StatefulSelectAddressControllerMediatorWidgetState();
}

class _StatefulSelectAddressControllerMediatorWidgetState extends State<_StatefulSelectAddressControllerMediatorWidget> {
  late final ScrollController _selectAddressScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _selectAddressListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _selectAddressListItemPagingControllerState;
  final List<BaseLoadDataResultDynamicListItemControllerState> _dynamicItemLoadDataResultDynamicListItemControllerStateList = [];
  Address? _currentAddress;
  void Function()? _onUpdateAddressSelectedState;

  @override
  void initState() {
    super.initState();
    _selectAddressScrollController = ScrollController();
    _selectAddressListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.selectAddressModalDialogController.apiRequestManager,
    );
    _selectAddressListItemPagingControllerState = PagingControllerState(
      pagingController: _selectAddressListItemPagingController,
      scrollController: _selectAddressScrollController,
      isPagingControllerExist: false
    );
    _selectAddressListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _selectAddressListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _selectAddressListItemPagingControllerState.isPagingControllerExist = true;
    widget.selectAddressModalDialogPageActionDelegate._onRefresh = _selectAddressListItemPagingController.refresh;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _selectAddressListItemPagingControllerStateListener(int pageKey) async {
    HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator componentEntityMediator = Injector.locator<HorizontalComponentEntityParameterizedEntityAndListItemControllerStateMediator>();
    HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter carouselParameterizedEntityMediator = HorizontalDynamicItemCarouselParameterizedEntityAndListItemControllerStateMediatorParameter(
      onSetState: () => setState(() {}),
      dynamicItemLoadDataResultDynamicListItemControllerStateList: _dynamicItemLoadDataResultDynamicListItemControllerStateList
    );
    ListItemControllerState addressListItemControllerState = componentEntityMediator.mapWithParameter(
      widget.selectAddressModalDialogController.getAddressListCarousel(),
      parameter: carouselParameterizedEntityMediator
    );
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
          BuilderListItemControllerState(
            buildListItemControllerState: () => CompoundListItemControllerState(
              listItemControllerState: [
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
                  paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
                    widgetSubstitution: (BuildContext context, int index) => Text(
                      "${"To make your shopping experience better, choose an address first".tr}."
                    )
                  ),
                ),
                VirtualSpacingListItemControllerState(height: 12),
                addressListItemControllerState,
                VirtualSpacingListItemControllerState(height: 12),
              ]
            )
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    OnObserveLoadProductDelegateFactory onObserveLoadProductDelegateFactory = Injector.locator<OnObserveLoadProductDelegateFactory>()
      ..onInjectLoadAddressCarouselParameterizedEntity = (
        () => CompoundParameterizedEntityAndListItemControllerStateMediatorParameter(
          parameterizedEntityAndListItemControllerStateMediatorParameterList: [
            AddressDelegateParameterizedEntityAndListItemControllerStateMediatorParameter(
              onSelectAddressFromDelegate: (address, onUpdateAddressSelectedState) {
                _onUpdateAddressSelectedState = onUpdateAddressSelectedState;
                widget.selectAddressModalDialogController.selectCurrentAddress(address);
              },
            )
          ]
        )
      );
    widget.selectAddressModalDialogController.setSelectAddressDelegate(
      SelectAddressDelegate(
        onObserveLoadProductDelegate: onObserveLoadProductDelegateFactory.generateOnObserveLoadProductDelegate(),
        onSelectAddressBack: () => Get.back(),
        onShowSelectAddressRequestProcessLoadingCallback: () async => DialogHelper.showLoadingDialog(context),
        onSelectAddressRequestProcessSuccessCallback: (address) async {
          setState(() {
            if (_onUpdateAddressSelectedState != null) {
              _onUpdateAddressSelectedState!();
            }
            _currentAddress = address;
          });
          if (widget.onAddressSelectedChanged != null) {
            widget.onAddressSelectedChanged!(address);
          }
        },
        onShowSelectAddressRequestProcessFailedCallback: (e) async {
          if (e is DioError) {
            dynamic message = e.response?.data["meta"]["message"];
            if (message is String) {
              if (message.toLowerCase().contains(Constant.textLowerCaseAddressAlreadySetPrimary)) {
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
        onGotoAddAddress: widget.onGotoAddAddress,
        onAddressListRequestProcessLoadingCallback: widget.onLoadingAddress,
        onAddressListRequestProcessFinishLoadingCallback: widget.onFinishLoadingAddress
      )
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    String text = "${"Where do you want it sent".tr}?";
                    return Tooltip(
                      message: text,
                      child: Text(
                        text,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }
                )
              ),
              const SizedBox(width: 10),
              NormalTextStyleForAppBar(
                style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                child: GestureDetector(
                  onTap: widget.onGotoAddAddress,
                  child: Text("Add Address".tr),
                ),
              ),
            ],
          ),
          primary: false,
        ),
        SizedBox(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            padding: EdgeInsets.zero,
            pagingControllerState: _selectAddressListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            shrinkWrap: true,
          )
        )
      ]
    );
  }

  @override
  void dispose() {
    widget.selectAddressModalDialogPageActionDelegate._onRefresh = null;
    _selectAddressListItemPagingController.dispose();
    _selectAddressScrollController.dispose();
    super.dispose();
  }
}

class SelectAddressModalDialogPageActionDelegate {
  void Function()? _onRefresh;

  void Function() get refresh => () {
    if (_onRefresh != null) {
      _onRefresh!();
    }
  };
}