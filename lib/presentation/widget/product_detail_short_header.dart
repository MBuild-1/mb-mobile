import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/presentation/widget/product/product_item.dart';
import 'package:share_plus/share_plus.dart';

import '../../domain/entity/product/product_appearance_data.dart';
import '../../domain/entity/product/product_detail.dart';
import '../../domain/entity/product/productentry/product_entry.dart';
import '../../misc/constant.dart';
import '../../misc/product_helper.dart';
import 'button/add_or_remove_wishlist_button.dart';
import 'modified_svg_picture.dart';
import 'modified_vertical_divider.dart';
import 'tap_area.dart';

class ProductDetailShortHeader extends StatelessWidget {
  final ProductDetail productDetail;
  final int Function() onGetProductEntryIndex;
  final void Function(String?) onShareProduct;
  final OnAddWishlistWithProductAppearanceData? onAddWishlist;
  final OnRemoveWishlistWithProductAppearanceData? onRemoveWishlist;

  const ProductDetailShortHeader({
    super.key,
    required this.productDetail,
    required this.onGetProductEntryIndex,
    required this.onShareProduct,
    this.onAddWishlist,
    this.onRemoveWishlist
  });

  @override
  Widget build(BuildContext context) {
    List<ProductEntry> productEntryList = productDetail.productEntry;
    int productEntryIndex = onGetProductEntryIndex();
    ProductEntry? selectedProductEntry = ProductHelper.getSelectedProductEntry(
      productEntryList, productEntryIndex
    );
    void onWishlist(void Function(ProductAppearanceData)? onWishlistCallback) {
      if (onWishlistCallback != null) {
        if (selectedProductEntry == null) {
          return;
        }
        onWishlistCallback(selectedProductEntry);
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: Constant.paddingListItem),
      color: Colors.grey.shade200,
      child: selectedProductEntry != null ? Row(
        children: [
          Expanded(
            child: Text(
              selectedProductEntry.sellingPrice.toRupiah(),
              style: TextStyle(
                color: Constant.colorDarkBlue,
                fontSize: 20,
                fontWeight: FontWeight.bold
              )
            )
          ),
          const SizedBox(width: 10),
          const ModifiedVerticalDivider(
            lineWidth: 1,
            lineHeight: 20,
            lineColor: Colors.black,
          ),
          const SizedBox(width: 10),
          Text(
            "${selectedProductEntry.weight.toWeightStringDecimalPlaced()} Kg",
            style: TextStyle(
              color: Constant.colorMain,
              fontWeight: FontWeight.bold
            )
          ),
          const SizedBox(width: 10),
          const ModifiedVerticalDivider(
            lineWidth: 1,
            lineHeight: 20,
            lineColor: Colors.black,
          ),
          const SizedBox(width: 4),
          AddOrRemoveWishlistButton(
            onAddWishlist: onAddWishlist != null ? () => onWishlist(onAddWishlist) : null,
            onRemoveWishlist: onRemoveWishlist != null ? () => onWishlist(onRemoveWishlist) : null,
            isTransparent: true,
            isAddToWishlist: selectedProductEntry.hasAddedToWishlist,
          ),
          const SizedBox(width: 6),
          const ModifiedVerticalDivider(
            lineWidth: 1,
            lineHeight: 20,
            lineColor: Colors.black,
          ),
          const SizedBox(width: 8),
          TapArea(
            onTap: () => onShareProduct(selectedProductEntry.shareCode),
            child: ModifiedSvgPicture.asset(
              Constant.vectorShare,
              color: Theme.of(context).colorScheme.primary,
              height: 26
            )
          )
        ]
      ) : Container()
    );
  }
}