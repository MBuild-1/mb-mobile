import '../../../domain/entity/product.dart';
import '../default_shimmer_carousel_list_item_generator.dart';
import '../shimmer_carousel_list_item_generator.dart';
import '../type/product_shimmer_carousel_list_item_generator_type.dart';
import 'shimmer_carousel_list_item_generator_factory.dart';

class ProductShimmerCarouselListItemGeneratorFactory extends ShimmerCarouselListItemGeneratorFactory<Product, ProductShimmerCarouselListItemGeneratorType> {
  @override
  ShimmerCarouselListItemGenerator<Product, ProductShimmerCarouselListItemGeneratorType> getShimmerCarouselListItemGeneratorType() {
    return DefaultShimmerCarouselListItemGenerator<Product, ProductShimmerCarouselListItemGeneratorType>(
      shimmerCarouselListItemGeneratorType: ProductShimmerCarouselListItemGeneratorType()
    );
  }
}