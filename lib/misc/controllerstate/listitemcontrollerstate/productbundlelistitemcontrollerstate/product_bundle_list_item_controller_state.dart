import '../../../../domain/entity/product/productbundle/product_bundle.dart';
import '../list_item_controller_state.dart';

abstract class ProductBundleListItemControllerState extends ListItemControllerState {
  ProductBundle productBundle;

  ProductBundleListItemControllerState({
    required this.productBundle
  });
}