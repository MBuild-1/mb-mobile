import '../../../../domain/entity/product/product_appearance_data.dart';
import '../list_item_controller_state.dart';

abstract class ProductListItemControllerState extends ListItemControllerState {
  ProductAppearanceData productAppearanceData;

  ProductListItemControllerState({
    required this.productAppearanceData
  });
}