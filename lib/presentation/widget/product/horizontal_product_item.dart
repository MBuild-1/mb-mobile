import 'package:flutter/material.dart';

import '../../../domain/entity/product/product_appearance_data.dart';
import '../../../misc/parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_product_appearance_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../horizontal_scalable.dart';
import 'product_item.dart';

class HorizontalProductItem extends ProductItem implements HorizontalScalable {
  final HorizontalScalableValue _horizontalScalableValue = HorizontalScalableValue(
    scalableItemWidth: 180.0,
  );

  @override
  HorizontalScalableValue get horizontalScalableValue => _horizontalScalableValue;

  @override
  double? get itemWidth => _horizontalScalableValue.scalableItemWidth;

  final HorizontalProductAppearance horizontalProductAppearance;

  @override
  bool get showContent => horizontalProductAppearance == HorizontalProductAppearance.full;

  HorizontalProductItem({
    Key? key,
    required ProductAppearanceData productAppearanceData,
    OnAddWishlistWithProductAppearanceData? onAddWishlist,
    OnRemoveWishlistWithProductAppearanceData? onRemoveWishlist,
    OnAddCartWithProductAppearanceData? onAddCart,
    OnRemoveCartWithProductAppearanceData? onRemoveCart,
    required this.horizontalProductAppearance
  }) : super(
    key: key,
    productAppearanceData: productAppearanceData,
    onAddWishlist: onAddWishlist,
    onRemoveWishlist: onRemoveWishlist,
    onAddCart: onAddCart,
    onRemoveCart: onRemoveCart
  ) {
    _horizontalScalableValue.scalableItemWidthGetterChecking = (value) {
      if (horizontalProductAppearance == HorizontalProductAppearance.onlyPicture) {
        return 130.0;
      }
      return value;
    };
  }

  @override
  Widget priceWidget(BuildContext context, Widget nonDiscountPriceWidget, Widget discountPriceWidget) {
    List<Widget> priceRowWidgetList = <Widget>[
      nonDiscountPriceWidget,
      // Visibility(
      //   visible: discountPriceString != null,
      //   maintainSize: true,
      //   maintainAnimation: true,
      //   maintainState: true,
      //   child: discountPriceWidget,
      // )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: priceRowWidgetList
    );
  }
}