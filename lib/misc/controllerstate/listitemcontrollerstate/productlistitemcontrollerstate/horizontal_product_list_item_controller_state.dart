import '../../../../domain/entity/product/product.dart';
import '../../../../domain/entity/product/product_appearance_data.dart';
import '../../../../presentation/widget/product/product_item.dart';
import '../../../parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/horizontal_product_appearance_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'product_list_item_controller_state.dart';

class HorizontalProductListItemControllerState extends ProductListItemControllerState {
  HorizontalProductAppearance horizontalProductAppearance;

  HorizontalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData,
    OnAddWishlistWithProductAppearanceData? onAddWishlist,
    OnRemoveWishlistWithProductAppearanceData? onRemoveWishlist,
    OnAddCartWithProductAppearanceData? onAddCart,
    OnRemoveCartWithProductAppearanceData? onRemoveCart,
    this.horizontalProductAppearance = HorizontalProductAppearance.full
  }) : super(
    productAppearanceData: productAppearanceData,
    onAddWishlist: onAddWishlist,
    onRemoveWishlist: onRemoveWishlist,
    onAddCart: onAddCart,
    onRemoveCart: onRemoveCart
  );
}