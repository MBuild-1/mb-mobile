import '../../../domain/dummy/productdummy/product_dummy.dart';
import '../../../domain/dummy/productdummy/product_entry_dummy.dart';
import '../product_shimmer_carousel_list_item_generator.dart';
import '../shimmer_carousel_list_item_generator.dart';
import '../type/product_shimmer_carousel_list_item_generator_type.dart';
import 'shimmer_carousel_list_item_generator_factory.dart';

class ProductShimmerCarouselListItemGeneratorFactory extends ShimmerCarouselListItemGeneratorFactory<ProductShimmerCarouselListItemGeneratorType> {
  final ProductDummy productDummy;
  final ProductEntryDummy productEntryDummy;

  ProductShimmerCarouselListItemGeneratorFactory({
    required this.productDummy,
    required this.productEntryDummy
  });

  @override
  ShimmerCarouselListItemGenerator<ProductShimmerCarouselListItemGeneratorType> getShimmerCarouselListItemGeneratorType() {
    return ProductShimmerCarouselListItemGenerator(
      productDummy: productDummy,
      productEntryDummy: productEntryDummy
    );
  }
}