import '../../presentation/widget/product/product_item.dart';
import 'parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';

class WishlistParameterizedEntityAndListItemControllerStateMediatorParameter extends ParameterizedEntityAndListItemControllerStateMediatorParameter {
  OnAddWishlistWithProductId? onAddWishlist;
  OnRemoveWishlistWithProductId? onRemoveWishlist;

  WishlistParameterizedEntityAndListItemControllerStateMediatorParameter({
    required this.onAddWishlist,
    required this.onRemoveWishlist
  });
}