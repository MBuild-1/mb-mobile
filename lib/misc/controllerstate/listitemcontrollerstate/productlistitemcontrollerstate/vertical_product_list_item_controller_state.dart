import '../../../../domain/entity/product/product_appearance_data.dart';
import '../../../../presentation/widget/product/product_item.dart';
import 'product_list_item_controller_state.dart';

class VerticalProductListItemControllerState extends ProductListItemControllerState {
  VerticalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData,
    OnAddWishlistWithProductId? onAddWishlist,
    OnRemoveWishlistWithProductId? onRemoveWishlist
  }) : super(
    productAppearanceData: productAppearanceData,
    onAddWishlist: onAddWishlist,
    onRemoveWishlist: onRemoveWishlist
  );
}

class ShimmerVerticalProductListItemControllerState extends VerticalProductListItemControllerState {
  ShimmerVerticalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData
  }) : super(productAppearanceData: productAppearanceData);
}