import '../../../../domain/entity/product/product_appearance_data.dart';
import 'product_list_item_controller_state.dart';

class VerticalProductListItemControllerState extends ProductListItemControllerState {
  VerticalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData
  }) : super(productAppearanceData: productAppearanceData);
}

class ShimmerVerticalProductListItemControllerState extends VerticalProductListItemControllerState {
  ShimmerVerticalProductListItemControllerState({
    required ProductAppearanceData productAppearanceData
  }) : super(productAppearanceData: productAppearanceData);
}