import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';

import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/search/search_response.dart';
import '../../domain/entity/search/searchrelated/brand_search_related.dart';
import '../../domain/entity/search/searchrelated/category_search_related.dart';
import '../../domain/entity/search/searchrelated/province_search_related.dart';
import '../../domain/entity/search/searchrelated/search_related.dart';
import '../../domain/entity/search/support_search.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../misc/response_wrapper.dart';

extension SearchEntityMappingExt on ResponseWrapper {
  SearchResponse mapFromResponseToSearchResponse(List<Wishlist> wishlistList, List<Cart> cartList) {
    dynamic hitsResponse = response["hits"];
    dynamic aggregationsResponse = response["aggregations"];
    return SearchResponse(
      searchResultList: (hitsResponse["hits"] as List<dynamic>).map<SupportSearch>(
        (responseValue) => ResponseWrapper(responseValue["_source"]).mapFromResponseToSupportSearch(wishlistList, cartList)
      ).toList(),
      brandSearchRelatedList: ResponseWrapper(aggregationsResponse["related_brands"]).mapFromResponseToBrandSearchRelatedList(),
      categorySearchRelatedList: ResponseWrapper(aggregationsResponse["related_category"]).mapFromResponseToCategorySearchRelatedList(),
      provinceSearchRelatedList: ResponseWrapper(aggregationsResponse["related_province"]).mapFromResponseToProvinceSearchRelatedList()
    );
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