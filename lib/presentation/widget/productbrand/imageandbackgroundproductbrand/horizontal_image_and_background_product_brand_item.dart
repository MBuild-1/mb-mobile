import 'image_and_background_product_brand_item.dart';

class HorizontalImageAndBackgroundProductBrandItem extends ImageAndBackgroundProductBrandItem {
  @override
  double? get itemWidth => 100.0;

  const HorizontalImageAndBackgroundProductBrandItem({
    super.key,
    required super.productBrand
  });
}