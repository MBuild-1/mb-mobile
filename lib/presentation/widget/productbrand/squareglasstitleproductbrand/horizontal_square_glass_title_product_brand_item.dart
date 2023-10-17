import 'square_glass_title_product_brand_item.dart';

class HorizontalSquareGlassTitleProductBrandItem extends SquareGlassTitleProductBrandItem {
  @override
  double? get itemWidth => 150;

  @override
  double? get itemHeight => 240;

  const HorizontalSquareGlassTitleProductBrandItem({
    super.key,
    required super.productBrand
  });
}