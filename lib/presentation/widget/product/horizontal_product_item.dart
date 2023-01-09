import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../domain/entity/product.dart';
import 'product_item.dart';

class HorizontalProductItem extends ProductItem {
  @override
  double? get itemWidth => 150.0;

  const HorizontalProductItem({
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