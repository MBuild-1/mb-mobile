import 'search_sort_by.dart';
import 'searchrelated/brand_search_related.dart';
import 'searchrelated/category_search_related.dart';
import 'searchrelated/province_search_related.dart';

class SearchParameter {
  SearchSortBy? searchSortBy;
  String? query;
  int? priceMin;
  int? priceMax;
  BrandSearchRelated? brandSearchRelated;
  CategorySearchRelated? categorySearchRelated;
  ProvinceSearchRelated? provinceSearchRelated;

  SearchParameter({
    this.searchSortBy,
    this.query,
    this.priceMin,
    this.priceMax,
    this.brandSearchRelated,
    this.categorySearchRelated,
    this.provinceSearchRelated
  });
}