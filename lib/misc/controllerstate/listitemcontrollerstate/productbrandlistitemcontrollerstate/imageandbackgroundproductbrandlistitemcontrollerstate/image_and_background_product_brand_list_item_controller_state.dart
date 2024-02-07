import '../../../../../domain/entity/product/productbrand/product_brand.dart';
import '../../list_item_controller_state.dart';

abstract class ImageAndBackgroundProductBrandListItemControllerState extends ListItemControllerState {
  ProductBrand productBrand;

  ImageAndBackgroundProductBrandListItemControllerState({
    required this.productBrand
  });
}