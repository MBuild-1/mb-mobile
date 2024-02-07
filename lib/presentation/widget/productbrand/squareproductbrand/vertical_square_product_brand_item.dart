import 'package:flutter/material.dart';

import '../../../../domain/entity/product/productbrand/product_brand.dart';
import 'square_product_brand_item.dart';

class VerticalSquareProductBrandItem extends SquareProductBrandItem {
  @override
  double? get itemWidth => 180.0;

  const VerticalSquareProductBrandItem({
    Key? key,
    required ProductBrand productBrand
  }) : super(key: key, productBrand: productBrand);
}