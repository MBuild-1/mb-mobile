import '../../domain/entity/product/product_appearance_data.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/horizontal_product_brand_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/horizontal_product_bundle_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/horizontal_product_category_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/horizontal_product_list_item_controller_state.dart';
import 'entity_and_list_item_controller_state_mediator.dart';

class HorizontalEntityAndListItemControllerStateMediator extends EntityAndListItemControllerStateMediator {
  @override
  ListItemControllerState map(entity) {
    if (entity is ProductAppearanceData) {
      return HorizontalProductListItemControllerState(productAppearanceData: entity);
    } else if (entity is ProductCategory) {
      return HorizontalProductCategoryListItemControllerState(productCategory: entity);
    } else if (entity is ProductBrand) {
      return HorizontalProductBrandListItemControllerState(productBrand: entity);
    } else if (entity is ProductBundle) {
      return HorizontalProductBundleListItemControllerState(productBundle: entity);
    } else {
      return NoContentListItemControllerState();
    }
  }
}