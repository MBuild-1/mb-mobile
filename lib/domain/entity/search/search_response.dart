import 'searchrelated/brand_search_related.dart';
import 'searchrelated/category_search_related.dart';
import 'searchrelated/product_search_related.dart';
import 'searchrelated/province_search_related.dart';
import 'support_search.dart';

class SearchResponse {
  int searchResultCount;
  List<SupportSearch> paginatedSearchResultList;
  List<BrandSearchRelated> brandSearchRelatedList;
  List<CategorySearchRelated> categorySearchRelatedList;
  List<ProvinceSearchRelated> provinceSearchRelatedList;
  List<ProductSearchRelated> productSearchRelatedList;

  SearchResponse({
    required this.searchResultCount,
    required this.paginatedSearchResultList,
    required this.brandSearchRelatedList,
    required this.categorySearchRelatedList,
    required this.provinceSearchRelatedList,
    required this.productSearchRelatedList
  });
}