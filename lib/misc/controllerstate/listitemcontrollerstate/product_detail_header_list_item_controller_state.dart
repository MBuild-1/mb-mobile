import '../../../domain/entity/product.dart';
import 'list_item_controller_state.dart';

abstract class BaseProductDetailHeaderListItemControllerState extends ListItemControllerState {}

class ProductDetailHeaderListItemControllerState extends BaseProductDetailHeaderListItemControllerState {
  Product product;

  ProductDetailHeaderListItemControllerState({
    required this.product,
  });
}

class ShimmerProductDetailHeaderListItemControllerState extends BaseProductDetailHeaderListItemControllerState {}