import '../../domain/entity/product/product.dart';
import '../../domain/entity/product/product_detail_from_your_search_product_entry_list_parameter.dart';
import '../../domain/entity/product/product_detail_other_chosen_for_you_product_entry_list_parameter.dart';
import '../../domain/entity/product/product_detail_other_from_this_brand_product_entry_list_parameter.dart';
import '../../domain/entity/product/product_detail_other_in_this_category_product_entry_list_parameter.dart';
import '../../domain/entity/product/product_detail_other_interested_product_brand_list_parameter.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../domain/entity/product/productbrand/product_brand_detail_parameter.dart';
import '../../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productbundle/product_bundle_list_parameter.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../../domain/entity/product/productcategory/product_category_detail.dart';
import '../../domain/entity/product/productcategory/product_category_detail_parameter.dart';
import '../../domain/entity/product/productcategory/product_category_list_parameter.dart';
import '../../domain/entity/product/product_detail_parameter.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/product/product_list_parameter.dart';
import '../../domain/entity/product/product_paging_parameter.dart';
import '../../domain/entity/product/product_with_condition_list_parameter.dart';
import '../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../domain/repository/product_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/productdatasource/product_data_source.dart';

class DefaultProductRepository implements ProductRepository {
  final ProductDataSource productDataSource;

  const DefaultProductRepository({
    required this.productDataSource
  });

  @override
  FutureProcessing<LoadDataResult<List<ProductBundle>>> productBundleList(ProductBundleListParameter productBundleListParameter) {
    return productDataSource.productBundleList(productBundleListParameter).mapToLoadDataResult<List<ProductBundle>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductBrand>>> productBrandList(ProductBrandListParameter productBrandListParameter) {
    return productDataSource.productBrandList(productBrandListParameter).mapToLoadDataResult<List<ProductBrand>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductCategory>>> productCategoryList(ProductCategoryListParameter productCategoryListParameter) {
    return productDataSource.productCategoryList(productCategoryListParameter).mapToLoadDataResult<List<ProductCategory>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<Product>>> productList(ProductListParameter productListParameter) {
    return productDataSource.productList(productListParameter).mapToLoadDataResult<List<Product>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productWithConditionList(ProductWithConditionListParameter productWithConditionListParameter) {
    return productDataSource.productWithConditionList(productWithConditionListParameter).mapToLoadDataResult<List<ProductEntry>>();
  }

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<Product>>> productPaging(ProductPagingParameter productPagingParameter) {
    return productDataSource.productPaging(productPagingParameter).mapToLoadDataResult<PagingDataResult<Product>>();
  }

  @override
  FutureProcessing<LoadDataResult<PagingDataResult<ProductEntry>>> productWithConditionPaging(ProductWithConditionPagingParameter productWithConditionPagingParameter) {
    return productDataSource.productWithConditionPaging(productWithConditionPagingParameter).mapToLoadDataResult<PagingDataResult<ProductEntry>>();
  }

  @override
  FutureProcessing<LoadDataResult<Product>> productDetail(ProductDetailParameter productDetailParameter) {
    return productDataSource.productDetail(productDetailParameter).mapToLoadDataResult<Product>();
  }

  @override
  FutureProcessing<LoadDataResult<ProductBrandDetail>> productBrandDetail(ProductBrandDetailParameter productBrandDetailParameter) {
    return productDataSource.productBrandDetail(productBrandDetailParameter).mapToLoadDataResult<ProductBrandDetail>();
  }

  @override
  FutureProcessing<LoadDataResult<ProductCategoryDetail>> productCategoryDetail(ProductCategoryDetailParameter productCategoryDetailParameter) {
    return productDataSource.productCategoryDetail(productCategoryDetailParameter).mapToLoadDataResult<ProductCategoryDetail>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailFromYourSearchProductEntryList(ProductDetailFromYourSearchProductEntryListParameter productDetailFromYourSearchProductEntryListParameter) {
    return productDataSource.productDetailFromYourSearchProductEntryList(productDetailFromYourSearchProductEntryListParameter).mapToLoadDataResult<List<ProductEntry>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailOtherChosenForYouProductEntryList(ProductDetailOtherChosenForYouProductEntryListParameter productDetailOtherChosenForYouProductEntryListParameter) {
    return productDataSource.productDetailOtherChosenForYouProductEntryList(productDetailOtherChosenForYouProductEntryListParameter).mapToLoadDataResult<List<ProductEntry>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailOtherFromThisBrandProductEntryList(ProductDetailOtherFromThisBrandProductEntryListParameter productDetailOtherFromThisBrandProductEntryListParameter) {
    return productDataSource.productDetailOtherFromThisBrandProductEntryList(productDetailOtherFromThisBrandProductEntryListParameter).mapToLoadDataResult<List<ProductEntry>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductEntry>>> productDetailOtherInThisCategoryProductEntryList(ProductDetailOtherInThisCategoryProductEntryListParameter productDetailOtherInThisCategoryProductEntryListParameter) {
    return productDataSource.productDetailOtherInThisCategoryProductEntryList(productDetailOtherInThisCategoryProductEntryListParameter).mapToLoadDataResult<List<ProductEntry>>();
  }

  @override
  FutureProcessing<LoadDataResult<List<ProductBrand>>> productDetailOtherInterestedProductBrandListParameter(ProductDetailOtherInterestedProductBrandListParameter productDetailOtherInterestedProductBrandListParameter) {
    return productDataSource.productDetailOtherInterestedProductBrandListParameter(productDetailOtherInterestedProductBrandListParameter).mapToLoadDataResult<List<ProductBrand>>();
  }
}