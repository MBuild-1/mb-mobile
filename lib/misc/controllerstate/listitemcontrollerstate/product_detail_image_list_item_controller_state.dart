import '../../../domain/entity/product/product_appearance_data.dart';
import 'list_item_controller_state.dart';

class ProductDetailImageListItemControllerState extends ListItemControllerState {
  ProductAppearanceData productAppearanceData;

  ProductDetailImageListItemControllerState({
    required this.productAppearanceData
  });
}