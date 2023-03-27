import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/province_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/product/product.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../../domain/entity/product/productcertification/product_certification.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/product/productvariant/product_variant.dart';
import '../../domain/entity/product/short_product.dart';
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
}

extension ProductBundleMappingExt on ResponseWrapper {
  List<ProductBundle> mapFromResponseToProductBundleList() {
    return response.map<ProductBundle>((productBundleResponse) => ResponseWrapper(productBundleResponse).mapFromResponseToProductBundle()).toList();
  }
}

extension ProductBundleDetailEntityMappingExt on ResponseWrapper {
  ProductBundle mapFromResponseToProductBundle() {
    return ProductBundle(
      id: response["id"],
      name: response["name"],
      description: response["description"],
      slug: response["slug"],
      imageUrl: response["image_url"],
    );
  }
}

extension ProductBrandDetailMappingExt on ResponseWrapper {
  List<ProductBrand> mapFromResponseToProductBrandList() {
    return response.map<ProductBrand>((productBrandResponse) => ResponseWrapper(productBrandResponse).mapFromResponseToProductBrand()).toList();
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
      sku: response["sku"],
      sustension: response["sustension"],
      weight: ResponseWrapper(response["weight"]).mapFromResponseToDouble()!,
      isViral: response["is_viral"],
      isKitchen: response["is_kitchen"],
      isHandycrafts: response["is_handycrafts"],
      isFashionable: response["is_fashionable"],
      isBestSelling: response["is_best_selling"],
      sellingPrice: response["selling_price"],
      productVariantList: response["product_variant"].map<ProductVariant>(
        (productVariantResponse) => ResponseWrapper(productVariantResponse).mapFromResponseToProductVariant()
      ).toList(),
      product: ResponseWrapper(response["product"]).mapFromResponseToProduct(),
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