import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/province_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/product/product.dart';
import '../../domain/entity/product/product_detail.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../../domain/entity/product/productcategory/product_category_detail.dart';
import '../../domain/entity/product/productcertification/product_certification.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/product/productvariant/product_variant.dart';
import '../../domain/entity/product/short_product.dart';
import '../../domain/entity/wishlist/add_wishlist_response.dart';
import '../../domain/entity/wishlist/remove_wishlist_response.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/response_wrapper.dart';

extension ShortProductEntityMappingExt on ResponseWrapper {
  List<ShortProduct> mapFromResponseToShortProductList() {
    return response.map<ShortProduct>((shortProductResponse) => ResponseWrapper(shortProductResponse).mapFromResponseToShortProduct()).toList();
  }

  PagingDataResult<ShortProduct> mapFromResponseToShortProductPagingDataResult() {
    return response.map<ShortProduct>((shortProductResponse) => ResponseWrapper(shortProductResponse).mapFromResponseToShortProduct()).toList();
  }
}

extension ProductEntityMappingExt on ResponseWrapper {
  List<Product> mapFromResponseToProductList() {
    return response.map<Product>((productResponse) => ResponseWrapper(productResponse).mapFromResponseToProduct()).toList();
  }

  PagingDataResult<Product> mapFromResponseToProductPagingDataResult() {
    return response.map<Product>((productResponse) => ResponseWrapper(productResponse).mapFromResponseToProduct()).toList();
  }
}

extension ShortProductDetailEntityMappingExt on ResponseWrapper {
  ShortProduct mapFromResponseToShortProduct() {
    return ShortProduct(
      id: response["id"],
      userId: response["user_id"],
      productBrandId: response["product_brand_id"],
      productCategoryId: response["product_category_id"],
      provinceId: response["province_id"],
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      price: 100000,
      discountPrice: null,
      rating: 5.0,
      imageUrl: "",
    );
  }
}

extension ProductDetailEntityMappingExt on ResponseWrapper {
  Product mapFromResponseToProduct() {
    return Product(
      id: response["id"],
      userId: response["user_id"],
      productBrandId: response["product_brand_id"],
      productCategoryId: response["product_category_id"],
      provinceId: response["province_id"],
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      price: 100000,
      discountPrice: null,
      rating: 5.0,
      imageUrl: "",
      productBrand: ResponseWrapper(response["product_brand"]).mapFromResponseToProductBrand(),
      productCategory: ResponseWrapper(response["product_category"]).mapFromResponseToProductCategory(),
      province: ResponseWrapper(response["province"]).mapFromResponseToProvince(),
      productCertificationList: ResponseWrapper(response["product_certification"]).mapFromResponseToProductCertificationList(),
    );
  }

  ProductDetail mapFromResponseToProductDetail() {
    Product product = ResponseWrapper(response).mapFromResponseToProduct();
    return ProductDetail(
      id: product.id,
      userId: product.userId,
      productBrandId: product.productBrandId,
      productCategoryId: product.productCategoryId,
      provinceId: product.provinceId,
      name: product.name,
      slug: product.slug,
      description: product.description,
      price: product.price,
      discountPrice: product.discountPrice,
      rating: product.rating,
      imageUrl: product.imageUrl,
      productBrand: product.productBrand,
      productCategory: product.productCategory,
      province: product.province,
      productCertificationList: product.productCertificationList,
      productEntry: ResponseWrapper(response["product_entry"]).mapFromResponseToProductEntryList()
    );
  }
}

extension ProductBundleMappingExt on ResponseWrapper {
  List<ProductBundle> mapFromResponseToProductBundleList() {
    return response.map<ProductBundle>((productBundleResponse) => ResponseWrapper(productBundleResponse).mapFromResponseToProductBundle()).toList();
  }

  PagingDataResult<ProductBundle> mapFromResponseToProductBundlePaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductBundle>(
        (productBundleResponse) => ResponseWrapper(productBundleResponse).mapFromResponseToProductBundle()
      ).toList()
    );
  }
}

extension ProductBundleDetailEntityMappingExt on ResponseWrapper {
  ProductBundle mapFromResponseToProductBundle() {
    return ProductBundle(
      id: response["id"],
      name: response["name"],
      description: "",
      slug: response["slug"],
      imageUrl: response["banner"],
      price: ResponseWrapper(response["price"]).mapFromResponseToDouble()!,
      rating: 0.0,
      soldOut: response["sold"] ?? 0
    );
  }

  ProductBundleDetail mapFromResponseToProductBundleDetail() {
    return ProductBundleDetail(
      id: response["id"],
      name: response["name"],
      description: "",
      slug: response["slug"],
      imageUrl: response["banner"],
      price: ResponseWrapper(response["price"]).mapFromResponseToDouble()!,
      rating: 0.0,
      shortProductList: ResponseWrapper(response["product"]).mapFromResponseToShortProductList(),
      soldOut: response["sold"] ?? 0
    );
  }
}

extension ProductBrandDetailMappingExt on ResponseWrapper {
  List<ProductBrand> mapFromResponseToProductBrandList() {
    return response.map<ProductBrand>((productBrandResponse) => ResponseWrapper(productBrandResponse).mapFromResponseToProductBrand()).toList();
  }

  PagingDataResult<ProductBrand> mapFromResponseToProductBrandPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductBrand>(
        (productBrandResponse) => ResponseWrapper(productBrandResponse).mapFromResponseToProductBrand()
      ).toList()
    );
  }
}

