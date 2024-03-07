import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/paging_controller_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../controller/modaldialogcontroller/search_filter_modal_dialog_controller.dart';
import '../../../domain/entity/search/searchsortby/multi_language_search_sort_by.dart';
import '../../../domain/entity/search/searchsortby/search_sort_by.dart';
import '../../../domain/entity/search/searchfilter/search_filter_group.dart';
import '../../../domain/entity/search/searchrelated/brand_search_related.dart';
import '../../../domain/entity/search/searchrelated/category_search_related.dart';
import '../../../domain/entity/search/searchrelated/province_search_related.dart';
import '../../../misc/constant.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../../../misc/controllerstate/listitemcontrollerstate/searchfilterlistitemcontrollerstate/search_filter_container_list_item_controller_state.dart';
import '../../../misc/controllerstate/paging_controller_state.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/multi_language_string.dart';
import '../../../misc/paging/modified_paging_controller.dart';
import '../../../misc/paging/pagingcontrollerstatepagedchildbuilderdelegate/list_item_paging_controller_state_paged_child_builder_delegate.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/paging/pagingresult/paging_result.dart';
import '../../../misc/searchfiltercontainermemberlistitemvalue/search_filter_group_list_item_value.dart';
import '../../../misc/searchfiltercontainermemberlistitemvalue/search_filter_number_range_list_item_value.dart';
import '../../../misc/toast_helper.dart';
import '../../widget/button/custombutton/sized_outline_gradient_button.dart';
import '../../widget/colorful_chip_tab_bar.dart';
import '../../widget/modified_paged_list_view.dart';
import '../../widget/modifiedappbar/modified_app_bar.dart';
import 'modal_dialog_page.dart';

class SearchFilterModalDialogPage extends ModalDialogPage<SearchFilterModalDialogController> {
  SearchFilterModalDialogController get searchFilterModalDialogController => modalDialogController.controller;

  final DefaultSearchFilterModalDialogPageParameter searchFilterModalDialogPageParameter;

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
      searchFilterModalDialogController: searchFilterModalDialogController,
      searchFilterModalDialogPageParameter: searchFilterModalDialogPageParameter
    );
  }
}

class _StatefulSearchFilterControllerMediatorWidget extends StatefulWidget {
  final SearchFilterModalDialogController searchFilterModalDialogController;
  final DefaultSearchFilterModalDialogPageParameter searchFilterModalDialogPageParameter;

  const _StatefulSearchFilterControllerMediatorWidget({
    required this.searchFilterModalDialogController,
    required this.searchFilterModalDialogPageParameter
  });

  @override
  State<_StatefulSearchFilterControllerMediatorWidget> createState() => _StatefulSearchFilterControllerMediatorWidgetState();
}

