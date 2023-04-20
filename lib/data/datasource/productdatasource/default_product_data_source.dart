import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/dummy/productdummy/product_bundle_dummy.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/option_builder.dart';

import '../../../domain/dummy/productdummy/product_entry_dummy.dart';
import '../../../domain/entity/product/product.dart';
import '../../../domain/entity/product/product_detail_from_your_search_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_chosen_for_you_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_from_this_brand_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_in_this_category_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_interested_product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbrand/product_brand.dart';
import '../../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../../domain/entity/product/productbrand/product_brand_detail_parameter.dart';
import '../../../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productbundle/product_bundle_detail.dart';
import '../../../domain/entity/product/productbundle/product_bundle_detail_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle_highlight_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle_list_parameter.dart';
import '../../../domain/entity/product/productbundle/product_bundle_paging_parameter.dart';
import '../../../domain/entity/product/productcategory/product_category.dart';
import '../../../domain/entity/product/productcategory/product_category_detail.dart';
import '../../../domain/entity/product/productcategory/product_category_detail_parameter.dart';
import '../../../domain/entity/product/productcategory/product_category_list_parameter.dart';
import '../../../domain/entity/product/product_detail_parameter.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/product_list_parameter.dart';
import '../../../domain/entity/product/product_paging_parameter.dart';
import '../../../domain/entity/product/product_with_condition_list_parameter.dart';
import '../../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../../domain/entity/wishlist/add_wishlist_parameter.dart';
import '../../../domain/entity/wishlist/add_wishlist_response.dart';
import '../../../domain/entity/wishlist/remove_wishlist_parameter.dart';
import '../../../domain/entity/wishlist/remove_wishlist_response.dart';
import '../../../domain/entity/wishlist/wishlist.dart';
import '../../../domain/entity/wishlist/wishlist_paging_parameter.dart';
import '../../../misc/error/not_found_error.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/dummy_future_processing.dart';
import '../../../misc/processing/future_processing.dart';
import '../../../misc/response_wrapper.dart';
import 'product_data_source.dart';

class DefaultProductDataSource implements ProductDataSource {
  final Dio dio;
  final ProductBundleDummy productBundleDummy;
  final ProductEntryDummy productEntryDummy;

  const DefaultProductDataSource({
    required this.dio,
    required this.productBundleDummy,
    required this.productEntryDummy
  });

