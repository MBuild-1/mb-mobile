import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/number_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/cart/cart.dart';
import '../../../domain/entity/cart/support_cart.dart';
import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../domain/entity/product/productentry/product_entry.dart';
import '../../../domain/entity/product/productvariant/product_variant.dart';
import '../../../misc/constant.dart';
import '../../../misc/product_helper.dart';
import '../check_list_item.dart';
import '../modified_svg_picture.dart';
import '../modifiedcachednetworkimage/product_modified_cached_network_image.dart';
import '../tap_area.dart';

abstract class CartItem extends StatelessWidget {
  final Cart cart;
  final bool isSelected;
  final bool showDefaultCart;
  final bool showCheck;
  final bool showBottom;
  final bool canBeSelected;
  final void Function()? onChangeSelected;
  final void Function()? onAddToNotes;
  final void Function()? onChangeNotes;
  final void Function()? onRemoveFromNotes;
  final void Function()? onAddToWishlist;
  final void Function()? onRemoveCart;
  final void Function(int, int)? onChangeQuantity;

  @protected
  double? get itemWidth;

  @protected
  double? get itemHeight;

  const CartItem({
    super.key,
    required this.cart,
    required this.isSelected,
    required this.showDefaultCart,
    required this.onChangeSelected,
    this.showCheck = true,
    this.showBottom = true,
    required this.canBeSelected,
    this.onAddToNotes,
    this.onChangeNotes,
    this.onRemoveFromNotes,
    this.onAddToWishlist,
    this.onRemoveCart,
    this.onChangeQuantity
  });

  @override
  Widget build(BuildContext context) {
    return CheckListItem(
      value: isSelected,
      showCheck: showCheck,
      title: Row(
        children: [
          SizedBox(
            width: 70,
            child: AspectRatio(
              aspectRatio: 1.0,
              child: ClipRRect(
                child: ProductModifiedCachedNetworkImage(
                  imageUrl: cart.supportCart.cartImageUrl,
                )
              )
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Builder(
              builder: (context) {
                List<Widget> columnWidget = [];
                SupportCart supportCart = cart.supportCart;
                if (supportCart is ProductEntry) {
                  ProductEntry productEntry = supportCart;
                  String productVariantDescription = ProductHelper.getProductVariantDescription(productEntry);
                  columnWidget.addAll(<Widget>[
                    Text(productEntry.name),
                    if (productEntry.product.productCategory.name.isNotEmptyString)
                      ...[
                        const SizedBox(height: 5),
                        Text(productEntry.product.productCategory.name.toEmptyStringNonNull, style: const TextStyle(color: Colors.grey)),
                      ],
                    if (productVariantDescription.isNotEmptyString)
                      ...[
                        const SizedBox(height: 10),
                        Text(productVariantDescription, style: const TextStyle(color: Colors.grey)),
                      ],
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            productEntry.sellingPrice.toRupiah(),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        ),
                        Flexible(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "${productEntry.weight.toWeightStringDecimalPlaced()} Kg",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                if (!showDefaultCart) ...[
                                  TextSpan(
                                    text: " | ${"Quantity".tr} ${cart.quantity}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                ]
                              ]
                            ),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ]
                    )
                  ]);
                } else if (supportCart is ProductBundle) {
                  ProductBundle productBundle = supportCart;
                  columnWidget.addAll(<Widget>[
                    Text(productBundle.name),
                    const SizedBox(height: 10),
                    Text(
                      productBundle.price.toRupiah(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ]);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: columnWidget
                );
              }
            ),
          )
        ],
      ),
      content: !showBottom ? null : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onAddToNotes != null) ...[
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Wrap(
                    children: [
                      TapArea(
                        onTap: onAddToNotes,
                        child: Text(
                          cart.notes.isEmptyString ? "Add Notes".tr : cart.notes.toEmptyStringNonNull,
                          style: TextStyle(
                            color: cart.notes.isEmptyString ? Theme.of(context).colorScheme.primary : Colors.black
                          )
                        )
                      ),
                    ]
                  )
                ),
              ]
            ),
            if (cart.notes.isNotEmptyString) ...[
              const SizedBox(height: 10.0),
              Row(
                children: [
                  TapArea(
                    onTap: onChangeNotes != null ? () => onChangeNotes!() : null,
                    child: Text(
                      "Change Notes".tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary
                      )
                    )
                  ),
                  const SizedBox(width: 10),
                  TapArea(
                    onTap: onRemoveFromNotes != null ? () => onRemoveFromNotes!() : null,
                    child: Text(
                      "Remove Notes".tr,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary
                      )
                    )
                  ),
                ]
              )
            ]
          ],
          if (showDefaultCart) ...[
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                double size = 25;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TapArea(
                        onTap: onAddToWishlist,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
                          child: Text("Add To Wishlist".tr),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(width: 1.0)
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(width: 20),
                        TapArea(
                          onTap: onRemoveCart,
                          child: ModifiedSvgPicture.asset(
                            Constant.vectorTrash,
                            fit: BoxFit.fitHeight,
                            width: size,
                            height: size,
                          ),
                        ),
                        const SizedBox(width: 20),
                        TapArea(
                          onTap: onChangeQuantity != null ? () => onChangeQuantity!(cart.quantity, cart.quantity - 1) : null,
                          child: ModifiedSvgPicture.asset(
                            Constant.vectorMinusCircle,
                            width: size,
                            height: size,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          cart.quantity.toString(),
                          style: const TextStyle(
                            fontSize: 17.0
                          ),
                        ),
                        const SizedBox(width: 20),
                        TapArea(
                          onTap: onChangeQuantity != null ? () => onChangeQuantity!(cart.quantity, cart.quantity + 1) : null,
                          child: ModifiedSvgPicture.asset(
                            Constant.vectorPlusCircle,
                            fit: BoxFit.fitHeight,
                            width: size,
                            height: size,
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }
            )
          ]
        ],
      ),
      onChanged: onChangeSelected != null ? (canBeSelected ? (bool? value) => onChangeSelected!() : null) : null,
      reverse: true,
      spaceBetweenCheckListAndTitle: 4.w,
      spaceBetweenTitleAndContent: showDefaultCart ? 4.w : 0.0,
    );
  }
}