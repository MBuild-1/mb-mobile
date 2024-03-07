import '../../../domain/entity/product/productbundle/product_bundle.dart';
import '../../../presentation/widget/productbundle/product_bundle_item.dart';
import 'list_item_controller_state.dart';

class ProductBundleHighlightMultipleListItemControllerState extends ListItemControllerState {
  List<ProductBundle> productBundleList;
  OnAddWishlistWithProductBundle? onAddWishlist;
  OnRemoveWishlistWithProductBundle? onRemoveWishlist;
  OnAddWishlistWithProductBundle? onAddCart;
  OnRemoveWishlistWithProductBundle? onRemoveCart;

  ProductBundleHighlightMultipleListItemControllerState({
    required this.productBundleList,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart
  });
}