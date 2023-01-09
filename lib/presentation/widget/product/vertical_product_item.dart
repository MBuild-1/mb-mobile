import 'package:flutter/material.dart';

import '../../../domain/entity/product.dart';
import '../modified_shimmer.dart';
import 'product_item.dart';

class VerticalProductItem extends ProductItem {
  @override
  double? get itemWidth => null;

  const VerticalProductItem({
    Key? key,
    required Product product
  }) : super(key: key, product: product);

  @override
  Widget priceWidget(BuildContext context, Widget nonDiscountPriceWidget, Widget discountPriceWidget) {
    List<Widget> priceRowWidgetList = <Widget>[
      nonDiscountPriceWidget,
      Visibility(
        visible: discountPriceString != null,
        maintainSize: true,
        maintainAnimation: true,
        maintainState: true,
        child: discountPriceWidget,
      )
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: priceRowWidgetList
    );
  }
}

class ShimmerVerticalProductItem extends VerticalProductItem {
  const ShimmerVerticalProductItem({
    Key? key,
    required Product product
  }) : super(key: key, product: product);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ModifiedShimmer.fromColors(
        child: super.build(context)
      ),
    );
  }
}