import 'square_glass_title_product_brand_item.dart';

class VerticalSquareGlassTitleProductBrandItem extends SquareGlassTitleProductBrandItem {
  @override
  double? get itemWidth => 180;

  @override
  double? get itemHeight => null;

  const VerticalSquareGlassTitleProductBrandItem({
    super.key,
    required super.productBrand
  });
}