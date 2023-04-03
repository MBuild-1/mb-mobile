import '../../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../../presentation/widget/productbundle/product_bundle_item.dart';
import 'product_bundle_list_item_controller_state.dart';

class VerticalProductBundleListItemControllerState extends ProductBundleListItemControllerState {
  VerticalProductBundleListItemControllerState({
    required ProductBundle productBundle,
    OnAddWishlistWithProductBundleId? onAddWishlist,
    OnRemoveWishlistWithProductBundleId? onRemoveWishlist
  }) : super(
    productBundle: productBundle,
    onAddWishlist: onAddWishlist,
    onRemoveWishlist: onRemoveWishlist
  );
}

class ShimmerVerticalProductBundleListItemControllerState extends VerticalProductBundleListItemControllerState {
  ShimmerVerticalProductBundleListItemControllerState({
    required ProductBundle productBundle
  }) : super(productBundle: productBundle);
}