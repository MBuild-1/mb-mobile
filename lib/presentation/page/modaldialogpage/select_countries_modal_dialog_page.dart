import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/select_countries_modal_dialog_controller.dart';
import '../../../domain/entity/address/country.dart';
import '../../../domain/entity/address/country_list_parameter.dart';
import '../../../domain/entity/address/country_paging_parameter.dart';
import '../../../domain/usecase/get_country_list_use_case.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/selectcountrieslistitemcontrollerstate/country_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/injector.dart';
import '../../../misc/inputdecoration/default_input_decoration.dart';
import '../../../misc/list_item_controller_state_helper.dart';
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

class SelectCountriesModalDialogPage extends ModalDialogPage<SelectCountriesModalDialogController> {
  SelectCountriesModalDialogController get selectCountriesModalDialogController => modalDialogController.controller;

  final Country? selectedCountry;

  SelectCountriesModalDialogPage({
    Key? key,
    required this.selectedCountry
  }) : super(key: key);

  @override
  SelectCountriesModalDialogController onCreateModalDialogController() {
    return SelectCountriesModalDialogController(
      controllerManager,
      Injector.locator<GetCountryListUseCase>()
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSelectCountriesControllerMediatorWidget(
      selectCountriesModalDialogController: selectCountriesModalDialogController,
      selectedCountry: selectedCountry
    );
  }
}

class _StatefulSelectCountriesControllerMediatorWidget extends StatefulWidget {
  final SelectCountriesModalDialogController selectCountriesModalDialogController;
  final Country? selectedCountry;

  const _StatefulSelectCountriesControllerMediatorWidget({
    required this.selectCountriesModalDialogController,
    required this.selectedCountry
  });

  @override
  State<_StatefulSelectCountriesControllerMediatorWidget> createState() => _StatefulCheckRatesForVariousCountriesControllerMediatorWidgetState();
}

class _StatefulCheckRatesForVariousCountriesControllerMediatorWidgetState extends State<_StatefulSelectCountriesControllerMediatorWidget> {
  late final ScrollController _selectCountriesScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _selectCountriesListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _selectCountriesListItemPagingControllerState;
  final TextEditingController _searchCountryTextEditingController = TextEditingController();
  Country? _selectedCountry;
  List<Country> _originalCountryList = [];
  List<Country> _currentCountryList = [];

  @override
  void initState() {
    super.initState();
    _selectCountriesScrollController = ScrollController();
    _selectCountriesListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.selectCountriesModalDialogController.apiRequestManager,
    );
    _selectCountriesListItemPagingControllerState = PagingControllerState(
      pagingController: _selectCountriesListItemPagingController,
      scrollController: _selectCountriesScrollController,
      isPagingControllerExist: false
    );
    _selectCountriesListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _selectCountriesListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _searchCountryTextEditingController.addListener(_listenSearchCountryTextEditing);
    _selectCountriesListItemPagingControllerState.isPagingControllerExist = true;
    _selectedCountry = widget.selectedCountry;
  }

  void _listenSearchCountryTextEditing() {
    _currentCountryList.clear();
    if (_searchCountryTextEditingController.text.trim().isEmpty) {
      _currentCountryList.addAll(_originalCountryList);
    } else {
      _currentCountryList.addAll(
        _originalCountryList.where(
          (country) => country.name.toLowerCase().contains(
            _searchCountryTextEditingController.text.toLowerCase()
          )
        )
      );
    }
    setState(() {});
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _selectCountriesListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    LoadDataResult<List<Country>> countryList = await widget.selectCountriesModalDialogController.getCountryList(
      CountryListParameter()
    );
    return countryList.map<PagingResult<ListItemControllerState>>((countryList) {
      _originalCountryList = List.of(countryList);
      _currentCountryList = List.of(countryList);
      return PagingDataResult<ListItemControllerState>(
        itemList: [
          CountryContainerListItemControllerState(
            country: _currentCountryList,
            onSelectCountry: (country) {
              setState(() {
                _selectedCountry = country;
              });
            },
            onGetSelectCountry: () => _selectedCountry,
            onUpdateState: () => setState(() {})
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: countryList.length
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
              Text("Select Country".tr),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 12),
          child: SizedBox(
            height: 40,
            child: ModifiedTextField(
              controller: _searchCountryTextEditingController,
              isError: false,
              textInputAction: TextInputAction.done,
              decoration: SearchTextFieldHelper.searchTextFieldStyle(
                context, DefaultInputDecoration(
                  hintText: "Search Country".tr,
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
            pagingControllerState: _selectCountriesListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            pullToRefresh: true
          ),
        ),
        if (_selectedCountry != null)
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedOutlineGradientButton(
                  onPressed: () => Get.back(result: _selectedCountry),
                  text: "Choose Country".tr,
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
    _searchCountryTextEditingController.dispose();
    super.dispose();
  }
}