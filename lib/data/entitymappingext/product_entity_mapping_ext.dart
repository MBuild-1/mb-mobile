import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/province_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/product/product.dart';
import '../../domain/entity/product/product_detail.dart';
import '../../domain/entity/product/product_in_discussion.dart';
import '../../domain/entity/product/productbrand/add_to_favorite_product_brand_response.dart';
import '../../domain/entity/product/productbrand/favorite_product_brand.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbrand/product_brand_detail.dart';
import '../../domain/entity/product/productbrand/remove_from_favorite_product_brand_response.dart';
import '../../domain/entity/product/productbrand/selected_product_brand.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productbundle/product_bundle_detail.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../../domain/entity/product/productcategory/product_category_detail.dart';
import '../../domain/entity/product/productcertification/product_certification.dart';
import '../../domain/entity/product/productdiscussion/create_product_discussion_response.dart';
import '../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../domain/entity/product/productdiscussion/product_discussion_user.dart';
import '../../domain/entity/product/productdiscussion/reply_product_discussion_response.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../domain/entity/product/productvariant/product_variant.dart';
import '../../domain/entity/product/shareproduct/share_product_response.dart';
import '../../domain/entity/product/short_product.dart';
import '../../domain/entity/wishlist/add_wishlist_response.dart';
import '../../domain/entity/wishlist/remove_wishlist_response.dart';
import '../../domain/entity/wishlist/support_wishlist.dart';
import '../../domain/entity/wishlist/wishlist.dart';
import '../../misc/error/message_error.dart';
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
  List<Product> mapFromResponseToProductList(List<FavoriteProductBrand> favoriteProductBrandList) {
    return response.map<Product>((productResponse) => ResponseWrapper(productResponse).mapFromResponseToProduct(favoriteProductBrandList)).toList();
  }

  PagingDataResult<Product> mapFromResponseToProductPagingDataResult(List<FavoriteProductBrand> favoriteProductBrandList) {
    return response.map<Product>((productResponse) => ResponseWrapper(productResponse).mapFromResponseToProduct(favoriteProductBrandList)).toList();
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
  Product mapFromResponseToProduct(List<FavoriteProductBrand> favoriteProductBrandList) {
    return Product(
      id: response["id"],
      userId: response["user_id"],
      productBrandId: response["product_brand_id"],
      productCategoryId: response["product_category_id"],
      provinceId: response["province_id"],
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      price: 0,
      discountPrice: null,
      rating: 5.0,
      imageUrl: "",
      productBrand: ResponseWrapper(response["product_brand"]).mapFromResponseToProductBrand(favoriteProductBrandList),
      productCategory: ResponseWrapper(response["product_category"]).mapFromResponseToProductCategory(),
      province: response["province"] != null ? ResponseWrapper(response["province"]).mapFromResponseToProvince() : null,
      productCertificationList: response["product_certification"] != null ? ResponseWrapper(response["product_certification"]).mapFromResponseToProductCertificationList() : [],
    );
  }

  ProductDetail mapFromResponseToProductDetail(List<Wishlist> wishlistList, List<FavoriteProductBrand> favoriteProductBrandList, List<Cart> cartList) {
    Product product = ResponseWrapper(response).mapFromResponseToProduct(favoriteProductBrandList);
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
      productEntry: ResponseWrapper(response["product_entry"]).mapFromResponseToProductEntryList(wishlistList, cartList)
    );
  }
}

extension ProductBundleMappingExt on ResponseWrapper {
  List<ProductBundle> mapFromResponseToProductBundleList(List<Wishlist> wishlistList, List<Cart> cartList) {
    return response.map<ProductBundle>((productBundleResponse) => ResponseWrapper(productBundleResponse).mapFromResponseToProductBundle(wishlistList, cartList)).toList();
  }

  PagingDataResult<ProductBundle> mapFromResponseToProductBundlePaging(List<Wishlist> wishlistList, List<Cart> cartList) {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductBundle>(
        (productBundleResponse) => ResponseWrapper(productBundleResponse).mapFromResponseToProductBundle(wishlistList, cartList)
      ).toList()
    );
  }
}

