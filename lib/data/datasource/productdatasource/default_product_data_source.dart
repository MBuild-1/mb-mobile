import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/dummy/productdummy/product_bundle_dummy.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/option_builder.dart';

import '../../../domain/dummy/productdummy/product_brand_dummy.dart';
import '../../../domain/dummy/productdummy/product_entry_dummy.dart';
import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/cart_list_parameter.dart';
import '../../../domain/entity/product/product.dart';
import '../../../domain/entity/product/product_appearance_data.dart';
import '../../../domain/entity/product/product_detail.dart';
import '../../../domain/entity/product/product_detail_from_your_search_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_chosen_for_you_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_from_this_brand_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_in_this_category_product_entry_list_parameter.dart';
import '../../../domain/entity/product/product_detail_other_interested_product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbrand/add_to_favorite_product_brand_parameter.dart';
import '../../../domain/entity/product/productbrand/add_to_favorite_product_brand_response.dart';
import '../../../domain/entity/product/productbrand/favorite_product_brand.dart';
import '../../../domain/entity/product/productbrand/favorite_product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbrand/favorite_product_brand_paging_parameter.dart';
import '../../../domain/entity/product/productbrand/product_brand.dart';
import '../../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../../domain/entity/product/productbrand/product_brand_detail_parameter.dart';
import '../../../domain/entity/product/productbrand/product_brand_list_parameter.dart';
import '../../../domain/entity/product/productbrand/product_brand_paging_parameter.dart';
import '../../../domain/entity/product/productbrand/remove_from_favorite_product_brand_parameter.dart';
import '../../../domain/entity/product/productbrand/remove_from_favorite_product_brand_response.dart';
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
import '../../../domain/entity/product/productcategory/product_category_paging_parameter.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/product_list_parameter.dart';
import '../../../domain/entity/product/product_paging_parameter.dart';
import '../../../domain/entity/product/product_with_condition_list_parameter.dart';
import '../../../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../../../domain/entity/wishlist/add_wishlist_parameter.dart';
import '../../../domain/entity/wishlist/add_wishlist_response.dart';
import '../../../domain/entity/wishlist/remove_wishlist_based_product_parameter.dart';
import '../../../domain/entity/wishlist/remove_wishlist_parameter.dart';
import '../../../domain/entity/wishlist/remove_wishlist_response.dart';
import '../../../domain/entity/wishlist/support_wishlist.dart';
import '../../../domain/entity/wishlist/wishlist.dart';
import '../../../domain/entity/wishlist/wishlist_list_parameter.dart';
import '../../../domain/entity/wishlist/wishlist_paging_parameter.dart';
import '../../../misc/constant.dart';
import '../../../misc/error/empty_error.dart';
import '../../../misc/error/not_found_error.dart';
import '../../../misc/error/please_login_first_error.dart';
import '../../../misc/error_helper.dart';
import '../../../misc/paging/pagingresult/paging_data_result.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/dummy_future_processing.dart';
import '../../../misc/processing/future_processing.dart';
import '../../../misc/response_wrapper.dart';
import '../cartdatasource/cart_data_source.dart';
import 'product_data_source.dart';

class DefaultProductDataSource implements ProductDataSource {
  final Dio dio;
  final CartDataSource cartDataSource;
  final ProductBundleDummy productBundleDummy;
  final ProductEntryDummy productEntryDummy;
  final ProductBrandDummy productBrandDummy;

  const DefaultProductDataSource({
    required this.dio,
    required this.cartDataSource,
    required this.productBundleDummy,
    required this.productEntryDummy,
    required this.productBrandDummy
  });

