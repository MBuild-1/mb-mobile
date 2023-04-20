import '../../domain/entity/product/product_appearance_data.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/newslistitemcontrollerstate/horizontal_news_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/circleproductbrandlistitemcontrollerstate/horizontal_circle_product_brand_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/horizontal_product_brand_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/horizontal_product_bundle_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/circleproductcategorylistitemcontrollerstate/horizontal_circle_product_category_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/horizontal_product_category_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/horizontal_product_list_item_controller_state.dart';
import '../parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'parameterized_entity_and_list_item_controller_state_mediator.dart';

class HorizontalParameterizedEntityAndListItemControllerStateMediator extends ParameterizedEntityAndListItemControllerStateMediator {
  @override
  ListItemControllerState mapWithParameter(entity, {parameter}) {
    if (entity is DeliveryReview) {
      return HorizontalDeliveryReviewListItemControllerState(deliveryReview: entity);
    } else if (entity is News) {
      return HorizontalNewsListItemControllerState(news: entity);
    } else if (entity is ProductAppearanceData) {
      if (parameter is WishlistParameterizedEntityAndListItemControllerStateMediatorParameter) {
        return HorizontalProductListItemControllerState(
          productAppearanceData: entity,
          onAddWishlist: parameter.onAddWishlist,
          onRemoveWishlist: parameter.onRemoveWishlist
        );
      } else {
        return NoContentListItemControllerState();
      }
    } else if (entity is ProductCategory) {
      return HorizontalCircleProductCategoryListItemControllerState(productCategory: entity);
    } else if (entity is ProductBrand) {
      return HorizontalCircleProductBrandListItemControllerState(productBrand: entity);
    } else if (entity is ProductBundle) {
      if (parameter is WishlistParameterizedEntityAndListItemControllerStateMediatorParameter) {
        return HorizontalProductBundleListItemControllerState(
          productBundle: entity,
          onAddWishlist: parameter.onAddWishlist,
          onRemoveWishlist: parameter.onRemoveWishlist
        );
      } else {
        return NoContentListItemControllerState();
      }
    } else {
      return NoContentListItemControllerState();
    }
  }
}