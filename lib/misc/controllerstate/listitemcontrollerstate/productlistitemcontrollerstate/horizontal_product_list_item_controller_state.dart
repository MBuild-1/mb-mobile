import '../../../../domain/entity/product/product.dart';
import '../../../../domain/entity/product/product_appearance_data.dart';
import 'product_list_item_controller_state.dart';

class HorizontalProductListItemControllerState extends ProductListItemControllerState {
  HorizontalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData
  }) : super(productAppearanceData: productAppearanceData);
}