class _StatefulSearchFilterControllerMediatorWidgetState extends State<_StatefulSearchFilterControllerMediatorWidget> {
  late final ScrollController _searchFilterScrollController;
  late final ModifiedPagingController<int, ListItemControllerState> _searchFilterListItemPagingController;
  late final PagingControllerState<int, ListItemControllerState> _searchFilterListItemPagingControllerState;
  late CanSelectAndUnselectColorfulChipTabBarController _brandColorfulChipTabBarController;
  late CanSelectAndUnselectColorfulChipTabBarController _categoryColorfulChipTabBarController;
  late CanSelectAndUnselectColorfulChipTabBarController _provinceColorfulChipTabBarController;
  late CanSelectAndUnselectColorfulChipTabBarController _sortByColorfulChipTabBarController;
  final TextEditingController _priceMinTextEditingController = TextEditingController();
  final TextEditingController _priceMaxTextEditingController = TextEditingController();
  late List<BaseColorfulChipTabBarController> _searchFilterColorfulChipTabBarControllerList;
  final List<SearchSortBy> _searchSortByList = [
    MultiLanguageSearchSortBy(
      nameMultiLanguageString: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Newest",
        Constant.textInIdLanguageKey: "Terbaru"
      }),
      value: "nw"
    ),
    MultiLanguageSearchSortBy(
      nameMultiLanguageString: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Highest Price",
        Constant.textInIdLanguageKey: "Harga Tertinggi"
      }),
      value: "hp"
    ),
    MultiLanguageSearchSortBy(
      nameMultiLanguageString: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Lowest Price",
        Constant.textInIdLanguageKey: "Harga Terendah"
      }),
      value: "lp"
    ),
  ];

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

    _searchFilterColorfulChipTabBarControllerList = [];
    DefaultSearchFilterModalDialogPageParameter searchFilterModalDialogPageParameter = widget.searchFilterModalDialogPageParameter;

    // Sort By
    int sortByIndex = -1;
    if (searchFilterModalDialogPageParameter.lastSearchSortBy != null) {
      SearchSortBy? lastSearchSortBy = searchFilterModalDialogPageParameter.lastSearchSortBy!;
      for (int i = 0; i < _searchSortByList.length; i++) {
        SearchSortBy searchSortBy = _searchSortByList[i];
        if (searchSortBy.value == lastSearchSortBy.value) {
          sortByIndex = i;
          break;
        }
      }
    }
    _sortByColorfulChipTabBarController = CanSelectAndUnselectColorfulChipTabBarController(sortByIndex);
    _sortByColorfulChipTabBarController.addListener(_updateStateFromColorfulChip);
    _searchFilterColorfulChipTabBarControllerList.add(_sortByColorfulChipTabBarController);

    // Price Min
    _priceMinTextEditingController.text = searchFilterModalDialogPageParameter.lastPriceMin != null ? searchFilterModalDialogPageParameter.lastPriceMin!.toString() : "";

    // Price Max
    _priceMaxTextEditingController.text = searchFilterModalDialogPageParameter.lastPriceMax != null ? searchFilterModalDialogPageParameter.lastPriceMax!.toString() : "";

    // Brand
    int brandIndex = -1;
    if (searchFilterModalDialogPageParameter.lastBrandSearchRelated != null) {
      BrandSearchRelated lastBrandSearchRelated = searchFilterModalDialogPageParameter.lastBrandSearchRelated!;
      for (int i = 0; i < searchFilterModalDialogPageParameter.brandSearchRelatedList.length; i++) {
        BrandSearchRelated branchSearchRelated = searchFilterModalDialogPageParameter.brandSearchRelatedList[i];
        if (branchSearchRelated.searchRelatedParameter.key == lastBrandSearchRelated.searchRelatedParameter.key) {
          brandIndex = i;
          break;
        }
      }
    }
    _brandColorfulChipTabBarController = CanSelectAndUnselectColorfulChipTabBarController(brandIndex);
    _brandColorfulChipTabBarController.addListener(_updateStateFromColorfulChip);
    _searchFilterColorfulChipTabBarControllerList.add(_brandColorfulChipTabBarController);

    // Category
    int categoryIndex = -1;
    if (searchFilterModalDialogPageParameter.lastCategorySearchRelated != null) {
      CategorySearchRelated lastCategorySearchRelated = searchFilterModalDialogPageParameter.lastCategorySearchRelated!;
      for (int i = 0; i < searchFilterModalDialogPageParameter.categorySearchRelatedList.length; i++) {
        CategorySearchRelated categorySearchRelated = searchFilterModalDialogPageParameter.categorySearchRelatedList[i];
        if (categorySearchRelated.searchRelatedParameter.key == lastCategorySearchRelated.searchRelatedParameter.key) {
          categoryIndex = i;
          break;
        }
      }
    }
    _categoryColorfulChipTabBarController = CanSelectAndUnselectColorfulChipTabBarController(categoryIndex);
    _categoryColorfulChipTabBarController.addListener(_updateStateFromColorfulChip);
    _searchFilterColorfulChipTabBarControllerList.add(_categoryColorfulChipTabBarController);

    // Province
    int provinceIndex = -1;
    if (searchFilterModalDialogPageParameter.lastProvinceSearchRelated != null) {
      ProvinceSearchRelated lastProvinceSearchRelated = searchFilterModalDialogPageParameter.lastProvinceSearchRelated!;
      for (int i = 0; i < searchFilterModalDialogPageParameter.provinceSearchRelatedList.length; i++) {
        ProvinceSearchRelated provinceSearchRelated = searchFilterModalDialogPageParameter.provinceSearchRelatedList[i];
        if (provinceSearchRelated.searchRelatedParameter.key == lastProvinceSearchRelated.searchRelatedParameter.key) {
          provinceIndex = i;
          break;
        }
      }
    }
    _provinceColorfulChipTabBarController = CanSelectAndUnselectColorfulChipTabBarController(provinceIndex);
    _provinceColorfulChipTabBarController.addListener(_updateStateFromColorfulChip);
    _searchFilterColorfulChipTabBarControllerList.add(_provinceColorfulChipTabBarController);
  }

  void _updateStateFromColorfulChip() {
    setState(() {});
  }

  Future<LoadDataResult<PagingResult<ListItemControllerState>>> _searchFilterListItemPagingControllerStateListener(int pageKey) async {
    DefaultSearchFilterModalDialogPageParameter searchFilterModalDialogPageParameter = widget.searchFilterModalDialogPageParameter;
    return SuccessLoadDataResult<PagingResult<ListItemControllerState>>(
      value: PagingDataResult<ListItemControllerState>(
        itemList: [
          SearchFilterContainerListItemControllerState(
            onUpdateState: () => setState(() {}),
            searchFilterContainerMemberListItemValueList: [
              if (widget.searchFilterModalDialogPageParameter.showSortBased && _searchSortByList.isNotEmpty) ...[
                SearchFilterGroupListItemValue(
                  searchFilterGroup: SearchFilterGroup(
                    name: "Sort By".tr,
                    filterSupportSearchFilterList: _searchSortByList,
                  ),
                  onGetColorfulChipTabBarController: () => _sortByColorfulChipTabBarController
                ),
              ],
              if (widget.searchFilterModalDialogPageParameter.showPriceRange) ...[
                SearchFilterNumberRangeListItemValue(
                  range1Text: "Price From".tr,
                  range1InputText: "Input Price From".tr,
                  range1InputHintText: "Type Price From".tr,
                  range2Text: "Price To".tr,
                  range2InputText: "Input Price To".tr,
                  range2InputHintText: "Type Price To".tr,
                  onGetRange1TextEditingController: () => _priceMinTextEditingController,
                  onGetRange2TextEditingController: () => _priceMaxTextEditingController,
                  name: "Price Range".tr,
                ),
              ],
              if (searchFilterModalDialogPageParameter.brandSearchRelatedList.isNotEmpty) ...[
                SearchFilterGroupListItemValue(
                  searchFilterGroup: SearchFilterGroup(
                    name: "Brand".tr,
                    filterSupportSearchFilterList: searchFilterModalDialogPageParameter.brandSearchRelatedList,
                  ),
                  onGetColorfulChipTabBarController: () => _brandColorfulChipTabBarController
                ),
              ],
              if (searchFilterModalDialogPageParameter.categorySearchRelatedList.isNotEmpty) ...[
                SearchFilterGroupListItemValue(
                  searchFilterGroup: SearchFilterGroup(
                    name: "Category".tr,
                    filterSupportSearchFilterList: searchFilterModalDialogPageParameter.categorySearchRelatedList,
                  ),
                  onGetColorfulChipTabBarController: () => _categoryColorfulChipTabBarController
                ),
              ],
              if (searchFilterModalDialogPageParameter.provinceSearchRelatedList.isNotEmpty) ...[
                SearchFilterGroupListItemValue(
                  searchFilterGroup: SearchFilterGroup(
                    name: "Province".tr,
                    filterSupportSearchFilterList: searchFilterModalDialogPageParameter.provinceSearchRelatedList,
                  ),
                  onGetColorfulChipTabBarController: () => _provinceColorfulChipTabBarController
                )
              ],
            ],
            onGetColorfulChipTabBarColor: () => Theme.of(context).colorScheme.primary
          ),
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
            children: [
              Text("Filter".tr),
            ],
          ),
          primary: false,
        ),
        Flexible(
          child: SizedBox(
            child: ModifiedPagedListView<int, ListItemControllerState>.fromPagingControllerState(
              padding: EdgeInsets.zero,
              pagingControllerState: _searchFilterListItemPagingControllerState,
              onProvidePagedChildBuilderDelegate: (pagingControllerState) => ListItemPagingControllerStatePagedChildBuilderDelegate<int>(
                pagingControllerState: pagingControllerState!
              ),
              shrinkWrap: true,
            )
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: SizedOutlineGradientButton(
                  onPressed: () {
                    DefaultSearchFilterModalDialogPageParameter searchFilterModalDialogPageParameter = widget.searchFilterModalDialogPageParameter;
                    List<BrandSearchRelated> brandSearchRelatedList = searchFilterModalDialogPageParameter.brandSearchRelatedList;
                    List<CategorySearchRelated> categorySearchRelatedList = searchFilterModalDialogPageParameter.categorySearchRelatedList;
                    List<ProvinceSearchRelated> provinceSearchRelatedList = searchFilterModalDialogPageParameter.provinceSearchRelatedList;
                    int? priceMin = _priceMinTextEditingController.text.isNotEmptyString ? int.tryParse(_priceMinTextEditingController.text) : null;
                    int? priceMax = _priceMaxTextEditingController.text.isNotEmptyString ? int.tryParse(_priceMaxTextEditingController.text) : null;
                    if (priceMin != null && priceMax != null) {
                      if (priceMin > priceMax) {
                        // Exchange value between price min and max
                        priceMin = priceMin + priceMax;
                        priceMax = priceMin - priceMax;
                        priceMin = priceMin - priceMax;
                        ToastHelper.showToast(
                          MultiLanguageString({
                            Constant.textEnUsLanguageKey: "Because the \"Price From\" value is greater than the \"Price To\" value, the two values are swapped.",
                            Constant.textInIdLanguageKey: "Karena nilai \"Harga Dari\" lebih besar daripada nilai \"Harga Ke\", maka kedua nilai tersebut ditukar."
                          }).toEmptyStringNonNull
                        );
                      }
                    }
                    Get.back(
                      result: DefaultSearchFilterModalDialogPageResponse(
                        brandSearchRelated: _brandColorfulChipTabBarController.value > -1 ? brandSearchRelatedList[_brandColorfulChipTabBarController.value] : null,
                        categorySearchRelated: _categoryColorfulChipTabBarController.value > -1 ? categorySearchRelatedList[_categoryColorfulChipTabBarController.value] : null,
                        provinceSearchRelated: _provinceColorfulChipTabBarController.value > -1 ? provinceSearchRelatedList[_provinceColorfulChipTabBarController.value] : null,
                        searchSortBy: _sortByColorfulChipTabBarController.value > -1 ? _searchSortByList[_sortByColorfulChipTabBarController.value] : null,
                        priceMin: priceMin,
                        priceMax: priceMax
                      )
                    );
                  },
                  text: "Filter".tr,
                  outlineGradientButtonType: OutlineGradientButtonType.solid,
                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedOutlineGradientButton(
                  onPressed: () {
                    void iterateSearchFilterColorfulChipTabBarController(void Function(int, List<BaseColorfulChipTabBarController>) onIterate) {
                      int i = 0;
                      while (i < _searchFilterColorfulChipTabBarControllerList.length) {
                        onIterate(i, _searchFilterColorfulChipTabBarControllerList);
                        i++;
                      }
                    }
                    int selectedCount = 0;
                    iterateSearchFilterColorfulChipTabBarController(
                      (i, list) {
                        var searchFilterColorfulChipTabBarController = list[i];
                        if (searchFilterColorfulChipTabBarController is ColorfulChipTabBarController) {
                          selectedCount += searchFilterColorfulChipTabBarController.value > -1 ? 1 : 0;
                        } else if (searchFilterColorfulChipTabBarController is MultipleSelectionColorfulChipTabBarController) {
                          selectedCount += searchFilterColorfulChipTabBarController.value.isNotEmpty ? 1 : 0;
                        }
                      }
                    );
                    if (_priceMinTextEditingController.text.isNotEmptyString) {
                      selectedCount += 1;
                    }
                    if (_priceMaxTextEditingController.text.isNotEmptyString) {
                      selectedCount += 1;
                    }
                    return selectedCount > 0 ? () {
                      _priceMinTextEditingController.text = "";
                      _priceMaxTextEditingController.text = "";
                      setState(() {});
                      iterateSearchFilterColorfulChipTabBarController(
                        (i, list) {
                          var searchFilterColorfulChipTabBarController = list[i];
                          if (searchFilterColorfulChipTabBarController is ColorfulChipTabBarController) {
                            searchFilterColorfulChipTabBarController.value = -1;
                          } else if (searchFilterColorfulChipTabBarController is MultipleSelectionColorfulChipTabBarController) {
                            searchFilterColorfulChipTabBarController.value = [];
                          }
                        }
                      );
                    } : null;
                  }(),
                  text: "Reset".tr,
                  outlineGradientButtonType: OutlineGradientButtonType.outline,
                  outlineGradientButtonVariation: OutlineGradientButtonVariation.variation1,
                ),
              )
            ],
          )
        )
      ]
    );
  }

  @override
  void dispose() {
    int i = 0;
    while (i < _searchFilterColorfulChipTabBarControllerList.length) {
      _searchFilterColorfulChipTabBarControllerList[i].dispose();
      i++;
    }
    super.dispose();
  }
}