  @override
  FutureProcessing<List<ProductBundle>> productBundleList(ProductBundleListParameter productBundleListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/product/bundle", cancelToken: cancelToken)
        .map<List<ProductBundle>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundleList(wishlistListResult, cartListResult));
    });
  }

  @override
  FutureProcessing<List<ProductBrand>> productBrandList(ProductBrandListParameter productBrandListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      return await dio.get("/product/brand", cancelToken: cancelToken)
        .map<List<ProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandList(favoriteProductBrandListResult));
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductBrand>> selectedFashionProductBrandPaging(ProductBrandPagingParameter productBrandPagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      String pageParameterPath = "/?pageNumber=${productBrandPagingParameter.itemEachPageCount}&page=${productBrandPagingParameter.page}";
      return await dio.get("/product/brand/fashion/choosen$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandPaging(favoriteProductBrandListResult));
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductBrand>> selectedBeautyProductBrandPaging(ProductBrandPagingParameter productBrandPagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      String pageParameterPath = "/?pageNumber=${productBrandPagingParameter.itemEachPageCount}&page=${productBrandPagingParameter.page}";
      return await dio.get("/product/brand/banner/beauty$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandPaging(favoriteProductBrandListResult));
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
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      return await dio.get("/product", cancelToken: cancelToken)
        .map<List<Product>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductList(favoriteProductBrandListResult));
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productWithConditionList(ProductWithConditionListParameter productWithConditionListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      String withConditionParameterPath = productWithConditionListParameter.withCondition.isNotEmptyString ? "/${productWithConditionListParameter.withCondition}" : "";
      return await dio.get("/product$withConditionParameterPath", cancelToken: cancelToken)
        .map<List<ProductEntry>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryList(wishlistListResult, cartListResult));
    });
  }

  @override
  FutureProcessing<PagingDataResult<Product>> productPaging(ProductPagingParameter productPagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      String pageParameterPath = "/?pageNumber=${productPagingParameter.itemEachPageCount}&page=${productPagingParameter.page}";
      return await dio.get("/product$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<Product>>(onMap: (value) => value.wrapResponse().mapFromResponseToPagingDataResult(
          (dataResponse) => dataResponse.map<Product>(
            (productResponse) => ResponseWrapper(productResponse).mapFromResponseToProduct(favoriteProductBrandListResult)
          ).toList()
        ));
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductBrand>> productBrandPaging(ProductBrandPagingParameter productBrandPagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      String pageParameterPath = "/?pageNumber=${productBrandPagingParameter.itemEachPageCount}&page=${productBrandPagingParameter.page}";
      return await dio.get("/product/brand$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandPaging(favoriteProductBrandListResult));
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductCategory>> productCategoryPaging(ProductCategoryPagingParameter productCategoryPagingParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String pageParameterPath = "/?pageNumber=${productCategoryPagingParameter.itemEachPageCount}&page=${productCategoryPagingParameter.page}";
      return dio.get("/product/category$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ProductCategory>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductCategoryPaging());
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductBundle>> productBundlePaging(ProductBundlePagingParameter productBundlePagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      String pageParameterPath = "/?pageNumber=${productBundlePagingParameter.itemEachPageCount}&page=${productBundlePagingParameter.page}";
      return await dio.get("/bundling$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ProductBundle>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundlePaging(wishlistListResult, cartListResult));
    });
  }

  @override
  FutureProcessing<ProductBundle> productBundleHighlight(ProductBundleHighlightParameter productBundleHighlightParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      String pageParameterPath = "/?pageNumber=1&page=1";
      return await dio.get("/bundling$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<ProductBundle>>(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundlePaging(wishlistListResult, cartListResult))
        .map<ProductBundle>(onMap: (value) {
          if (value.itemList.isEmpty) {
            throw NotFoundError();
          }
          return value.itemList.first;
        });
    });
  }

  @override
  FutureProcessing<PagingDataResult<ProductEntry>> productWithConditionPaging(ProductWithConditionPagingParameter productWithConditionPagingParameter) {
    Map<String, dynamic> queryParameters = {
      "page": productWithConditionPagingParameter.page,
      "pageNumber": productWithConditionPagingParameter.itemEachPageCount,
      ...productWithConditionPagingParameter.withCondition
    };
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      var productEntryResultPagingDataResult = await dio.get("/product/entry", queryParameters: queryParameters, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging(wishlistListResult, cartListResult));
      if (productWithConditionPagingParameter.onInterceptProductPagingDataResult != null) {{
        return productWithConditionPagingParameter.onInterceptProductPagingDataResult!(productEntryResultPagingDataResult);
      }}
      return productEntryResultPagingDataResult;
    });
  }

  @override
  FutureProcessing<ProductDetail> productDetail(ProductDetailParameter productDetailParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/product/${productDetailParameter.productId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductDetail(wishlistListResult, favoriteProductBrandListResult, cartListResult));
    });
  }

  @override
  FutureProcessing<ProductBrandDetail> productBrandDetail(ProductBrandDetailParameter productBrandDetailParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<FavoriteProductBrand> favoriteProductBrandListResult = await _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter()).future(parameter: cancelToken);
      late String lastPathEndpoint;
      if (productBrandDetailParameter.productBrandDetailParameterType == ProductCategoryDetailParameterType.slug) {
        lastPathEndpoint = "slug/${productBrandDetailParameter.productBrandId}";
      } else {
        lastPathEndpoint = productBrandDetailParameter.productBrandId;
      }
      return await dio.get("/product/brand/$lastPathEndpoint", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductBrandDetail(favoriteProductBrandListResult));
    });
  }

  // Mas untuk yang bagian kenapa banner brandnya error di load itu karena response dari get product brand detail (v1/mobile/product/brand/966fb13a-f3fd-4151-8ccc-0f13082e68cc) itu fieldnya ada yang hilang,

  @override
  FutureProcessing<ProductCategoryDetail> productCategoryDetail(ProductCategoryDetailParameter productCategoryDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      late String lastPathEndpoint;
      if (productCategoryDetailParameter.productCategoryDetailParameterType == ProductCategoryDetailParameterType.slug) {
        lastPathEndpoint = "slug/${productCategoryDetailParameter.productCategoryDetailId}";
      } else {
        lastPathEndpoint = productCategoryDetailParameter.productCategoryDetailId;
      }
      return dio.get("/product/category/$lastPathEndpoint", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductCategoryDetail());
    });
  }

  @override
  FutureProcessing<ProductBundleDetail> productBundleDetail(ProductBundleDetailParameter productBundleDetailParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/bundling/${productBundleDetailParameter.productBundleId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductBundleDetail(wishlistListResult, cartListResult));
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailFromYourSearchProductEntryList(ProductDetailFromYourSearchProductEntryListParameter productDetailFromYourSearchProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/product/entry", queryParameters: {"fyp": true, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging(wishlistListResult, cartListResult).itemList);
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailOtherChosenForYouProductEntryList(ProductDetailOtherChosenForYouProductEntryListParameter productDetailOtherChosenForYouProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return dio.get("/product/entry", queryParameters: {"fyp": true, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging(wishlistListResult, cartListResult).itemList);
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailOtherFromThisBrandProductEntryList(ProductDetailOtherFromThisBrandProductEntryListParameter productDetailOtherFromThisBrandProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/product/entry", queryParameters: {"brand": productDetailOtherFromThisBrandProductEntryListParameter.brandSlug, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging(wishlistListResult, cartListResult).itemList);
    });
  }

  @override
  FutureProcessing<List<ProductEntry>> productDetailOtherInThisCategoryProductEntryList(ProductDetailOtherInThisCategoryProductEntryListParameter productDetailOtherInThisCategoryProductEntryListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Wishlist> wishlistListResult = await _wishlistListIgnoringLoginError(WishlistListParameter()).future(parameter: cancelToken);
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return dio.get("/product/entry", queryParameters: {"category": productDetailOtherInThisCategoryProductEntryListParameter.categorySlug, "page": 1, "pageNumber": 10}, cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToProductEntryPaging(wishlistListResult, cartListResult).itemList);
    });
  }

  @override
  FutureProcessing<List<ProductBrand>> productDetailOtherInterestedProductBrandListParameter(ProductDetailOtherInterestedProductBrandListParameter productDetailOtherInterestedProductBrandListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<ProductBrand> productBrandList = await productBrandPaging(
        ProductBrandPagingParameter(page: 1)
      ).map(
        onMap: (value) => value.itemList
      ).future(
        parameter: cancelToken
      );
      return productBrandList;
    });
  }

  @override
  FutureProcessing<List<Wishlist>> wishlistList(WishlistListParameter wishlistListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/user/wishlist", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToWishlistList(cartListResult));
    });
  }

  FutureProcessing<List<Wishlist>> _wishlistListIgnoringLoginError(WishlistListParameter wishlistListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      try {
        return await wishlistList(wishlistListParameter).future(parameter: cancelToken);
      } on DioError catch (e) {
        Error error = ErrorHelper.generatePleaseLoginFirstError(e);
        if (error is PleaseLoginFirstError) {
          return [];
        } else {
          error = ErrorHelper.generateEmptyError(e);
          if (error is EmptyError) {
            return [];
          }
        }
        rethrow;
      } catch (e) {
        rethrow;
      }
    });
  }

  @override
  FutureProcessing<PagingDataResult<Wishlist>> wishlistPaging(WishlistPagingParameter wishlistPagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      String pageParameterPath = "/?pageNumber=${wishlistPagingParameter.itemEachPageCount}&page=${wishlistPagingParameter.page}";
      List<Cart> cartListResult = await cartDataSource.cartListIgnoringLoginError(CartListParameter()).future(parameter: cancelToken);
      return await dio.get("/user/wishlist$pageParameterPath", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToWishlistPaging(cartListResult));
    });
  }

  @override
  FutureProcessing<AddWishlistResponse> addWishlist(AddWishlistParameter addWishlistParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      SupportWishlist supportWishlist = addWishlistParameter.supportWishlist;
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          if (supportWishlist is ProductEntryAppearanceData) "product_entry_id": (supportWishlist as ProductEntryAppearanceData).productEntryId,
          if (supportWishlist is ProductBundle) "bundling_id": supportWishlist.id,
        }
      );
      return dio.post("/user/wishlist", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AddWishlistResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAddWishlistResponse());
    });
  }

  @override
  FutureProcessing<RemoveWishlistResponse> removeWishlist(RemoveWishlistParameter removeWishlistParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.delete("/user/wishlist/${removeWishlistParameter.wishlistId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveWishlistResponse());
    });
  }

  @override
  FutureProcessing<RemoveWishlistResponse> removeWishlistBasedProduct(RemoveWishlistBasedProductParameter removeWishlistBasedProductParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.delete("/user/wishlist/product/${removeWishlistBasedProductParameter.productEntryOrProductBundleId}", cancelToken: cancelToken)
        .map(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveWishlistResponse());
    });
  }

  @override
  FutureProcessing<PagingDataResult<FavoriteProductBrand>> favoriteProductBrandPaging(FavoriteProductBrandPagingParameter favoriteProductBrandPagingParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      String pageParameterPath = "/?pageNumber=${favoriteProductBrandPagingParameter.itemEachPageCount}&page=${favoriteProductBrandPagingParameter.page}";
      return await dio.get("/user/brand-fav$pageParameterPath", cancelToken: cancelToken)
        .map<PagingDataResult<FavoriteProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToFavoriteProductBrandPaging());
    });
  }

  @override
  FutureProcessing<List<FavoriteProductBrand>> favoriteProductBrandList(FavoriteProductBrandListParameter favoriteProductBrandListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      return await dio.get("/user/brand-fav", cancelToken: cancelToken)
        .map<List<FavoriteProductBrand>>(onMap: (value) => value.wrapResponse().mapFromResponseToFavoriteProductBrandList());
    });
  }

  FutureProcessing<List<FavoriteProductBrand>> _favoriteProductBrandListIgnoringLoginError(FavoriteProductBrandListParameter favoriteProductBrandListParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      try {
        return await favoriteProductBrandList(favoriteProductBrandListParameter).future(parameter: cancelToken);
      } on DioError catch (e) {
        Error error = ErrorHelper.generatePleaseLoginFirstError(e);
        if (error is PleaseLoginFirstError) {
          return [];
        } else {
          error = ErrorHelper.generateEmptyError(e);
          if (error is EmptyError) {
            return [];
          }
        }
        rethrow;
      } catch (e) {
        rethrow;
      }
    });
  }

  @override
  FutureProcessing<AddToFavoriteProductBrandResponse> addToFavoriteProductBrand(AddToFavoriteProductBrandParameter addToFavoriteProductBrandParameter) {
    return DummyFutureProcessing((parameter) async {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "product_brand_id": addToFavoriteProductBrandParameter.productBrand.id
        }
      );
      return dio.post("/user/brand-fav", data: formData, cancelToken: parameter, options: OptionsBuilder.multipartData().build())
        .map<AddToFavoriteProductBrandResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAddToFavoriteProductBrandResponse());
    });
  }

  @override
  FutureProcessing<RemoveFromFavoriteProductBrandResponse> removeFromFavoriteProductBrand(RemoveFromFavoriteProductBrandParameter removeFromFavoriteProductBrandParameter) {
    return DummyFutureProcessing((parameter) async {
      return dio.delete("/user/brand-fav/${removeFromFavoriteProductBrandParameter.favoriteProductBrand.id}", cancelToken: parameter)
        .map<RemoveFromFavoriteProductBrandResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToRemoveFromFavoriteProductBrandResponse());
    });
  }
}