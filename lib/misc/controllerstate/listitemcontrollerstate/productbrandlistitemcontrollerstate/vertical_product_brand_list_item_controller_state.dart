import '../../../../domain/entity/product/productbrand/product_brand.dart';
import 'product_brand_list_item_controller_state.dart';

class VerticalProductBrandListItemControllerState extends ProductBrandListItemControllerState {
  VerticalProductBrandListItemControllerState({
    required ProductBrand productBrand
  }) : super(productBrand: productBrand);
}

class ShimmerVerticalProductBrandListItemControllerState extends VerticalProductBrandListItemControllerState {
  ShimmerVerticalProductBrandListItemControllerState({
    required ProductBrand productBrand
  }) : super(productBrand: productBrand);
}