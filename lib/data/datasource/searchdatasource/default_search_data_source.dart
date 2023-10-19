import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/search_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/cart_list_parameter.dart';
import '../../../domain/entity/search/search_parameter.dart';
import '../../../domain/entity/search/search_response.dart';
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
      };
      var searchResponse = await dio.get("/elastic/entry/search", queryParameters: queryParameters, cancelToken: cancelToken)
        .map<SearchResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToSearchResponse(wishlistListResult, cartListResult));
      if (searchResponse.searchResultList.isEmpty) {
        throw SearchNotFoundError();
      }
      return searchResponse;
    });
  }
}