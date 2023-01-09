import '../../../../domain/entity/product.dart';
import 'product_list_item_controller_state.dart';

class VerticalProductListItemControllerState extends ProductListItemControllerState {
  VerticalProductListItemControllerState({
    required Product product
  }) : super(product: product);
}

class ShimmerVerticalProductListItemControllerState extends VerticalProductListItemControllerState {
  ShimmerVerticalProductListItemControllerState({
    required Product product
  }) : super(product: product);
}