import '../../../../domain/entity/product/productbundle/product_bundle.dart';
import 'product_bundle_list_item_controller_state.dart';

class VerticalProductBundleListItemControllerState extends ProductBundleListItemControllerState {
  VerticalProductBundleListItemControllerState({
    required ProductBundle productBundle
  }) : super(productBundle: productBundle);
}

class ShimmerVerticalProductBundleListItemControllerState extends VerticalProductBundleListItemControllerState {
  ShimmerVerticalProductBundleListItemControllerState({
    required ProductBundle productBundle
  }) : super(productBundle: productBundle);
}