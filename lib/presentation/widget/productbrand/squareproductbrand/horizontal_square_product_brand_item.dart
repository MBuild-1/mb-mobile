import 'package:flutter/material.dart';

import '../../../../domain/entity/product/productbrand/product_brand.dart';
import '../../horizontal_scalable.dart';
import 'square_product_brand_item.dart';

class HorizontalSquareProductBrandItem extends SquareProductBrandItem implements HorizontalScalable {
  final HorizontalScalableValue _horizontalScalableValue = HorizontalScalableValue(
    scalableItemWidth: 180.0
  );

  @override
  HorizontalScalableValue get horizontalScalableValue => _horizontalScalableValue;

  @override
  double? get itemWidth => _horizontalScalableValue.scalableItemWidth;

  HorizontalSquareProductBrandItem({
    Key? key,
    required ProductBrand productBrand
  }) : super(key: key, productBrand: productBrand);
}