import '../../../../domain/entity/product/productentry/product_entry.dart';
import '../../../../presentation/widget/product/product_item.dart';
import '../list_item_controller_state.dart';

class ProductEntryContainerListItemControllerState extends ListItemControllerState {
  List<ProductEntry> productEntryList;
  ListItemControllerState Function() productEntryHeaderListItemControllerState;
  OnAddWishlistWithProductAppearanceData? onAddWishlist;
  OnRemoveWishlistWithProductAppearanceData? onRemoveWishlist;
  OnAddCartWithProductAppearanceData? onAddCart;
  OnRemoveCartWithProductAppearanceData? onRemoveCart;

  ProductEntryContainerListItemControllerState({
    required this.productEntryList,
    required this.productEntryHeaderListItemControllerState,
    this.onAddWishlist,
    this.onRemoveWishlist,
    this.onAddCart,
    this.onRemoveCart
  });
}