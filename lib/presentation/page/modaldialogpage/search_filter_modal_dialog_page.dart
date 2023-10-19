import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';

import '../../../controller/modaldialogcontroller/search_filter_modal_dialog_controller.dart';
import '../../../domain/entity/search/searchrelated/brand_search_related.dart';
import '../../../domain/entity/search/searchrelated/category_search_related.dart';
import '../../../domain/entity/search/searchrelated/province_search_related.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class SearchFilterModalDialogPage extends ModalDialogPage<SearchFilterModalDialogController> {
  SearchFilterModalDialogController get searchFilterModalDialogController => modalDialogController.controller;

  final SearchFilterModalDialogPageParameter searchFilterModalDialogPageParameter;

  SearchFilterModalDialogPage({
    Key? key,
    required this.searchFilterModalDialogPageParameter
  }) : super(key: key);

  @override
  SearchFilterModalDialogController onCreateModalDialogController() {
    return SearchFilterModalDialogController(
      controllerManager
    );
  }

  @override
  Widget buildPage(BuildContext context) {
    return _StatefulSearchFilterControllerMediatorWidget(
      searchFilterModalDialogController: searchFilterModalDialogController
    );
  }
}

class _StatefulSearchFilterControllerMediatorWidget extends StatefulWidget {
  final SearchFilterModalDialogController searchFilterModalDialogController;

  const _StatefulSearchFilterControllerMediatorWidget({
    required this.searchFilterModalDialogController
  });

  @override
  State<_StatefulSearchFilterControllerMediatorWidget> createState() => _StatefulSearchFilterControllerMediatorWidgetState();
}

class _StatefulSearchFilterControllerMediatorWidgetState extends State<_StatefulSearchFilterControllerMediatorWidget> {
  late final ScrollController _searchFilterScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _searchFilterListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _searchFilterListItemPagingControllerState;

  @override
  void initState() {
    super.initState();
    _searchFilterScrollController = ScrollController();
    _searchFilterListItemPagingController = ModifiedPagingController<int, ListItemControllerState>(
      firstPageKey: 1,
      // ignore: invalid_use_of_protected_member
      apiRequestManager: widget.searchFilterModalDialogController.apiRequestManager,
    );
    _searchFilterListItemPagingControllerState = PagingControllerState(
      pagingController: _searchFilterListItemPagingController,
      scrollController: _searchFilterScrollController,
      isPagingControllerExist: false
    );
    _searchFilterListItemPagingControllerState.pagingController.addPageRequestListenerForLoadDataResult(
      listener: _searchFilterListItemPagingControllerStateListener,
      onPageKeyNext: (pageKey) => pageKey + 1
    );
    _searchFilterListItemPagingControllerState.isPagingControllerExist = true;
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _searchFilterListItemPagingControllerStateListener(int pageKey) async {
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
          PaddingContainerListItemControllerState(
            padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
            paddingChildListItemControllerState: WidgetSubstitutionListItemControllerState(
              widgetSubstitution: (BuildContext context, int index) => Text(
                "${"This is search filter".tr}."
              )
            ),
          ),
          VirtualSpacingListItemControllerState(height: 12),
        ],
        page: 1,
        totalPage: 1,
        totalItem: 1
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ModifiedAppBar(
          titleInterceptor: (context, title) => Row(
            children: const [
              Text("Filter"),
            ],
          ),
          primary: false,
        ),
        SizedBox(
          child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
            padding: EdgeInsets.zero,
            pagingControllerState: _searchFilterListItemPagingControllerState,
            onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
              pagingControllerState: pagingControllerState!
            ),
            shrinkWrap: true,
          )
        )
      ]
    );
  }
}

class SearchFilterModalDialogPageParameter {
  final List<BrandSearchRelated> brandSearchRelatedList;
  final List<CategorySearchRelated> categorySearchRelatedList;
  final List<ProvinceSearchRelated> provinceSearchRelatedList;

  const SearchFilterModalDialogPageParameter({
    required this.brandSearchRelatedList,
    required this.categorySearchRelatedList,
    required this.provinceSearchRelatedList
  });
}

class SearchFilterModalDialogPageResponse {
  final BrandSearchRelated brandSearchRelated;
  final CategorySearchRelated categorySearchRelated;
  final ProvinceSearchRelated provinceSearchRelated;

  const SearchFilterModalDialogPageResponse({
    required this.brandSearchRelated,
    required this.categorySearchRelated,
    required this.provinceSearchRelated
  });
}