extension ProductBundleDetailEntityMappingExt on ResponseWrapper {
  ProductBundle mapFromResponseToProductBundle(List<Wishlist> wishlistList, List<Cart> cartList) {
    String productBundleId = response["id"];
    return ProductBundle(
      id: productBundleId,
      name: response["name"],
      description: "",
      slug: response["slug"],
      imageUrl: response["banner_mobile"],
      price: ResponseWrapper(response["price"]).mapFromResponseToDouble()!,
      rating: 0.0,
      soldOut: response["sold"] ?? 0,
      hasAddedToWishlist: response["has_added_to_wishlist"] ?? wishlistList.where((wishlist) {
        if (wishlist.supportWishlist is ProductBundle) {
          return (wishlist.supportWishlist as ProductBundle).id == productBundleId;
        }
        return false;
      }).isNotEmpty,
      hasAddedToCart: response["has_added_to_cart"] ?? cartList.where((cart) {
        if (cart.supportCart is ProductBundle) {
          return (cart.supportCart as ProductBundle).id == productBundleId;
        }
        return false;
      }).isNotEmpty,
    );
  }

  ProductBundleDetail mapFromResponseToProductBundleDetail(List<Wishlist> wishlistList, List<Cart> cartList) {
    String productBundleId = response["id"];
    return ProductBundleDetail(
      id: productBundleId,
      name: response["name"],
      description: "",
      slug: response["slug"],
      imageUrl: response["banner_mobile"],
      price: ResponseWrapper(response["price"]).mapFromResponseToDouble()!,
      rating: 0.0,
      productEntryList: response["bundling_list"].map<ProductEntry>(
        (bundlingResponse) => ResponseWrapper(bundlingResponse["product_entry"]).mapFromResponseToProductEntry(wishlistList, cartList)
      ).toList(),
      soldOut: response["sold"] ?? 0,
      hasAddedToWishlist: response["has_added_to_wishlist"] ?? wishlistList.where((wishlist) {
        if (wishlist.supportWishlist is ProductBundle) {
          return (wishlist.supportWishlist as ProductBundle).id == productBundleId;
        }
        return false;
      }).isNotEmpty,
      hasAddedToCart: response["has_added_to_cart"] ?? cartList.where((cart) {
        if (cart.supportCart is ProductBundle) {
          return (cart.supportCart as ProductBundle).id == productBundleId;
        }
        return false;
      }).isNotEmpty
    );
  }
}

extension ProductBrandDetailMappingExt on ResponseWrapper {
  List<ProductBrand> mapFromResponseToProductBrandList(List<FavoriteProductBrand> favoriteProductBrandList) {
    return response.map<ProductBrand>((productBrandResponse) => ResponseWrapper(productBrandResponse).mapFromResponseToProductBrand(favoriteProductBrandList)).toList();
  }

  PagingDataResult<ProductBrand> mapFromResponseToProductBrandPaging(List<FavoriteProductBrand> favoriteProductBrandList) {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductBrand>(
        (productBrandResponse) => ResponseWrapper(productBrandResponse).mapFromResponseToProductBrand(favoriteProductBrandList)
      ).toList()
    );
  }

  List<FavoriteProductBrand> mapFromResponseToFavoriteProductBrandList() {
    return response.map<FavoriteProductBrand>((favoriteProductBrandResponse) => ResponseWrapper(favoriteProductBrandResponse).mapFromResponseToFavoriteProductBrand()).toList();
  }

  PagingDataResult<FavoriteProductBrand> mapFromResponseToFavoriteProductBrandPaging() {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<FavoriteProductBrand>(
        (favoriteProductBrandResponse) => ResponseWrapper(favoriteProductBrandResponse).mapFromResponseToFavoriteProductBrand()
      ).toList()
    );
  }
}

extension ProductBrandDetailEntityMappingExt on ResponseWrapper {
  ProductBrand mapFromResponseToFavoriteProductBrandDetail() {
    dynamic favoriteProductBrand = response["product_brand"];
    return ResponseWrapper(favoriteProductBrand).mapFromResponseToProductBrand([], isAddedToFavorite: true);
  }

  FavoriteProductBrand mapFromResponseToFavoriteProductBrand() {
    return FavoriteProductBrand(
      id: response["id"],
      productBrand: ResponseWrapper(response).mapFromResponseToFavoriteProductBrandDetail()
    );
  }

