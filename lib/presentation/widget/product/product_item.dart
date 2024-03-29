import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/cart/support_cart.dart';
import '../../../domain/entity/product/product_appearance_data.dart';
import '../../../domain/entity/wishlist/support_wishlist.dart';
import '../../../domain/entity/wishlist/wishlist.dart';
import '../../../misc/constant.dart';
import '../../../misc/load_data_result.dart';
import '../../../misc/page_restoration_helper.dart';
import '../../notifier/product_notifier.dart';
import '../../page/product_detail_page.dart';
import '../badge_indicator.dart';
import '../button/add_or_remove_cart_button.dart';
import '../button/add_or_remove_wishlist_button.dart';
import '../button/custombutton/sized_outline_gradient_button.dart';
import '../modified_divider.dart';
import '../modified_shimmer.dart';
import '../modified_svg_picture.dart';
import '../modified_vertical_divider.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../productbundle/product_bundle_item.dart';
import '../rating_indicator.dart';

typedef OnAddWishlistWithProductAppearanceData = void Function(ProductAppearanceData);
typedef OnRemoveWishlistWithProductAppearanceData = void Function(ProductAppearanceData);
typedef OnRemoveWishlistWithWishlist = void Function(Wishlist);
typedef OnAddCartWithProductAppearanceData = void Function(ProductAppearanceData);
typedef OnRemoveCartWithProductAppearanceData = void Function(ProductAppearanceData);

enum ShowContentType {
  onlyText, full
}

abstract class ProductItem extends StatelessWidget {
  final ProductAppearanceData productAppearanceData;
  final OnAddWishlistWithProductAppearanceData? onAddWishlist;
  final OnRemoveWishlistWithProductAppearanceData? onRemoveWishlist;
  final OnAddCartWithProductAppearanceData? onAddCart;
  final OnRemoveCartWithProductAppearanceData? onRemoveCart;

  @protected
  bool get showPicture => true;

  @protected
  bool get showBadge => true;

  @protected
  ShowContentType get showContent => ShowContentType.full;

  @protected
  String get priceString => _priceString(productAppearanceData.price.toDouble());

  @protected
  String? get discountPriceString {
    double? price = productAppearanceData.discountPrice;
    return price != null ? _priceString(price) : null;
  }