extension ProductBrandDetailEntityMappingExt on ResponseWrapper {
  ProductBrand mapFromResponseToProductBrand() {
    return ProductBrand(
      id: response["id"],
      name: response["name"],
      slug: response["slug"],
      icon: response["icon"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"]
    );
  }

  ProductBrandDetail mapFromResponseToProductBrandDetail() {
    return ProductBrandDetail(
      id: response["id"],
      name: response["name"],
      slug: response["slug"],
      icon: response["icon"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"],
      shortProductList: ResponseWrapper(response["product"]).mapFromResponseToShortProductList()
    );
  }
}

extension ProductCategoryEntityMappingExt on ResponseWrapper {
  List<ProductCategory> mapFromResponseToProductCategoryList() {
    return response.map<ProductCategory>((productCategoryResponse) => ResponseWrapper(productCategoryResponse).mapFromResponseToProductCategory()).toList();
  }

  PagingDataResult<ProductCategory> mapFromResponseToProductCategoryPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductCategory>(
        (productCategoryResponse) => ResponseWrapper(productCategoryResponse).mapFromResponseToProductCategory()
      ).toList()
    );
  }
}

extension ProductCategoryDetailEntityMappingExt on ResponseWrapper {
  ProductCategory mapFromResponseToProductCategory() {
    return ProductCategory(
      id: response["id"],
      name: response["name"],
      slug: response["slug"],
      icon: response["icon"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"],
    );
  }

  ProductCategoryDetail mapFromResponseToProductCategoryDetail() {
    return ProductCategoryDetail(
      id: response["id"],
      name: response["name"],
      slug: response["slug"],
      icon: response["icon"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"],
      shortProductList: response["product"] != null ? ResponseWrapper(response["product"]).mapFromResponseToShortProductList() : []
    );
  }
}

extension ProductCertificationEntityMappingExt on ResponseWrapper {
  List<ProductCertification> mapFromResponseToProductCertificationList() {
    return response.map<ProductCertification>((productCertificationResponse) => ResponseWrapper(productCertificationResponse).mapFromResponseToProductCertification()).toList();
  }
}

extension ProductCertificationDetailEntityMappingExt on ResponseWrapper {
  ProductCertification mapFromResponseToProductCertification() {
    return ProductCertification(
      id: response["id"],
      productId: response["product_id"],
      name: response["name"]
    );
  }
}

extension ProductEntryEntityMappingExt on ResponseWrapper {
  List<ProductEntry> mapFromResponseToProductEntryList() {
    return response.map<ProductEntry>((productEntryResponse) => ResponseWrapper(productEntryResponse).mapFromResponseToProductEntry()).toList();
  }

  PagingDataResult<ProductEntry> mapFromResponseToProductEntryPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductEntry>(
        (productResponse) => ResponseWrapper(productResponse).mapFromResponseToProductEntry()
      ).toList()
    );
  }
}

extension ProductEntryDetailEntityMappingExt on ResponseWrapper {
  ProductEntry mapFromResponseToProductEntry() {
    return ProductEntry(
      id: response["id"],
      productId: response["product_id"],
      productEntryId: response["id"],
      sku: response["sku"],
      sustension: response["sustension"],
      weight: ResponseWrapper(response["weight"]).mapFromResponseToDouble()!,
      isViral: response["is_viral"],
      isKitchen: response["is_kitchen"],
      isHandycrafts: response["is_handycrafts"],
      isFashionable: response["is_fashionable"],
      isBestSelling: response["is_best_selling"],
      purchasePrice: response["purchase_price"] ?? 0,
      sellingPrice: response["selling_price"] ?? 0,
      imageUrlList: (response["product_image"] ?? []).map<String>(
        (productImageResponse) => productImageResponse["path"] as String
      ).toList(),
      productVariantList: response["product_variant"].map<ProductVariant>(
        (productVariantResponse) => ResponseWrapper(productVariantResponse).mapFromResponseToProductVariant()
      ).toList(),
      product: ResponseWrapper(response["product"]).mapFromResponseToProduct(),
      soldCount: response["sold"]
    );
  }
}

extension ProductVariantEntityMappingExt on ResponseWrapper {
  List<ProductVariant> mapFromResponseToProductVariantList() {
    return response.map<ProductVariant>((productVariantResponse) => ResponseWrapper(productVariantResponse).mapFromResponseToProductVariant()).toList();
  }
}

extension ProductVariantDetailEntityMappingExt on ResponseWrapper {
  ProductVariant mapFromResponseToProductVariant() {
    return ProductVariant(
      id: response["id"],
      productEntryId: response["product_entry_id"],
      name: response["name"],
      type: response["type"],
    );
  }
}

extension WishlistEntityMappingExt on ResponseWrapper {
  List<Wishlist> mapFromResponseToWishlistList() {
    return response.map<Wishlist>((wishlistResponse) => ResponseWrapper(wishlistResponse).mapFromResponseToWishlist()).toList();
  }

  PagingDataResult<Wishlist> mapFromResponseToWishlistPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Wishlist>(
        (wishlistResponse) => ResponseWrapper(wishlistResponse).mapFromResponseToWishlist()
      ).toList()
    );
  }
}

extension WishlistDetailEntityMappingExt on ResponseWrapper {
  Wishlist mapFromResponseToWishlist() {
    return Wishlist(
      id: response["id"],
      productEntry: ResponseWrapper(response["product"]).mapFromResponseToProductEntry()
    );
  }

  AddWishlistResponse mapFromResponseToAddWishlistResponse() {
    return AddWishlistResponse();
  }

  RemoveWishlistResponse mapFromResponseToRemoveWishlistResponse() {
    return RemoveWishlistResponse();
  }
}