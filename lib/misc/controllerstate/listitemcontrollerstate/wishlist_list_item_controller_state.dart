import '../../../domain/entity/wishlist/wishlist.dart';
import 'list_item_controller_state.dart';

class WishlistListItemControllerState extends ListItemControllerState {
  Wishlist wishlist;
  ListItemControllerState childListItemControllerState;

  WishlistListItemControllerState({
    required this.wishlist,
    required this.childListItemControllerState
  });
}