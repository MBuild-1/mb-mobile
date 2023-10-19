import 'searchrelated/brand_search_related.dart';
import 'searchrelated/category_search_related.dart';
import 'searchrelated/province_search_related.dart';
import 'support_search.dart';

class SearchResponse {
  List<SupportSearch> searchResultList;
  List<BrandSearchRelated> brandSearchRelatedList;
  List<CategorySearchRelated> categorySearchRelatedList;
  List<ProvinceSearchRelated> provinceSearchRelatedList;

  SearchResponse({
    required this.searchResultList,
    required this.brandSearchRelatedList,
    required this.categorySearchRelatedList,
    required this.provinceSearchRelatedList
  });
}