import '../../../../domain/entity/product/product.dart';
import '../../../../domain/entity/product/product_appearance_data.dart';
import '../../../../presentation/widget/product/product_item.dart';
import 'product_list_item_controller_state.dart';

class HorizontalProductListItemControllerState extends ProductListItemControllerState {
  HorizontalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData,
    OnAddWishlistWithProductId? onAddWishlist,
    OnRemoveWishlistWithProductId? onRemoveWishlist
  }) : super(
    productAppearanceData: productAppearanceData,
    onAddWishlist: onAddWishlist,
    onRemoveWishlist: onRemoveWishlist
  );
}