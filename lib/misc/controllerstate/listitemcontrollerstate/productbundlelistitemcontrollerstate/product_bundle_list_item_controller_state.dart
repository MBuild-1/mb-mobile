import '../../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../../presentation/widget/productbundle/product_bundle_item.dart';
import '../list_item_controller_state.dart';

abstract class ProductBundleListItemControllerState extends ListItemControllerState {
  ProductBundle productBundle;
  OnAddWishlistWithProductBundleId? onAddWishlist;
  OnRemoveWishlistWithProductBundleId? onRemoveWishlist;

  ProductBundleListItemControllerState({
    required this.productBundle,
    required this.onAddWishlist,
    required this.onRemoveWishlist
  });
}