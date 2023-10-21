import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/search/search_history_response.dart';
import '../../domain/entity/search/search_last_seen_history_response.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/entity/search/searchlastseenhistory/search_last_seen_history.dart';
import '../../domain/entity/search/searchrelated/brand_search_related.dart';
import '../../domain/entity/search/searchrelated/category_search_related.dart';
import '../../domain/entity/search/searchrelated/product_search_related.dart';
import '../controllerstate/listitemcontrollerstate/compound_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/padding_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/profilemenulistitemcontrollerstate/profile_menu_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/searchlistitemcontrollerstate/search_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/searchlistitemcontrollerstate/typing_search_container_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../load_data_result.dart';
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
          while (k < searchResponse.searchResultList.length) {
            ProductEntry productEntry = searchResponse.searchResultList[k] as ProductEntry;
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