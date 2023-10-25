import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/search_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/cart_list_parameter.dart';
import '../../../domain/entity/search/search_history_parameter.dart';
import '../../../domain/entity/search/search_history_response.dart';
import '../../../domain/entity/search/search_last_seen_history_parameter.dart';
import '../../../domain/entity/search/search_last_seen_history_response.dart';
import '../../../domain/entity/search/search_parameter.dart';
import '../../../domain/entity/search/search_response.dart';
import '../../../domain/entity/search/store_keyword_for_search_history_parameter.dart';
import '../../../domain/entity/search/store_keyword_for_search_history_response.dart';
import '../../../domain/entity/search/store_search_last_seen_history_parameter.dart';
import '../../../domain/entity/search/store_search_last_seen_history_response.dart';
import '../../../domain/entity/search/storesearchlastseenhistoryparametervalue/product_entry_store_search_last_seen_history_parameter_value.dart';
import '../../../domain/entity/search/storesearchlastseenhistoryparametervalue/store_search_last_seen_history_parameter_value.dart';
import '../../../domain/entity/wishlist/wishlist.dart';
import '../../../domain/entity/wishlist/wishlist_list_parameter.dart';
import '../../../misc/error/search_not_found_error.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import '../cartdatasource/cart_data_source.dart';
import '../productdatasource/product_data_source.dart';
import 'search_data_source.dart';

class DefaultSearchDataSource implements SearchDataSource {
  final Dio dio;
  final ProductDataSource productDataSource;
  final CartDataSource cartDataSource;

  const DefaultSearchDataSource({
    required this.dio,
    required this.productDataSource,
    required this.cartDataSource
  });

  @override
  FutureProcessing<SearchResponse> search(SearchParameter searchParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await productDataSource.wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      Map<String, dynamic> queryParameters = <String, dynamic> {
        if (searchParameter.query.isNotEmptyString) "q": searchParameter.query!,
        if (searchParameter.suggest.isNotEmptyString) "suggest": searchParameter.suggest!,
        if (searchParameter.searchSortBy != null) "sortBy": searchParameter.searchSortBy!.value,
        if (searchParameter.priceMin != null) "pmin": searchParameter.priceMin!,
        if (searchParameter.priceMax != null) "pmax": searchParameter.priceMax!,
        if (searchParameter.brandSearchRelated != null) "reb": searchParameter.brandSearchRelated!.searchRelatedParameter.key,
        if (searchParameter.categorySearchRelated != null) "rec": searchParameter.categorySearchRelated!.searchRelatedParameter.key,
        if (searchParameter.provinceSearchRelated != null) "rep": searchParameter.provinceSearchRelated!.searchRelatedParameter.key,
        if (searchParameter.page != null) "from": searchParameter.pageSize! * (searchParameter.page! - 1),
        if (searchParameter.page != null) "size": searchParameter.pageSize!
      };
      var searchResponse = await dio.get("/elastic/entry/search", queryParameters: queryParameters, cancelToken: cancelToken)
        .map<SearchResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToSearchResponse(wishlistListResult, cartListResult));
      if (searchResponse.paginatedSearchResultList.isEmpty) {
        throw SearchNotFoundError();
      }
      return searchResponse;
    });
  }

  @override
  FutureProcessing<SearchHistoryResponse> searchHistory(SearchHistoryParameter searchHistoryParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/history-search/user", cancelToken: cancelToken)
        .map<SearchHistoryResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToSearchHistoryResponse());
    });
  }

  @override
  FutureProcessing<SearchLastSeenHistoryResponse> searchLastSeenHistory(SearchLastSeenHistoryParameter searchLastSeenHistoryParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/history-search/last-seen", cancelToken: cancelToken)
        .map<SearchLastSeenHistoryResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToSearchLastSeenHistoryResponse());
    });
  }

  @override
  FutureProcessing<StoreKeywordForSearchHistoryResponse> storeKeywordForSearchHistory(StoreKeywordForSearchHistoryParameter storeKeywordForSearchHistoryParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/history-search/${Uri.encodeComponent(storeKeywordForSearchHistoryParameter.keyword)}", cancelToken: cancelToken)
        .map<StoreKeywordForSearchHistoryResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToStoreKeywordForSearchHistoryResponse());
    });
  }

  @override
  FutureProcessing<StoreSearchLastSeenHistoryResponse> storeSearchLastSeenHistory(StoreSearchLastSeenHistoryParameter storeSearchLastSeenHistoryParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      String id = "";
      StoreSearchLastSeenHistoryParameterValue storeSearchLastSeenHistoryParameterValue = storeSearchLastSeenHistoryParameter.storeSearchLastSeenHistoryParameterValue;
      if (storeSearchLastSeenHistoryParameterValue is ProductEntryStoreSearchLastSeenHistoryParameterValue) {
        id = storeSearchLastSeenHistoryParameterValue.productEntryId;
      }
      return await dio.post("/history-search/last-seen/$id", cancelToken: cancelToken)
        .map<StoreSearchLastSeenHistoryResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToStoreSearchLastSeenHistoryResponse());
    });
  }
}