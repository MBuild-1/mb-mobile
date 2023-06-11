import '../../../../domain/entity/product/productentry/product_entry.dart';
import '../../../../presentation/widget/product/product_item.dart';
import '../list_item_controller_state.dart';

class SearchContainerListItemControllerState extends ListItemControllerState {
  List<ProductEntry> productEntryList;
  void Function() onUpdateState;
  OnRemoveWishlistWithWishlist onRemoveWishlistWithWishlist;
  OnAddCartWithProductAppearanceData onAddProductCart;

  SearchContainerListItemControllerState({
    required this.productEntryList,
    required this.onUpdateState,
    required this.onRemoveWishlistWithWishlist,
    required this.onAddProductCart
  });
}