import '../../../../domain/entity/product/productbrand/product_brand.dart';
import '../list_item_controller_state.dart';

class ProductBrandContainerListItemControllerState extends ListItemControllerState {
  String Function() title;
  List<ProductBrand> productBrandList;

  ProductBrandContainerListItemControllerState({
    required this.productBrandList,
    required this.title
  });
}