import '../../../../domain/entity/product.dart';
import '../list_item_controller_state.dart';

abstract class ProductListItemControllerState extends ListItemControllerState {
  Product product;

  ProductListItemControllerState({
    required this.product
  });
}