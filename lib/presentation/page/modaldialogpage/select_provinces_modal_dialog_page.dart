import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/select_provinces_modal_dialog_controller.dart';
import '../../../domain/entity/province/province_map.dart';
import '../../../domain/entity/province/province_map_list_parameter.dart';
import '../../../domain/usecase/get_province_map_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/selectprovinceslistitemcontrollerstate/province_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/injector.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../../misc/search_text_field_helper.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modified_text_field.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class SelectProvincesModalDialogPage extends ModalDialogPage<SelectProvincesModalDialogController> {
  SelectProvincesModalDialogController get selectProvincesModalDialogController => modalDialogController.controller;

  final ProvinceMap? selectedProvince;

  SelectProvincesModalDialogPage({
    Key? key,
    required this.selectedProvince
  }) : super(key: key);

  @override
  SelectProvincesModalDialogController onCreateModalDialogController() {
    return SelectProvincesModalDialogController(
      controllerManager,
      Injector.locator<GetProvinceMapUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSelectProvincesControllerMediatorWidget(
      selectProvincesModalDialogController: selectProvincesModalDialogController,
      selectedProvince: selectedProvince
    );
  }
}

class _StatefulSelectProvincesControllerMediatorWidget extends StatefulWidget {
  final SelectProvincesModalDialogController selectProvincesModalDialogController;
  final ProvinceMap? selectedProvince;

  const _StatefulSelectProvincesControllerMediatorWidget({
    required this.selectProvincesModalDialogController,
    required this.selectedProvince
  });

  @override
  State<_StatefulSelectProvincesControllerMediatorWidget> createState() => _StatefulCheckRatesForVariousProvincesControllerMediatorWidgetState();
}

class _StatefulCheckRatesForVariousProvincesControllerMediatorWidgetState extends State<_StatefulSelectProvincesControllerMediatorWidget> {
  late final ScrollController _selectProvincesScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _selectProvincesListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _selectProvincesListItemPagingControllerState;
  final TextEditingController _searchProvinceTextEditingController = TextEditingController();
  ProvinceMap? _selectedProvince;
  List<ProvinceMap> _originalProvinceList = [];
  List<ProvinceMap> _currentProvinceList = [];

  @override
  void initState() {
    super.initState();
    _selectProvincesScrollController = ScrollController();
    _selectProvincesListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.selectProvincesModalDialogController.apiRequestManager,
    );
    _selectProvincesListItemPagingControllerState = PagingControllerState(
      pagingController: _selectProvincesListItemPagingController,
      scrollController: _selectProvincesScrollController,
      isPagingControllerExist: false
    );
    _selectProvincesListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _selectProvincesListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _searchProvinceTextEditingController.addListener(_listenSearchProvinceTextEditing);
    _selectProvincesListItemPagingControllerState.isPagingControllerExist = true;
    _selectedProvince = widget.selectedProvince;
  }

  void _listenSearchProvinceTextEditing() {
    _currentProvinceList.clear();
    if (_searchProvinceTextEditingController.text.trim().isEmpty) {
      _currentProvinceList.addAll(_originalProvinceList);
    } else {
      _currentProvinceList.addAll(
        _originalProvinceList.where(
          (province) => province.name.toLowerCase().contains(
            _searchProvinceTextEditingController.text.toLowerCase()
          )
        )
      );
    }
    setState(() {});
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _selectProvincesListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    LoadDataResult<List<ProvinceMap>> provinceList = await widget.selectProvincesModalDialogController.getProvinceList(
      ProvinceMapListParameter()
    );
    return provinceList.map<PagingResult<ListItemControllerState>>((provinceList) {
      _originalProvinceList = List.of(provinceList);
      _currentProvinceList = List.of(provinceList);
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          ProvinceContainerListItemControllerState(
            province: _currentProvinceList,
            onSelectProvince: (province) {
              setState(() {
                _selectedProvince = province;
              });
            },
            onGetSelectProvince: () => _selectedProvince,
            onUpdateState: () => setState(() {})
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: provinceList.length
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Select Province".tr),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 12),
          child: SizedBox(
            height: 40,
            child: ModifiedTextField(
              controller: _searchProvinceTextEditingController,
              isError: false,
              textInputAction: TextInputAction.done,
              decoration: SearchTextFieldHelper.searchTextFieldStyle(
                context, DefaultInputDecoration(
                  hintText: "Search Province".tr,
                  filled: true,
                  fillColor: Colors.transparent,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
                )
              )
            ),
          ),
        ),
        Expanded(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            pagingControllerState: _selectProvincesListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            pullToRefresh: true
          ),
        ),
        if (_selectedProvince != null)
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedOutlineGradientButton(
                  onPressed: () => Get.back(result: _selectedProvince),
                  text: "Choose Province".tr,
                  outlineGradientButtonType: OutlineGradientButtonType.solid,
                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                )
              ]
            ),
          )
      ]
    );
  }

  @override
  void dispose() {
    _searchProvinceTextEditingController.dispose();
    super.dispose();
  }
}