import '../../domain/entity/product.dart';
import '../../presentation/widget/carousel_list_item.dart';
import 'shimmer_carousel_list_item_generator.dart';
import 'type/shimmer_carousel_list_item_generator_type.dart';
import 'type/product_shimmer_carousel_list_item_generator_type.dart';

class DefaultShimmerCarouselListItemGenerator<T, G extends ShimmerCarouselListItemGeneratorType> extends ShimmerCarouselListItemGenerator<T, G> {
  final G _shimmerCarouselListItemGeneratorType;

  @override
  G get shimmerCarouselListItemGeneratorType => _shimmerCarouselListItemGeneratorType;

  DefaultShimmerCarouselListItemGenerator({
    required G shimmerCarouselListItemGeneratorType
  }) : _shimmerCarouselListItemGeneratorType = shimmerCarouselListItemGeneratorType;

  @override
  T onGenerateListItemValue() {
    if (_shimmerCarouselListItemGeneratorType is ProductShimmerCarouselListItemGeneratorType) {
      return Product(
        id: -1,
        name: "",
        defaultImageUrl: "",
        pricePerGram: 0,
        productPlu: "",
        productCode: "",
        unit: "",
        price: 0,
        sku: "",
        productSellingPrice: 0,
        productDiscountPrice: 0,
      ) as T;
    } else if (_shimmerCarouselListItemGeneratorType is DefaultShimmerCarouselListItemGenerator) {
      return ShimmerCarouselItemValue() as T;
    } else {
      throw Exception("No item desired in generating shimmer carousel list item.");
    }
  }
}