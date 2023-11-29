import '../../../domain/entity/product/product_detail.dart';
import '../../../presentation/widget/product/product_item.dart';
import 'list_item_controller_state.dart';

class ProductDetailShortHeaderListItemControllerState extends ListItemControllerState {
  ProductDetail productDetail;
  int Function() onGetProductEntryIndex;
  void Function(String?) onShareProduct;
  OnAddWishlistWithProductAppearanceData? onAddWishlist;
  OnRemoveWishlistWithProductAppearanceData? onRemoveWishlist;

  ProductDetailShortHeaderListItemControllerState({
    required this.productDetail,
    required this.onGetProductEntryIndex,
    required this.onShareProduct,
    this.onAddWishlist,
    this.onRemoveWishlist
  });
}