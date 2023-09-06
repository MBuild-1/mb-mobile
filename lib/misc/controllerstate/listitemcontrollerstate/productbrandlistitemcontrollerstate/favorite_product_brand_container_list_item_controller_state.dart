import '../../../../domain/entity/product/productbrand/favorite_product_brand.dart';
import '../../../../domain/entity/product/productbrand/product_brand.dart';
import '../list_item_controller_state.dart';

class FavoriteProductBrandContainerListItemControllerState extends ListItemControllerState {
  List<FavoriteProductBrand> favoriteProductBrandList;
  void Function(ProductBrand)? onTapFavoriteProductBrand;
  void Function(FavoriteProductBrand) onRemoveFromFavoriteProductBrand;
  void Function(List<FavoriteProductBrand>) onAfterRemoveFromFavoriteProductBrand;
  void Function() onUpdateState;
  FavoriteProductBrandContainerInterceptingActionListItemControllerState favoriteProductBrandContainerInterceptingActionListItemControllerState;

  FavoriteProductBrandContainerListItemControllerState({
    required this.favoriteProductBrandList,
    this.onTapFavoriteProductBrand,
    required this.onRemoveFromFavoriteProductBrand,
    required this.onAfterRemoveFromFavoriteProductBrand,
    required this.onUpdateState,
    required this.favoriteProductBrandContainerInterceptingActionListItemControllerState
  });
}

abstract class FavoriteProductBrandContainerInterceptingActionListItemControllerState extends ListItemControllerState {
  void Function(FavoriteProductBrand)? get onRemoveFavoriteProductBrand;
}