import '../../../../../domain/entity/product/productbrand/product_brand.dart';
import '../../list_item_controller_state.dart';

abstract class SquareGlassTitleProductBrandListItemControllerState extends ListItemControllerState {
  ProductBrand productBrand;

  SquareGlassTitleProductBrandListItemControllerState({
    required this.productBrand
  });
}