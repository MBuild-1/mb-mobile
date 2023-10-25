import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/select_value_modal_dialog_controller.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/selectvaluelistitemcontrollerstate/select_value_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import '../../widget/selectvalue/select_value_item.dart';
import 'modal_dialog_page.dart';

class SelectValueModalDialogPage<T> extends ModalDialogPage<SelectValueModalDialogController> {
  SelectValueModalDialogController get selectValueModalDialogController => modalDialogController.controller;

  final SelectValueModalDialogPageParameter<T> selectValueModalDialogPageParameter;

  SelectValueModalDialogPage({
    Key? key,
    required this.selectValueModalDialogPageParameter
  }) : super(key: key);

  @override
  SelectValueModalDialogController onCreateModalDialogController() {
    return SelectValueModalDialogController(
      controllerManager
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSelectValueControllerMediatorWidget<T>(
      selectValueModalDialogPageParameter: selectValueModalDialogPageParameter,
      selectValueModalDialogController: selectValueModalDialogController
    );
  }
}

class _StatefulSelectValueControllerMediatorWidget<T> extends StatefulWidget {
  final SelectValueModalDialogPageParameter<T> selectValueModalDialogPageParameter;
  final SelectValueModalDialogController selectValueModalDialogController;

  const _StatefulSelectValueControllerMediatorWidget({
    required this.selectValueModalDialogPageParameter,
    required this.selectValueModalDialogController
  });

  @override
  State<_StatefulSelectValueControllerMediatorWidget> createState() => _StatefulSelectValueControllerMediatorWidgetState<T>();
}

class _StatefulSelectValueControllerMediatorWidgetState<T> extends State<_StatefulSelectValueControllerMediatorWidget<T>> {
  late final ScrollController _selectValueScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _selectValueListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _selectValueListItemPagingControllerState;
  T? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectValueScrollController = ScrollController();
    _selectValueListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.selectValueModalDialogController.apiRequestManager,
    );
    _selectValueListItemPagingControllerState = PagingControllerState(
      pagingController: _selectValueListItemPagingController,
      scrollController: _selectValueScrollController,
      isPagingControllerExist: false
    );
    _selectValueListItemPagingControllerState.pagingController.addPageRequestListenerWithItemListForLoadDataResult(
      listener: _selectValueListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _selectValueListItemPagingControllerState.isPagingControllerExist = true;
    _selectedValue = widget.selectValueModalDialogPageParameter.selectedValue;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _selectValueListItemPagingControllerStateListener(int pageKey, List<ListItemControllerState>? listItemControllerStateList) async {
    SelectValueModalDialogPageParameter<T> selectValueModalDialogPageParameter = widget.selectValueModalDialogPageParameter;
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
          SelectValueContainerListItemControllerState(
            valueList: selectValueModalDialogPageParameter.valueList.map<dynamic>((value) {
              return value as dynamic;
            }).toList(),
            onSelectValue: (value) {
              setState(() {
                _selectedValue = value as T;
              });
            },
            onGetSelectValue: () => _selectedValue as dynamic,
            onConvertToStringForItemText: (value) {
              if (selectValueModalDialogPageParameter.onConvertToStringForItemText == null) {
                return "";
              }
              return selectValueModalDialogPageParameter.onConvertToStringForItemText!(value as T);
            },
            onConvertToStringForComparing: (value) {
              if (selectValueModalDialogPageParameter.onConvertToStringForItemText == null) {
                return "";
              }
              return selectValueModalDialogPageParameter.onConvertToStringForComparing!(value as T?);
            },
          )
        ],
        page: 1,
        totalPage: 1,
        totalItem: selectValueModalDialogPageParameter.valueList.length
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    SelectValueModalDialogPageParameter selectValueModalDialogPageParameter = widget.selectValueModalDialogPageParameter;
    return Column(
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text(selectValueModalDialogPageParameter.title),
            ],
          ),
        ),
        Expanded(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            pagingControllerState: _selectValueListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            pullToRefresh: true
          ),
        ),
        if (_selectedValue != null)
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedOutlineGradientButton(
                  onPressed: () => Get.back(result: _selectedValue),
                  text: selectValueModalDialogPageParameter.title,
                  outlineGradientButtonType: OutlineGradientButtonType.solid,
                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                )
              ]
            ),
          )
      ]
    );
  }
}

class SelectValueModalDialogPageParameter<T> {
  List<T> valueList;
  T? selectedValue;
  String title;
  OnConvertToStringForItemText<T>? onConvertToStringForItemText;
  OnConvertToStringForComparing<T?>? onConvertToStringForComparing;

  SelectValueModalDialogPageParameter({
    required this.valueList,
    required this.title,
    required this.selectedValue,
    required this.onConvertToStringForItemText,
    required this.onConvertToStringForComparing
  });
}