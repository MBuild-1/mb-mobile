import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/product.dart';
import '../entity/product/product_detail_from_your_search_product_entry_list_parameter.dart';
import '../entity/product/product_detail_other_chosen_for_you_product_entry_list_parameter.dart';
import '../entity/product/product_detail_other_from_this_brand_product_entry_list_parameter.dart';
import '../entity/product/product_detail_other_in_this_category_product_entry_list_parameter.dart';
import '../entity/product/product_detail_other_interested_product_brand_list_parameter.dart';
import '../entity/product/productbrand/product_brand.dart';
import '../entity/product/productbrand/product_brand_detail.dart';
import '../entity/product/productbrand/product_brand_detail_parameter.dart';
import '../entity/product/productbrand/product_brand_list_parameter.dart';
import '../entity/product/productbundle/product_bundle.dart';
import '../entity/product/productbundle/product_bundle_detail.dart';
import '../entity/product/productbundle/product_bundle_detail_parameter.dart';
import '../entity/product/productbundle/product_bundle_highlight_parameter.dart';
import '../entity/product/productbundle/product_bundle_list_parameter.dart';
import '../entity/product/productbundle/product_bundle_paging_parameter.dart';
import '../entity/product/productcategory/product_category.dart';
import '../entity/product/productcategory/product_category_detail.dart';
import '../entity/product/productcategory/product_category_detail_parameter.dart';
import '../entity/product/productcategory/product_category_list_parameter.dart';
import '../entity/product/product_detail_parameter.dart';
import '../entity/product/productentry/product_entry.dart';
import '../entity/product/product_list_parameter.dart';
import '../entity/product/product_paging_parameter.dart';
import '../entity/product/product_with_condition_list_parameter.dart';
import '../entity/product/product_with_condition_paging_parameter.dart';

abstract class ProductRepository {
  FutureProcessing<LoadDataResult<List<ProductBundle>>> productBundleList(ProductBundleListParameter productBundleListParameter);
  FutureProcessing<LoadDataResult<List<ProductBrand>>> productBrandList(ProductBrandListParameter productBrandListParameter);
  FutureProcessing<LoadDataResult<List<ProductCategory>>> productCategoryList(ProductCategoryListParameter productCategoryListParameter);
  FutureProcessing<LoadDataResult<List<Product>>> productList(ProductListParameter productListParameter);
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productWithConditionList(ProductWithConditionListParameter productWithConditionListParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<Product>>> productPaging(ProductPagingParameter productPagingParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<ProductBundle>>> productBundlePaging(ProductBundlePagingParameter productBundlePagingParameter);
  FutureProcessing<LoadDataResult<ProductBundle>> productBundleHighlight(ProductBundleHighlightParameter productBundleHighlightParameter);
  FutureProcessing<LoadDataResult<PagingDataResult<ProductEntry>>> productWithConditionPaging(ProductWithConditionPagingParameter productWithConditionPagingParameter);
  FutureProcessing<LoadDataResult<Product>> productDetail(ProductDetailParameter productDetailParameter);
  FutureProcessing<LoadDataResult<ProductBrandDetail>> productBrandDetail(ProductBrandDetailParameter productBrandDetailParameter);
  FutureProcessing<LoadDataResult<ProductCategoryDetail>> productCategoryDetail(ProductCategoryDetailParameter productCategoryDetailParameter);
  FutureProcessing<LoadDataResult<ProductBundleDetail>> productBundleDetail(ProductBundleDetailParameter productBundleDetailParameter);
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailFromYourSearchProductEntryList(ProductDetailFromYourSearchProductEntryListParameter productDetailFromYourSearchProductEntryListParameter);
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailOtherChosenForYouProductEntryList(ProductDetailOtherChosenForYouProductEntryListParameter productDetailOtherChosenForYouProductEntryListParameter);
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailOtherFromThisBrandProductEntryList(ProductDetailOtherFromThisBrandProductEntryListParameter productDetailOtherFromThisBrandProductEntryListParameter);
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailOtherInThisCategoryProductEntryList(ProductDetailOtherInThisCategoryProductEntryListParameter productDetailOtherInThisCategoryProductEntryListParameter);
  FutureProcessing<LoadDataResult<List<ProductBrand>>> productDetailOtherInterestedProductBrandListParameter(ProductDetailOtherInterestedProductBrandListParameter productDetailOtherInterestedProductBrandListParameter);
}