  ProductBrand mapFromResponseToProductBrand(List<FavoriteProductBrand> favoriteProductBrandList, {bool? isAddedToFavorite}) {
    String productBrandId = response["id"];
    ProductBrand productBrand = ProductBrand(
      id: productBrandId,
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      icon: response["icon"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"],
      isAddedToFavorite: isAddedToFavorite ?? favoriteProductBrandList.where((favoriteProductBrand) => favoriteProductBrand.productBrand.id == productBrandId).isNotEmpty
    );
    Map<String, dynamic> responseMap = response as Map<String, dynamic>;
    if (responseMap.containsKey("banner_brand_choosen_desktop") && responseMap.containsKey("banner_brand_choosen_mobile")) {
      return SelectedProductBrand(
        id: productBrand.id,
        name: productBrand.name,
        slug: productBrand.slug,
        description: productBrand.description,
        icon: productBrand.icon,
        bannerDesktop: productBrand.bannerMobile,
        bannerMobile: productBrand.bannerDesktop,
        isAddedToFavorite: productBrand.isAddedToFavorite,
        bannerBrandChosenDesktop: responseMap["banner_brand_choosen_desktop"],
        bannerBrandChosenMobile: responseMap["banner_brand_choosen_mobile"]
      );
    }
    return productBrand;
  }

  ProductBrandDetail mapFromResponseToProductBrandDetail(List<FavoriteProductBrand> favoriteProductBrandList) {
    String productBrandId = response["id"];
    return ProductBrandDetail(
      id: productBrandId,
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      icon: response["icon"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"],
      shortProductList: response["product"] != null ? ResponseWrapper(response["product"]).mapFromResponseToShortProductList() : [],
      isAddedToFavorite: favoriteProductBrandList.where((favoriteProductBrand) => favoriteProductBrand.productBrand.id == productBrandId).isNotEmpty
    );
  }

  AddToFavoriteProductBrandResponse mapFromResponseToAddToFavoriteProductBrandResponse() {
    return AddToFavoriteProductBrandResponse();
  }

  RemoveFromFavoriteProductBrandResponse mapFromResponseToRemoveFromFavoriteProductBrandResponse() {
    return RemoveFromFavoriteProductBrandResponse();
  }

  ShareProductResponse mapFromResponseToShareProductResponse() {
    return ShareProductResponse(
      link: "https://masterbagasi.com/share/p/${response["code"]}"
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
  List<ProductEntry> mapFromResponseToProductEntryList(List<Wishlist> wishlistList, List<Cart> cartList) {
    return response.map<ProductEntry>((productEntryResponse) => ResponseWrapper(productEntryResponse).mapFromResponseToProductEntry(wishlistList, cartList)).toList();
  }

  PagingDataResult<ProductEntry> mapFromResponseToProductEntryPaging(List<Wishlist> wishlistList, List<Cart> cartList) {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<ProductEntry>(
        (productResponse) => ResponseWrapper(productResponse).mapFromResponseToProductEntry(wishlistList, cartList)
      ).toList()
    );
  }
}

extension ProductEntryDetailEntityMappingExt on ResponseWrapper {
  ProductEntry mapFromResponseToProductEntry(List<Wishlist> wishlistList, List<Cart> cartList) {
    String productEntryId = response["id"];
    return ProductEntry(
      id: productEntryId,
      productId: response["product_id"],
      productEntryId: productEntryId,
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
      shareCode: response["product_share"] != null ? response["product_share"]!["code"] : null,
      product: ResponseWrapper(response["product"]).mapFromResponseToProduct([]),
      soldCount: response["sold"],
      hasAddedToWishlist: response["has_added_to_wishlist"] ?? wishlistList.where((wishlist) {
        if (wishlist.supportWishlist is ProductEntry) {
          return (wishlist.supportWishlist as ProductEntry).id == productEntryId;
        }
        return false;
      }).isNotEmpty,
      hasAddedToCart: response["has_added_to_cart"] ?? cartList.where((cart) {
        if (cart.supportCart is ProductEntry) {
          return (cart.supportCart as ProductEntry).id == productEntryId;
        }
        return false;
      }).isNotEmpty,
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
  List<Wishlist> mapFromResponseToWishlistList(List<Cart> cartList) {
    return response.map<Wishlist>((wishlistResponse) => ResponseWrapper(wishlistResponse).mapFromResponseToWishlist(cartList)).toList();
  }

  PagingDataResult<Wishlist> mapFromResponseToWishlistPaging(List<Cart> cartList) {
    return ResponseWrapper(response).mapFromResponseToPagingDataResult(
      (dataResponse) => dataResponse.map<Wishlist>(
        (wishlistResponse) => ResponseWrapper(wishlistResponse).mapFromResponseToWishlist(cartList)
      ).toList()
    );
  }
}

extension WishlistDetailEntityMappingExt on ResponseWrapper {
  Wishlist mapFromResponseToWishlist(List<Cart> cartList) {
    return Wishlist(
      id: response["id"],
      supportWishlist: ResponseWrapper(response).mapFromResponseToSupportWishlist([], cartList)
    );
  }

  AddWishlistResponse mapFromResponseToAddWishlistResponse() {
    return AddWishlistResponse();
  }

  RemoveWishlistResponse mapFromResponseToRemoveWishlistResponse() {
    return RemoveWishlistResponse();
  }

  SupportWishlist mapFromResponseToSupportWishlist(List<Wishlist> wishlistList, List<Cart> cartList) {
    dynamic productEntry = response["product_entry"];
    dynamic bundling = response["bundling"];
    if (productEntry != null) {
      return ResponseWrapper(productEntry).mapFromResponseToProductEntry(wishlistList, cartList);
    } else if (bundling != null) {
      return ResponseWrapper(bundling).mapFromResponseToProductBundle(wishlistList, cartList);
    } else {
      throw MessageError(message: "Support wishlist not suitable");
    }
  }
}

extension ProductDiscussionEntityMappingExt on ResponseWrapper {
  List<ProductDiscussion> mapFromResponseToProductDiscussionList() {
    return response.map<ProductDiscussion>((productDiscussionResponse) => ResponseWrapper(productDiscussionResponse).mapFromResponseToProductDiscussion()).toList();
  }
}

extension ProductDiscussionDetailEntityMappingExt on ResponseWrapper {
  ProductDiscussion mapFromResponseToProductDiscussion() {
    return ProductDiscussion(
      productDiscussionDialogList: response.map<ProductDiscussionDialog>(
        (productDiscussionDialogResponse) => ResponseWrapper(productDiscussionDialogResponse).mapFromResponseToProductDiscussionDialog()
      ).toList()
    );
  }

  ProductDiscussionDialog mapFromResponseToProductDiscussionDialog({
    ProductInDiscussion? productInDiscussion,
    String? productId,
    String? bundleId
  }) {
    String? newProductId;
    String? newBundleId;
    ProductInDiscussion? newProductInDiscussion;
    if (productId == null) {
      newProductId = response["product_id"];
    }
    if (bundleId == null) {
      newBundleId = response["bundle_id"];
    }
    if (productInDiscussion == null) {
      newProductInDiscussion = response["product"] != null ? ResponseWrapper(response["product"]).mapFromResponseToProductInDiscussion() : null;
    }
    return ProductDiscussionDialog(
      id: response["id"],
      productId: productId ?? newProductId,
      bundleId: bundleId ?? newBundleId,
      userId: response["user_id"],
      discussion: response["message"],
      discussionDate: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime(dateFormat: null)!,
      productDiscussionUser: ResponseWrapper(response["user"]).mapFromResponseToProductDiscussionUser(),
      productInDiscussion: productInDiscussion ?? newProductInDiscussion,
      replyProductDiscussionDialogList: response["sub_discussion_product"] != null ? response["sub_discussion_product"].map<ProductDiscussionDialog>(
        (replyProductDiscussionDialogResponse) => ResponseWrapper(replyProductDiscussionDialogResponse).mapFromResponseToProductDiscussionDialog(
          productInDiscussion: newProductInDiscussion,
          productId: newProductId,
          bundleId: newBundleId
        )
      ).toList() : []
    );
  }

  ProductInDiscussion mapFromResponseToProductInDiscussion() {
    return ProductInDiscussion(
      id: response["id"],
      userId: response["user_id"],
      productBrandId: response["product_brand_id"],
      name: response["name"],
      slug: response["slug"],
      description: response["description"],
      productCategoryId: response["product_category_id"],
      provinceId: response["product_category_id"]
    );
  }

  ProductDiscussionUser mapFromResponseToProductDiscussionUser() {
    return ProductDiscussionUser(
      id: response["id"],
      name: response["name"],
      role: response["role"],
      email: (response["email"] as String?).toEmptyStringNonNull,
      avatar: response["user_profile"]["avatar"],
    );
  }

  CreateProductDiscussionResponse mapFromResponseToCreateProductDiscussionResponse() {
    return CreateProductDiscussionResponse();
  }

  ReplyProductDiscussionResponse mapFromResponseToReplyProductDiscussionResponse() {
    return ReplyProductDiscussionResponse();
  }
}