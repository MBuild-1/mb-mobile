import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';

import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/search/remove_all_search_history_response.dart';
import '../../domain/entity/search/search_history_response.dart';
import '../../domain/entity/search/search_last_seen_history_response.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/entity/search/searchlastseenhistory/product_entry_search_last_seen_history.dart';
import '../../domain/entity/search/searchlastseenhistory/search_last_seen_history.dart';
import '../../domain/entity/search/searchrelated/brand_search_related.dart';
import '../../domain/entity/search/searchrelated/category_search_related.dart';
import '../../domain/entity/search/searchrelated/product_search_related.dart';
import '../../domain/entity/search/searchrelated/province_search_related.dart';
import '../../domain/entity/search/searchrelated/search_related.dart';
import '../../domain/entity/search/store_keyword_for_search_history_response.dart';
import '../../domain/entity/search/store_search_last_seen_history_response.dart';
import '../../domain/entity/search/support_search.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../misc/response_wrapper.dart';

extension SearchEntityMappingExt on ResponseWrapper {
  SearchResponse mapFromResponseToSearchResponse(List<Wishlist> wishlistList, List<Cart> cartList) {
    dynamic hitsResponse = response["hits"];
    dynamic aggregationsResponse = response["aggregations"];
    return SearchResponse(
      searchResultCount: hitsResponse["total"]["value"],
      paginatedSearchResultList: (hitsResponse["hits"] as List<dynamic>).map<SupportSearch>(
        (responseValue) => ResponseWrapper(responseValue["_source"]).mapFromResponseToSupportSearch(wishlistList, cartList)
      ).toList(),
      brandSearchRelatedList: aggregationsResponse != null ? ResponseWrapper(aggregationsResponse["related_brands"]).mapFromResponseToBrandSearchRelatedList() : [],
      categorySearchRelatedList: aggregationsResponse != null ? ResponseWrapper(aggregationsResponse["related_category"]).mapFromResponseToCategorySearchRelatedList() : [],
      provinceSearchRelatedList: aggregationsResponse != null ? ResponseWrapper(aggregationsResponse["related_province"]).mapFromResponseToProvinceSearchRelatedList() : [],
      productSearchRelatedList: aggregationsResponse != null ? ResponseWrapper(aggregationsResponse["related_products"]).mapFromResponseToProductSearchRelatedList() : [],
    );
  }

  SearchHistoryResponse mapFromResponseToSearchHistoryResponse() {
    return SearchHistoryResponse(
      searchHistoryList: response.map<String>(
        (value) => value as String
      ).toList()
    );
  }

  SearchLastSeenHistoryResponse mapFromResponseToSearchLastSeenHistoryResponse() {
    return SearchLastSeenHistoryResponse(
      searchLastSeenHistoryList: response.map<SearchLastSeenHistory>(
        (value) {
          dynamic imageResponse = value["image"];
          String imageUrl = "";
          if (imageResponse is List<dynamic>) {
            if (imageResponse.isNotEmpty) {
              dynamic oneImageResponse = imageResponse.first;
              imageUrl = oneImageResponse["path"];
            }
          }
          return ProductEntrySearchLastSeenHistory(
            id: value["id"],
            name: value["name"],
            slug: value["slug"],
            imageUrl: imageUrl
          );
        }
      ).toList()
    );
  }

  RemoveAllSearchHistoryResponse mapFromResponseToRemoveAllSearchLastSeenHistoryResponse() {
    return RemoveAllSearchHistoryResponse();
  }

  StoreKeywordForSearchHistoryResponse mapFromResponseToStoreKeywordForSearchHistoryResponse() {
    return StoreKeywordForSearchHistoryResponse();
  }

  StoreSearchLastSeenHistoryResponse mapFromResponseToStoreSearchLastSeenHistoryResponse() {
    return StoreSearchLastSeenHistoryResponse();
  }
}

extension SearchDetailEntityMappingExt on ResponseWrapper {
  SupportSearch mapFromResponseToSupportSearch(List<Wishlist> wishlistList, List<Cart> cartList) {
    return ResponseWrapper(response).mapFromResponseToProductEntry(wishlistList, cartList);
  }

  List<BrandSearchRelated> mapFromResponseToBrandSearchRelatedList() {
    return _mapFromResponseToSearchRelatedList((searchRelatedParameter) {
      return BrandSearchRelated(
        searchRelatedParameter: searchRelatedParameter
      );
    });
  }

  List<CategorySearchRelated> mapFromResponseToCategorySearchRelatedList() {
    return _mapFromResponseToSearchRelatedList((searchRelatedParameter) {
      return CategorySearchRelated(
        searchRelatedParameter: searchRelatedParameter
      );
    });
  }

  List<ProvinceSearchRelated> mapFromResponseToProvinceSearchRelatedList() {
    return _mapFromResponseToSearchRelatedList((searchRelatedParameter) {
      return ProvinceSearchRelated(
        searchRelatedParameter: searchRelatedParameter
      );
    });
  }

  List<ProductSearchRelated> mapFromResponseToProductSearchRelatedList() {
    return _mapFromResponseToSearchRelatedList((searchRelatedParameter) {
      return ProductSearchRelated(
        searchRelatedParameter: searchRelatedParameter
      );
    });
  }

  List<T> _mapFromResponseToSearchRelatedList<T extends SearchRelated>(T Function(SearchRelatedParameter) callback) {
    return response != null ? response["buckets"].map<T>(
      (searchRelatedResponse) => callback(
        SearchRelatedParameter(
          key: searchRelatedResponse["key"],
          count: searchRelatedResponse["doc_count"]
        )
      )
    ).toList() : [];
  }
}