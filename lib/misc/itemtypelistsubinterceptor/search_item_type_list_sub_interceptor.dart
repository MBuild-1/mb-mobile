import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/search/search_history_response.dart';
import '../../domain/entity/search/search_last_seen_history_response.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/entity/search/searchfilter/support_search_filter.dart';
import '../../domain/entity/search/searchlastseenhistory/search_last_seen_history.dart';
import '../../domain/entity/search/searchrelated/brand_search_related.dart';
import '../../domain/entity/search/searchrelated/category_search_related.dart';
import '../../domain/entity/search/searchrelated/product_search_related.dart';
import '../../presentation/page/modaldialogpage/search_filter_modal_dialog_page.dart';
import '../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../presentation/widget/tap_area.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/builder_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/colorful_chip_tab_bar_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/searchlistitemcontrollerstate/search_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/searchlistitemcontrollerstate/typing_search_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/widget_substitution_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
import '../multi_language_string.dart';
import '../typedef.dart';
import '../typingsearchlistitemclick/brand_typing_search_list_item_click.dart';
import '../typingsearchlistitemclick/category_typing_search_list_item_click.dart';
import '../typingsearchlistitemclick/default_typing_search_list_item_click.dart';
import '../typingsearchlistitemclick/history_typing_search_list_item_click.dart';
import '../typingsearchlistitemclick/last_seen_history_typing_search_list_item_click.dart';
import '../typingsearchlistitemclick/product_typing_search_list_item_click.dart';
import 'item_type_list_sub_interceptor.dart';
import 'verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';

class SearchItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  SearchItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is SearchContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      List<ListItemControllerState> wishlistListItemControllerStateList = oldItemType.productEntryList.map<ListItemControllerState>(
        (productEntry) {
          ListItemControllerState? currentListItemControllerState = VerticalProductListItemControllerState(
            productAppearanceData: productEntry,
            onRemoveWishlist: (productAppearanceData) => oldItemType.onRemoveWishlistWithProductAppearanceData(productAppearanceData),
            onAddWishlist: (productAppearanceData) => oldItemType.onAddWishlistWithProductAppearanceData(productAppearanceData),
            onAddCart: oldItemType.onAddProductCart,
          );
          return currentListItemControllerState;
        }
      ).toList();
      VerticalGridPaddingContentSubInterceptorSupportListItemControllerState verticalGridPaddingContentSubInterceptorSupportListItemControllerState = VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
        childListItemControllerStateList: wishlistListItemControllerStateList
      );
      SearchFilterModalDialogPageResponse? searchFilterModalDialogPageResponse = oldItemType.searchFilterModalDialogPageResponse();
      bool hasSearchFilter = searchFilterModalDialogPageResponse != null;
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(
          CompoundListItemControllerState(
            listItemControllerState: [
              VirtualSpacingListItemControllerState(
                height: Constant.paddingListItem
              ),
              TitleAndDescriptionListItemControllerState(
                padding: EdgeInsets.symmetric(
                  horizontal: Constant.paddingListItem
                ),
                title: MultiLanguageString({
                  Constant.textEnUsLanguageKey: "Search Result",
                  Constant.textInIdLanguageKey: "Hasil Pencarian"
                }).toEmptyStringNonNull,
                description: MultiLanguageString({
                  Constant.textEnUsLanguageKey: "There are ${oldItemType.searchResultCount} search result${hasSearchFilter ? " with filter:" : "."}",
                  Constant.textInIdLanguageKey: "Terdapat ${oldItemType.searchResultCount} hasil pencarian${hasSearchFilter ? " dengan filter:" : "."}"
                }).toEmptyStringNonNull,
                verticalSpace: 0.3.h,
              ),
              if (hasSearchFilter) ...[
                BuilderListItemControllerState(
                  buildListItemControllerState: () {
                    List<List<dynamic>> onCheckResponseList = [
                      [
                        () => searchFilterModalDialogPageResponse.brandSearchRelated != null,
                        () => searchFilterModalDialogPageResponse.brandSearchRelated,
                        () => "Brand".tr,
                        (value) => value
                      ],
                      [
                        () => searchFilterModalDialogPageResponse.categorySearchRelated != null,
                        () => searchFilterModalDialogPageResponse.categorySearchRelated,
                        () => "Category".tr,
                        (value) => value
                      ],
                      [
                        () => searchFilterModalDialogPageResponse.provinceSearchRelated != null,
                        () => searchFilterModalDialogPageResponse.provinceSearchRelated,
                        () => "Province".tr,
                        (value) => value
                      ],
                      [
                        () => searchFilterModalDialogPageResponse.searchSortBy != null,
                        () => searchFilterModalDialogPageResponse.searchSortBy,
                        () => "Sort By".tr,
                        (value) => value
                      ],
                      [
                        () => searchFilterModalDialogPageResponse.priceMin != null,
                        () => searchFilterModalDialogPageResponse.priceMin,
                        () => "Price From".tr,
                        (value) => value is num ? value.toRupiah(withFreeTextIfZero: false) : value
                      ],
                      [
                        () => searchFilterModalDialogPageResponse.priceMax != null,
                        () => searchFilterModalDialogPageResponse.priceMax,
                        () => "Price To".tr,
                        (value) => value is num ? value.toRupiah(withFreeTextIfZero: false) : value
                      ]
                    ];
                    int filterCount = 0;
                    int j = 0;
                    while (j < onCheckResponseList.length) {
                      filterCount += onCheckResponseList[j][0]() ? 1 : 0;
                      j++;
                    }
                    return CompoundListItemControllerState(
                      listItemControllerState: [
                        VirtualSpacingListItemControllerState(
                          height: 10.0
                        ),
                        WidgetSubstitutionWithInjectionListItemControllerState(
                          widgetSubstitutionWithInjection: (context, index, widgetList) {
                            return TapArea(
                              onTap: oldItemType.onGotoFilterModalDialog,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: widgetList
                              )
                            );
                          },
                          onInjectListItemControllerState: () => [
                            ColorfulChipTabBarListItemControllerState(
                              canSelectAndUnselect: false,
                              chipLabelInterceptor: (textStyle, data) {
                                if (data.data is! List<String>) {
                                  return null;
                                }
                                List<String> newData = data.data;
                                return Text.rich(
                                  TextSpan(
                                    children: <InlineSpan>[
                                      TextSpan(
                                        text: "${newData[0].toStringNonNull}: "
                                      ),
                                      TextSpan(
                                        text: newData[1].toStringNonNull,
                                        style: const TextStyle(fontWeight: FontWeight.bold)
                                      )
                                    ]
                                  ),
                                  style: textStyle,
                                );
                              },
                              colorfulChipTabBarController: MultipleSelectionColorfulChipTabBarController(
                                List<int>.generate(filterCount, (index) => index)
                              ),
                              colorfulChipTabBarDataList: () {
                                List<ColorfulChipTabBarData> colorfulChipTabBarData = [];
                                int k = 0;
                                while (k < onCheckResponseList.length) {
                                  List<dynamic> onCheckResponseListValue = onCheckResponseList[k];
                                  if (onCheckResponseListValue[0]()) {
                                    dynamic value = onCheckResponseListValue[3](onCheckResponseListValue[1]());
                                    String title = "";
                                    if (value is SupportSearchFilter) {
                                      title = value.name;
                                    } else if (value is num) {
                                      title = value.toString();
                                    } else if (value is String) {
                                      title = value;
                                    }
                                    colorfulChipTabBarData.add(
                                      ColorfulChipTabBarData(
                                        title: "${onCheckResponseListValue[2]()}: $title",
                                        color: oldItemType.onGetColorfulChipTabBarColor(),
                                        data: <String>[onCheckResponseListValue[2](), title]
                                      )
                                    );
                                  }
                                  k++;
                                }
                                return colorfulChipTabBarData;
                              }()
                            )
                          ]
                        ),
                      ]
                    );
                  }
                ),
              ]
            ]
          )
        ),
        oldItemTypeList,
        newListItemControllerStateList
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(verticalGridPaddingContentSubInterceptorSupportListItemControllerState),
        oldItemTypeList,
        newListItemControllerStateList
      );
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    } else if (oldItemType is TypingSearchContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];

      void addTitle(String title) {
        listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
          i,
          ListItemControllerStateWrapper(
            CompoundListItemControllerState(
              listItemControllerState: [
                VirtualSpacingListItemControllerState(height: 12),
                PaddingContainerListItemControllerState(
                  padding: EdgeInsets.symmetric(horizontal: padding()),
                  paddingChildListItemControllerState: TitleAndDescriptionListItemControllerState(
                    title: title
                  )
                ),
                VirtualSpacingListItemControllerState(height: 5)
              ]
            ),
          ),
          oldItemTypeList,
          newListItemControllerStateList
        );
      }

      LoadDataResult<SearchResponse> searchResponseLoadDataResult = oldItemType.searchResponseLoadDataResult();
      if (searchResponseLoadDataResult.isSuccess) {
        SearchResponse searchResponse = searchResponseLoadDataResult.resultIfSuccess!;

        if (oldItemType.onGetSearchText().isNotEmptyString) {
          // Suggestion
          int k = 0;
          while (k < searchResponse.paginatedSearchResultList.length) {
            ProductEntry productEntry = searchResponse.paginatedSearchResultList[k] as ProductEntry;
            listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
              i,
              ListItemControllerStateWrapper(
                ProfileMenuListItemControllerState(
                  onTap: (context) => oldItemType.onTypingSearchListItemClick(
                    DefaultTypingSearchListItemClick(
                      text: productEntry.name
                    )
                  ),
                  icon: (BuildContext context) => const Icon(Icons.search),
                  title: productEntry.name,
                  titleInterceptor: (title, titleTextStyle) => Text(title),
                  padding: EdgeInsets.symmetric(horizontal: padding(), vertical: 8.0)
                ),
              ),
              oldItemTypeList,
              newListItemControllerStateList
            );
            k++;
          }

          // Brand
          if (searchResponse.brandSearchRelatedList.isNotEmpty) {
            addTitle("Brand".tr);
            int k = 0;
            while (k < searchResponse.brandSearchRelatedList.length) {
              BrandSearchRelated brandSearchRelated = searchResponse.brandSearchRelatedList[k];
              listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
                i,
                ListItemControllerStateWrapper(
                  ProfileMenuListItemControllerState(
                    onTap: (context) => oldItemType.onTypingSearchListItemClick(
                      BrandTypingSearchListItemClick(
                        brandId: "",
                        brandName: brandSearchRelated.searchRelatedParameter.key,
                        brandSlug: ""
                      )
                    ),
                    icon: null,
                    title: brandSearchRelated.searchRelatedParameter.key,
                    titleInterceptor: (title, titleTextStyle) => Text(title),
                    padding: EdgeInsets.symmetric(horizontal: padding(), vertical: 8.0)
                  ),
                ),
                oldItemTypeList,
                newListItemControllerStateList
              );
              k++;
            }
          }

          // Category
          if (searchResponse.categorySearchRelatedList.isNotEmpty) {
            addTitle("Category".tr);
            int k = 0;
            while (k < searchResponse.categorySearchRelatedList.length) {
              CategorySearchRelated categorySearchRelated = searchResponse.categorySearchRelatedList[k];
              listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
                i,
                ListItemControllerStateWrapper(
                  ProfileMenuListItemControllerState(
                    onTap: (context) => oldItemType.onTypingSearchListItemClick(
                      CategoryTypingSearchListItemClick(
                        categoryId: "",
                        categoryName: categorySearchRelated.searchRelatedParameter.key,
                        categorySlug: ""
                      )
                    ),
                    icon: null,
                    title: categorySearchRelated.searchRelatedParameter.key,
                    titleInterceptor: (title, titleTextStyle) => Text(title),
                    padding: EdgeInsets.symmetric(horizontal: padding(), vertical: 8.0)
                  ),
                ),
                oldItemTypeList,
                newListItemControllerStateList
              );
              k++;
            }
          }

          // Product
          if (searchResponse.productSearchRelatedList.isNotEmpty) {
            addTitle("Product".tr);
            int k = 0;
            while (k < searchResponse.productSearchRelatedList.length) {
              ProductSearchRelated productSearchRelated = searchResponse.productSearchRelatedList[k];
              listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
                i,
                ListItemControllerStateWrapper(
                  ProfileMenuListItemControllerState(
                    onTap: (context) => oldItemType.onTypingSearchListItemClick(
                      ProductTypingSearchListItemClick(
                        productId: "",
                        productName: productSearchRelated.searchRelatedParameter.key,
                        productSlug: ""
                      )
                    ),
                    icon: null,
                    title: productSearchRelated.searchRelatedParameter.key,
                    titleInterceptor: (title, titleTextStyle) => Text(title),
                    padding: EdgeInsets.symmetric(horizontal: padding(), vertical: 8.0)
                  ),
                ),
                oldItemTypeList,
                newListItemControllerStateList
              );
              k++;
            }
          }
        }
      }

      // History Search
      LoadDataResult<SearchHistoryResponse> searchHistoryResponseLoadDataResult = oldItemType.searchHistoryResponseLoadDataResult();
      if (searchHistoryResponseLoadDataResult.isSuccess) {
        SearchHistoryResponse searchHistoryResponse = searchHistoryResponseLoadDataResult.resultIfSuccess!;
        List<String> effectiveSearchHistoryList = [];
        if (oldItemType.onGetSearchText().isNotEmptyString) {
          effectiveSearchHistoryList = searchHistoryResponse.searchHistoryList.where(
            (searchHistory) => searchHistory.toLowerCase().contains(oldItemType.onGetSearchText().toLowerCase())
          ).toList();
        } else {
          effectiveSearchHistoryList = searchHistoryResponse.searchHistoryList;
        }
        effectiveSearchHistoryList = effectiveSearchHistoryList.toSet().toList();
        if (effectiveSearchHistoryList.isNotEmpty) {
          addTitle("Search History".tr);
          int k = 0;
          while (k < effectiveSearchHistoryList.length) {
            String searchHistory = effectiveSearchHistoryList[k];
            listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
              i,
              ListItemControllerStateWrapper(
                ProfileMenuListItemControllerState(
                  onTap: (context) => oldItemType.onTypingSearchListItemClick(
                    HistoryTypingSearchListItemClick(
                      text: searchHistory
                    )
                  ),
                  icon: (BuildContext context) => const Icon(Icons.history_outlined),
                  title: searchHistory,
                  titleInterceptor: (title, titleTextStyle) => Text(title),
                  padding: EdgeInsets.symmetric(horizontal: padding(), vertical: 8.0)
                ),
              ),
              oldItemTypeList,
              newListItemControllerStateList
            );
            k++;
          }
        }
      }

      // Last Seen History Search
      LoadDataResult<SearchLastSeenHistoryResponse> searchLastSeenHistoryResponseLoadDataResult = oldItemType.searchLastSeenHistoryResponseLoadDataResult();
      if (searchLastSeenHistoryResponseLoadDataResult.isSuccess) {
        SearchLastSeenHistoryResponse searchLastSeenHistoryResponse = searchLastSeenHistoryResponseLoadDataResult.resultIfSuccess!;
        List<SearchLastSeenHistory> effectiveSearchLastSeenHistoryList = [];
        if (oldItemType.onGetSearchText().isNotEmptyString) {
          effectiveSearchLastSeenHistoryList = searchLastSeenHistoryResponse.searchLastSeenHistoryList.where(
            (searchLastSeenHistory) => searchLastSeenHistory.name.toLowerCase().contains(oldItemType.onGetSearchText().toLowerCase())
          ).toList();
        } else {
          effectiveSearchLastSeenHistoryList = searchLastSeenHistoryResponse.searchLastSeenHistoryList;
        }
        if (effectiveSearchLastSeenHistoryList.isNotEmpty) {
          addTitle("Last Seen Search History".tr);
          int k = 0;
          while (k < effectiveSearchLastSeenHistoryList.length) {
            SearchLastSeenHistory searchLastSeenHistory = effectiveSearchLastSeenHistoryList[k];
            listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
              i,
              ListItemControllerStateWrapper(
                ProfileMenuListItemControllerState(
                  onTap: (context) => oldItemType.onTypingSearchListItemClick(
                    LastSeenHistoryTypingSearchListItemClick(
                      lastSeenRelatedId: searchLastSeenHistory.id,
                      lastSeenRelatedName: searchLastSeenHistory.name,
                      lastSeenRelatedSlug: searchLastSeenHistory.slug
                    )
                  ),
                  icon: (BuildContext context) => const Icon(Icons.remove_red_eye),
                  title: searchLastSeenHistory.name,
                  titleInterceptor: (title, titleTextStyle) => Text(title),
                  padding: EdgeInsets.symmetric(horizontal: padding(), vertical: 8.0)
                ),
              ),
              oldItemTypeList,
              newListItemControllerStateList
            );
            k++;
          }
        }
      }

      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}