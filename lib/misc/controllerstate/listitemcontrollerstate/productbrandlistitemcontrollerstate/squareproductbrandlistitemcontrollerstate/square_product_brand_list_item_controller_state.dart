import '../../../../../domain/entity/product/productbrand/product_brand.dart';
import '../../list_item_controller_state.dart';

abstract class SquareProductBrandListItemControllerState extends ListItemControllerState {
  ProductBrand productBrand;

  SquareProductBrandListItemControllerState({
    required this.productBrand
  });
}