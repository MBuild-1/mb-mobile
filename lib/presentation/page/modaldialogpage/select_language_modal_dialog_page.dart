import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/select_language_modal_dialog_controller.dart';
import '../../../domain/entity/selectlanguage/select_language.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/selectlanguagelistitemcontrollerstate/select_language_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/getextended/get_extended.dart';
import '../../../misc/language_helper.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../../misc/selected_language_based_index_value_helper.dart';
import '../../../misc/selected_language_helper.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class SelectLanguageModalDialogPage extends ModalDialogPage<SelectLanguageModalDialogController> {
  SelectLanguageModalDialogController get selectLanguageModalDialogController => modalDialogController.controller;

  SelectLanguageModalDialogPage({super.key});

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSelectLanguageControllerMediatorWidget(
      selectLanguageModalDialogController: selectLanguageModalDialogController
    );
  }

  @override
  SelectLanguageModalDialogController onCreateModalDialogController() {
    return SelectLanguageModalDialogController(
      controllerManager
    );
  }
}

class _StatefulSelectLanguageControllerMediatorWidget extends StatefulWidget {
  final SelectLanguageModalDialogController selectLanguageModalDialogController;

  const _StatefulSelectLanguageControllerMediatorWidget({
    required this.selectLanguageModalDialogController
  });

  @override
  State<_StatefulSelectLanguageControllerMediatorWidget> createState() => _StatefulSelectLanguageControllerMediatorWidgetState();
}

class _StatefulSelectLanguageControllerMediatorWidgetState extends State<_StatefulSelectLanguageControllerMediatorWidget> {
  late final ScrollController _selectLanguageScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _selectLanguageListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _selectLanguageListItemPagingControllerState;

  SelectLanguage? _selectedLanguage;

  @override
  void initState() {
    super.initState();
    String selectedLanguageLocaleString = LanguageHelper.getSelectedLanguage().result;
    Iterable<SelectLanguage> selectLanguageIterable = LanguageHelper.selectLanguageList.where(
      (value) => value.localeString == selectedLanguageLocaleString
    );
    if (selectLanguageIterable.isNotEmpty) {
      _selectedLanguage = selectLanguageIterable.first;
    }
    _selectLanguageScrollController = ScrollController();
    _selectLanguageListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.selectLanguageModalDialogController.apiRequestManager,
    );
    _selectLanguageListItemPagingControllerState = PagingControllerState(
      pagingController: _selectLanguageListItemPagingController,
      scrollController: _selectLanguageScrollController,
      isPagingControllerExist: false
    );
    _selectLanguageListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _selectLanguageListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _selectLanguageListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _selectLanguageListItemPagingControllerStateListener(int pageKey) async {
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        page: 1,
        totalPage: 1,
        totalItem: LanguageHelper.selectLanguageList.length,
        itemList: [
          SelectLanguageContainerListItemControllerState(
            selectLanguageList: LanguageHelper.selectLanguageList,
            onGetSelectLanguage: () => _selectedLanguage,
            onSelectLanguage: (selectLanguage) => _selectedLanguage = selectLanguage,
            onUpdateState: () => setState(() {})
          )
        ]
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.selectLanguageModalDialogController.setSelectLanguageDelegate(
      SelectLanguageDelegate(
        onGetSelectedLanguage: () => _selectedLanguage,
        onSaveSelectedLanguage: (selectedLanguage) async {
          await SelectedLanguageHelper.saveSelectedLanguage(selectedLanguage.localeString).future();
          await SelectedLanguageBasedIndexValueHelper.saveSelectedLanguageBasedIndexValue(selectedLanguage.indexValue).future();
          Get.back(result: 1);
        }
      )
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: [
              Text("Select Language".tr),
            ],
          ),
          primary: false,
        ),
        Flexible(
          child: SizedBox(
            child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              padding: EdgeInsets.zero,
              pagingControllerState: _selectLanguageListItemPagingControllerState,
              onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                pagingControllerState: pagingControllerState!
              ),
              shrinkWrap: true,
            )
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: SizedOutlineGradientButton(
            onPressed: _selectedLanguage != null
              ? () => widget.selectLanguageModalDialogController.saveSelectedLanguage(_selectedLanguage)
              : null,
            text: "Select Language".tr,
            outlineGradientButtonType: OutlineGradientButtonType.solid,
            outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
          )
        )
      ]
    );
  }
}