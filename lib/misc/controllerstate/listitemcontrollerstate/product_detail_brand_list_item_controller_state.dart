import '../../../domain/entity/product/productbrand/product_brand.dart';
import 'list_item_controller_state.dart';

class ProductDetailBrandListItemControllerState extends ListItemControllerState {
  ProductBrand productBrand;
  void Function(ProductBrand)? onTapProductBrand;

  ProductDetailBrandListItemControllerState({
    required this.productBrand,
    this.onTapProductBrand
  });
}