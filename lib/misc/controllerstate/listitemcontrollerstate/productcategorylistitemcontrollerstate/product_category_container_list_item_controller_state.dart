import '../../../../domain/entity/product/productcategory/product_category.dart';
import '../list_item_controller_state.dart';

class ProductCategoryContainerListItemControllerState extends ListItemControllerState {
  List<ProductCategory> productCategoryList;

  ProductCategoryContainerListItemControllerState({
    required this.productCategoryList
  });
}