  @override
  FutureProcessing<List<ProductBundle>> productBundleList(ProductBundleListParameter productBundleListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/bundle", cancelToken: cancelToken)
        .map<List<ProductBundle>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundleList());
    });
  }

  @override
  FutureProcessing<List<ProductBrand>> productBrandList(ProductBrandListParameter productBrandListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/brand", cancelToken: cancelToken)
        .map<List<ProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandList());
    });
  }

  @override
  FutureProcessing<List<ProductCategory>> productCategoryList(ProductCategoryListParameter productCategoryListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/category", cancelToken: cancelToken)
        .map<List<ProductCategory>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductCategoryList());
    });
  }

  @override
  FutureProcessing<List<Product>> productList(ProductListParameter productListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product", cancelToken: cancelToken)
        .map<List<Product>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductList());
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productWithConditionList(ProductWithConditionListParameter productWithConditionListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String withConditionParameterPath = productWithConditionListParameter.withCondition.isNotEmptyString ? "/${productWithConditionListParameter.withCondition}" : "";
      return dio.get("/product$withConditionParameterPath", cancelToken: cancelToken)
        .map<List<ProductEntry>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryList());
    });
  }

  @override
  FutureProcessing<PagingDataResult<Product>> productPaging(ProductPagingParameter productPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/${productPagingParameter.itemEachPageCount}?page=${productPagingParameter.page}";
      return dio.get("/product$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<Product>>(onMap: (value) => value.wrapResponse().mapFromResponseToPagingDataResult(
          (dataResponse) => dataResponse.map<Product>(
            (productResponse) => ResponseWrapper(productResponse).mapFromResponseToProduct()
          ).toList()
        ));
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductBundle>> productBundlePaging(ProductBundlePagingParameter productBundlePagingParameter) {
    return DummyFutureProcessing((cancelToken) async {
      return PagingDataResult<ProductBundle>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [productBundleDummy.generateDefaultDummy()]
      );
    });
    // return DioHttpClientProcessing((cancelToken) {
    //   String pageParameterPath = "/${productBundlePagingParameter.itemEachPageCount}?page=${productBundlePagingParameter.page}";
    //   return dio.get("/product$pageParameterPath", cancelToken: cancelToken)
    //     .map<PagingDataResult<ProductBundle>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundlePaging());
    // });
  }

  @override
  FutureProcessing<ProductBundle> productBundleHighlight(ProductBundleHighlightParameter productBundleHighlightParameter) {
    return DummyFutureProcessing((cancelToken) async {
      return productBundleDummy.generateDefaultDummy();
    });
    // return DioHttpClientProcessing((cancelToken) {
    //   String pageParameterPath = "/${productBundlePagingParameter.itemEachPageCount}?page=${productBundlePagingParameter.page}";
    //   return dio.get("/product$pageParameterPath", cancelToken: cancelToken)
    //     .map<PagingDataResult<ProductBundle>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundlePaging());
    // });
  }

  @override
  FutureProcessing<PagingDataResult<ProductEntry>> productWithConditionPaging(ProductWithConditionPagingParameter productWithConditionPagingParameter) {
    Map<String, dynamic> queryParameters = {
      "page": productWithConditionPagingParameter.page,
      "pageNumber": productWithConditionPagingParameter.itemEachPageCount,
      ...productWithConditionPagingParameter.withCondition
    };
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/entry", queryParameters: queryParameters, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging());
    });
  }

  @override
  FutureProcessing<Product> productDetail(ProductDetailParameter productDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/${productDetailParameter.productId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProduct());
    });
  }

  @override
  FutureProcessing<ProductBrandDetail> productBrandDetail(ProductBrandDetailParameter productBrandDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/brand/${productBrandDetailParameter.productBrandId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandDetail());
    });
  }

  @override
  FutureProcessing<ProductCategoryDetail> productCategoryDetail(ProductCategoryDetailParameter productCategoryDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/category/${productCategoryDetailParameter.productCategoryDetailId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductCategoryDetail());
    });
  }

  @override
  FutureProcessing<ProductBundleDetail> productBundleDetail(ProductBundleDetailParameter productBundleDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/bundle/${productBundleDetailParameter.productBundleId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundleDetail());
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailFromYourSearchProductEntryList(ProductDetailFromYourSearchProductEntryListParameter productDetailFromYourSearchProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/entry", queryParameters: {"fyp": true, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging().itemList);
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailOtherChosenForYouProductEntryList(ProductDetailOtherChosenForYouProductEntryListParameter productDetailOtherChosenForYouProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/entry", queryParameters: {"fyp": true, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging().itemList);
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailOtherFromThisBrandProductEntryList(ProductDetailOtherFromThisBrandProductEntryListParameter productDetailOtherFromThisBrandProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/entry", queryParameters: {"brand": productDetailOtherFromThisBrandProductEntryListParameter.brandSlug, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging().itemList);
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailOtherInThisCategoryProductEntryList(ProductDetailOtherInThisCategoryProductEntryListParameter productDetailOtherInThisCategoryProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/entry", queryParameters: {"category": productDetailOtherInThisCategoryProductEntryListParameter.categorySlug, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging().itemList);
    });
  }

  @override
  FutureProcessing<List<ProductBrand>> productDetailOtherInterestedProductBrandListParameter(ProductDetailOtherInterestedProductBrandListParameter productDetailOtherInterestedProductBrandListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/product/brand", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandList());
    });
  }

  @override
  FutureProcessing<PagingDataResult<Wishlist>> wishlistPaging(WishlistPagingParameter wishlistPagingParameter) {
    return DummyFutureProcessing((cancelToken) async {
      await Future.delayed(const Duration(seconds: 1));
      return PagingDataResult<Wishlist>(
        page: 1,
        totalPage: 1,
        totalItem: 1,
        itemList: [
          Wishlist(
            id: "1",
            productEntry: productEntryDummy.generateDefaultDummy()
          )
        ]
      );
    });
    // return DioHttpClientProcessing((cancelToken) {
    //   return dio.get("/wishlist", cancelToken: cancelToken)
    //     .map(onMap: (value) => value.wrapResponse().mapFromResponseToWishlistPaging());
    // });
  }

  @override
  FutureProcessing<AddWishlistResponse> addWishlist(AddWishlistParameter addWishlistParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/wishlist/add", cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToAddWishlistResponse());
    });
  }

  @override
  FutureProcessing<RemoveWishlistResponse> removeWishlist(RemoveWishlistParameter removeWishlistParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/wishlist/remove", cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveWishlistResponse());
    });
  }
}