  Widget _nonDiscountPriceWidget(BuildContext context) {
    return Text(
      discountPriceString != null ? discountPriceString! : priceString,
      style: discountPriceString != null ? TextStyle(
        color: Theme.of(context).colorScheme.primary
      ) : const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _discountPriceWidget(BuildContext context) {
    return Text(
      priceString,
      style: TextStyle(
        color: Constant.colorProductItemDiscountOrNormal,
        decoration: TextDecoration.lineThrough,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis
    );
  }

  @protected
  Widget priceWidget(BuildContext context, Widget nonDiscountPriceWidget, Widget discountPriceWidget);

  @protected
  double? get itemWidth;

  const ProductItem({
    Key? key,
    required this.productAppearanceData,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart
  }) : super(key: key);

  String _priceString(double price) {
    if (price == 0.0) {
      return "Free".tr;
    } else {
      return price.toRupiah();
    }
  }

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = const BorderRadius.only(
      topRight: Radius.circular(16.0),
      bottomLeft: Radius.circular(16.0),
      bottomRight: Radius.circular(16.0)
    );
    String weight = "${productAppearanceData.weight.toWeightStringDecimalPlaced()} Kg";
    String soldCount = "No Sold Count".tr;
    bool isAddToWishlist = false;
    bool isAddToCart = false;
    void onWishlist(void Function(ProductAppearanceData)? onWishlistCallback) {
      if (onWishlistCallback != null) {
        if (productAppearanceData is ProductEntryAppearanceData) {
          onWishlistCallback((productAppearanceData as ProductEntryAppearanceData));
        } else {
          onWishlistCallback(productAppearanceData);
        }
      }
    }
    if (productAppearanceData is ProductEntryAppearanceData) {
      soldCount = "${"sold".tr} ${(productAppearanceData as ProductEntryAppearanceData).soldCount}";
      isAddToWishlist = (productAppearanceData as ProductEntryAppearanceData).hasAddedToWishlist;
      isAddToCart = (productAppearanceData as ProductEntryAppearanceData).hasAddedToCart;
    }
    return SizedBox(
      width: itemWidth,
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: Material(
          color: Colors.white,
          borderRadius: borderRadius,
          elevation: 3,
          child: InkWell(
            onTap: () => PageRestorationHelper.toProductDetailPage(
              context,
              DefaultProductDetailPageParameter(
                productId: productAppearanceData.productId,
                productEntryId: productAppearanceData is ProductEntryAppearanceData ? (productAppearanceData as ProductEntryAppearanceData).productEntryId : ""
              )
            ),
            borderRadius: borderRadius,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: borderRadius
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showPicture) ...[
                    AspectRatio(
                      aspectRatio: 1.0,
                      child: Stack(
                        children: [
                          ClipRRect(
                            child: ProductModifiedCachedNetworkImage(
                              imageUrl: productAppearanceData.imageUrl.toEmptyStringNonNull,
                            )
                          ),
                          if (showBadge) ...[
                            ..._productBadge()
                          ]
                        ],
                      )
                    ),
                  ],
                  if (showPicture) ...[
                    ModifiedDivider(
                      lineHeight: 3.5,
                      lineColor: Constant.colorGrey5
                    ),
                  ],
                  if (showContent == ShowContentType.full) ...[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tooltip(
                            message: productAppearanceData.name.toStringNonNull,
                            child: Text(
                              productAppearanceData.name.toStringNonNull,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                          ...() {
                            if (productAppearanceData is ProductEntryAppearanceData) {
                              String productVariantDescription = (productAppearanceData as ProductEntryAppearanceData).productVariantDescription;
                              if (productVariantDescription.isNotEmptyString) {
                                return <Widget>[
                                  const SizedBox(height: 8),
                                  Tooltip(
                                    message: productVariantDescription,
                                    child: Text(
                                      productVariantDescription,
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Constant.colorGrey
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ];
                              }
                            }
                            return <Widget>[];
                          }(),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: priceWidget(context, _nonDiscountPriceWidget(context), _discountPriceWidget(context)),
                              ),
                              SizedBox(width: 1.5.w),
                              const ModifiedVerticalDivider(
                                lineWidth: 1,
                                lineHeight: 20,
                                lineColor: Colors.black,
                              ),
                              const SizedBox(width: 15),
                              Text(weight, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold)),
                            ]
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(soldCount, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Consumer<ProductNotifier>(
                            builder: (_, productNotifier, __) {
                              LoadDataResult<bool> isAddToWishlist = productNotifier.isAddToWishlist(productAppearanceData as SupportWishlist);
                              LoadDataResult<bool> isAddToCart = productNotifier.isAddToCart(productAppearanceData as SupportCart);
                              return Row(
                                children: [
                                  Builder(
                                    builder: (context) {
                                      Widget result = AddOrRemoveWishlistButton(
                                        onAddWishlist: onAddWishlist != null ? () => onWishlist(onAddWishlist) : null,
                                        onRemoveWishlist: onRemoveWishlist != null ? () => onWishlist(onRemoveWishlist) : null,
                                        isAddToWishlist: isAddToWishlist.isSuccess ? isAddToWishlist.resultIfSuccess! : false,
                                      );
                                      return isAddToWishlist.isSuccess ? result : ModifiedShimmer.fromColors(child: result);
                                    }
                                  ),
                                  SizedBox(width: 1.5.w),
                                  Expanded(
                                    child: Builder(
                                      builder: (context) {
                                        Widget result = AddOrRemoveCartButton(
                                          onAddCart: onAddCart != null ? () => onAddCart!(productAppearanceData) : null,
                                          isAddToCart: isAddToCart.isSuccess ? isAddToCart.resultIfSuccess! : false,
                                          isLoading: !isAddToCart.isSuccess
                                        );
                                        return isAddToCart.isSuccess ? result : ModifiedShimmer.fromColors(child: result);
                                      }
                                    )
                                  )
                                ],
                              );
                            }
                          )
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Tooltip(
                            message: productAppearanceData.name.toStringNonNull,
                            child: Text(
                              productAppearanceData.name.toStringNonNull,
                              style: const TextStyle(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis
                            ),
                          ),
                        ]
                      )
                    )
                  ]
                ],
              )
            )
          )
        ),
      )
    );
  }

  List<Widget> _productBadge() {
    List<Widget> result = [];
    void addBadgeResult(BadgeIndicatorType badgeIndicatorType) {
      Widget addedResult = BadgeIndicator(
        paddingLeft: result.isNotEmpty ? 10 : null,
        badgeIndicatorType: badgeIndicatorType,
      );
      addedResult = Positioned(
        left: result.isNotEmpty ? 70 : null,
        child: addedResult,
      );
      result.insert(0, addedResult);
    }
    if (productAppearanceData is ProductEntryAppearanceData) {
      ProductEntryAppearanceData productEntryAppearanceData = productAppearanceData as ProductEntryAppearanceData;
      if (productEntryAppearanceData.isViral == 1) {
        addBadgeResult(IsViralBadgeIndicatorType());
      }
      if (productEntryAppearanceData.isBestSelling == 1) {
        addBadgeResult(BestsellerBadgeIndicatorType());
      }
    }
    return result;
  }
}