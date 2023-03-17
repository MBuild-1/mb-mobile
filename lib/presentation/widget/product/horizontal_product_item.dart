import 'package:flutter/material.dart';

import '../../../domain/entity/product/product_appearance_data.dart';
import 'product_item.dart';

class HorizontalProductItem extends ProductItem {
  @override
  double? get itemWidth => 180.0;

  const HorizontalProductItem({
    Key? key,
    required ProductAppearanceData productAppearanceData
  }) : super(key: key, productAppearanceData: productAppearanceData);

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