abstract class SearchFilterModalDialogPageParameter {}

class PreSearchFilterModalDialogPageParameter extends SearchFilterModalDialogPageParameter {
  final CategorySearchRelated? categorySearchRelated;

  PreSearchFilterModalDialogPageParameter({
    required this.categorySearchRelated
  });
}

class DefaultSearchFilterModalDialogPageParameter extends SearchFilterModalDialogPageParameter {
  final bool showSortBased;
  final bool showPriceRange;
  final List<BrandSearchRelated> brandSearchRelatedList;
  final List<CategorySearchRelated> categorySearchRelatedList;
  final List<ProvinceSearchRelated> provinceSearchRelatedList;
  final BrandSearchRelated? lastBrandSearchRelated;
  final CategorySearchRelated? lastCategorySearchRelated;
  final ProvinceSearchRelated? lastProvinceSearchRelated;
  final SearchSortBy? lastSearchSortBy;
  final int? lastPriceMin;
  final int? lastPriceMax;

  DefaultSearchFilterModalDialogPageParameter({
    this.showSortBased = true,
    this.showPriceRange = true,
    required this.brandSearchRelatedList,
    required this.categorySearchRelatedList,
    required this.provinceSearchRelatedList,
    required this.lastBrandSearchRelated,
    required this.lastCategorySearchRelated,
    required this.lastProvinceSearchRelated,
    required this.lastSearchSortBy,
    required this.lastPriceMin,
    required this.lastPriceMax
  });
}

abstract class SearchFilterModalDialogPageResponse {}

class PreSearchFilterModalDialogPageResponse extends SearchFilterModalDialogPageResponse {
  final CategorySearchRelated? categorySearchRelated;

  PreSearchFilterModalDialogPageResponse({
    required this.categorySearchRelated
  });
}

class DefaultSearchFilterModalDialogPageResponse extends SearchFilterModalDialogPageResponse {
  final BrandSearchRelated? brandSearchRelated;
  final CategorySearchRelated? categorySearchRelated;
  final ProvinceSearchRelated? provinceSearchRelated;
  final SearchSortBy? searchSortBy;
  final int? priceMin;
  final int? priceMax;

  DefaultSearchFilterModalDialogPageResponse({
    required this.brandSearchRelated,
    required this.categorySearchRelated,
    required this.provinceSearchRelated,
    required this.searchSortBy,
    required this.priceMin,
    required this.priceMax
  });
}