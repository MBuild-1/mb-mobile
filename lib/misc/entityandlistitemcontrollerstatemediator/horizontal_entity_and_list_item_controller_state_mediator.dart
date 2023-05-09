import 'package:masterbagasi/presentation/widget/product/product_item.dart';

import '../../domain/entity/cart/cart.dart';
import '../../domain/entity/delivery/delivery_review.dart';
import '../../domain/entity/news/news.dart';
import '../../domain/entity/product/product_appearance_data.dart';
import '../../domain/entity/product/productbrand/product_brand.dart';
import '../../domain/entity/product/productbundle/product_bundle.dart';
import '../../domain/entity/product/productcategory/product_category.dart';
import '../../presentation/widget/productbundle/product_bundle_item.dart';
import '../controllerstate/listitemcontrollerstate/cartlistitemcontrollerstate/shortcartlistitemcontrollerstate/horizontal_short_cart_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/deliveryreviewlistitemcontrollerstate/horizontal_delivery_review_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/newslistitemcontrollerstate/horizontal_news_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbrandlistitemcontrollerstate/circleproductbrandlistitemcontrollerstate/horizontal_circle_product_brand_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productbundlelistitemcontrollerstate/horizontal_product_bundle_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productcategorylistitemcontrollerstate/circleproductcategorylistitemcontrollerstate/horizontal_circle_product_category_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/horizontal_product_list_item_controller_state.dart';
import '../error/message_error.dart';
import '../parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/cart_delegate_parameterized_entity_and_list_item_controllere_state_mediator_parameter.dart';
import '../parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/compound_parameterized_entity_and_list_item_controller_state_mediator.dart';
import '../parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import '../parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'parameterized_entity_and_list_item_controller_state_mediator.dart';

class HorizontalParameterizedEntityAndListItemControllerStateMediator extends ParameterizedEntityAndListItemControllerStateMediator {
  @override
  ListItemControllerState mapWithParameter(entity, {parameter}) {
    if (entity is DeliveryReview) {
      return HorizontalDeliveryReviewListItemControllerState(deliveryReview: entity);
    } else if (entity is News) {
      return HorizontalNewsListItemControllerState(news: entity);
    } else if (entity is ProductAppearanceData) {
      return _checkingForProduct(entity, parameter: parameter);
    } else if (entity is ProductCategory) {
      return HorizontalCircleProductCategoryListItemControllerState(productCategory: entity);
    } else if (entity is ProductBrand) {
      return HorizontalCircleProductBrandListItemControllerState(productBrand: entity);
    } else if (entity is ProductBundle) {
      return _checkingForProductBundle(entity, parameter: parameter);
    } else if (entity is Cart) {
      return HorizontalShortCartListItemControllerState(cart: entity);
    } else {
      return NoContentListItemControllerState();
    }
  }

  void _separateWishlistAndCartDelegateParameter(
    void Function(
      WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? wishlistDelegateParameter,
      CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? cartDelegateParameter,
    ) afterSeparateParameter,
    {parameter}
  ) {
    List<ParameterizedEntityAndListItemControllerStateMediatorParameter> parameterList = [];
    if (parameter is CompoundParameterizedEntityAndListItemControllerStateMediatorParameter) {
      parameterList = parameter.parameterizedEntityAndListItemControllerStateMediatorParameterList;
    } else if (
      parameter is WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter
      || parameter is CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter
    ) {
      parameterList.add(parameter);
    }
    if (parameterList.isNotEmpty) {
      WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? wishlistDelegateParameter;
      CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? cartDelegateParameter;
      for (var iteratedParameter in parameterList) {
        if (iteratedParameter is WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter) {
          wishlistDelegateParameter = iteratedParameter;
        } else
        if (iteratedParameter is CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter) {
          cartDelegateParameter = iteratedParameter;
        }
      }
      afterSeparateParameter(
        wishlistDelegateParameter,
        cartDelegateParameter
      );
    } else {
      throw MessageError(title: "Wishlist and cart delegate is required.");
    }
  }

  ListItemControllerState _checkingForProduct(ProductAppearanceData productAppearanceData, {parameter}) {
    WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? wishlistDelegateParameter;
    CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? cartDelegateParameter;
    _separateWishlistAndCartDelegateParameter(
      (wishlistDelegateParameterOutput, cartDelegateParameterOutput) {
        wishlistDelegateParameter = wishlistDelegateParameterOutput;
        cartDelegateParameter = cartDelegateParameterOutput;
      },
      parameter: parameter
    );
    OnAddWishlistWithProductAppearanceData? onAddToWishlist;
    OnRemoveWishlistWithProductAppearanceData? onRemoveFromWishlist;
    OnAddCartWithProductAppearanceData? onAddCart;
    OnRemoveCartWithProductAppearanceData? onRemoveCart;
    if (wishlistDelegateParameter != null) {
      if (wishlistDelegateParameter!.onAddToWishlist != null) {
        onAddToWishlist = (productAppearanceData) => wishlistDelegateParameter!.onAddToWishlist!(productAppearanceData);
      }
      if (wishlistDelegateParameter!.onRemoveFromWishlist != null) {
        onRemoveFromWishlist = (productAppearanceData) => wishlistDelegateParameter!.onRemoveFromWishlist!(productAppearanceData);
      }
    }
    if (cartDelegateParameter != null) {
      if (cartDelegateParameter!.onAddCart != null) {
        onAddCart = (productAppearanceData) => cartDelegateParameter!.onAddCart!(productAppearanceData);
      }
      if (cartDelegateParameter!.onRemoveCart != null) {
        onRemoveCart = (productAppearanceData) => cartDelegateParameter!.onRemoveCart!(productAppearanceData);
      }
    }
    return HorizontalProductListItemControllerState(
      productAppearanceData: productAppearanceData,
      onAddWishlist: onAddToWishlist,
      onRemoveWishlist: onRemoveFromWishlist,
      onAddCart: onAddCart,
      onRemoveCart: onRemoveCart
    );
  }

  ListItemControllerState _checkingForProductBundle(ProductBundle productBundle, {parameter}) {
    WishlistDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? wishlistDelegateParameter;
    CartDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? cartDelegateParameter;
    _separateWishlistAndCartDelegateParameter(
      (wishlistDelegateParameterOutput, cartDelegateParameterOutput) {
        wishlistDelegateParameter = wishlistDelegateParameterOutput;
        cartDelegateParameter = cartDelegateParameterOutput;
      },
      parameter: parameter
    );
    OnAddWishlistWithProductBundle? onAddToWishlist;
    OnRemoveWishlistWithProductBundle? onRemoveFromWishlist;
    OnAddCartWithProductBundle? onAddCart;
    OnRemoveCartWithProductBundle? onRemoveCart;
    if (wishlistDelegateParameter != null) {
      if (wishlistDelegateParameter!.onAddToWishlist != null) {
        onAddToWishlist = (productBundle) => wishlistDelegateParameter!.onAddToWishlist!(productBundle);
      }
      if (wishlistDelegateParameter!.onRemoveFromWishlist != null) {
        onRemoveFromWishlist = (productBundle) => wishlistDelegateParameter!.onRemoveFromWishlist!(productBundle);
      }
    }
    if (cartDelegateParameter != null) {
      if (cartDelegateParameter!.onAddCart != null) {
        onAddCart = (productBundle) => cartDelegateParameter!.onAddCart!(productBundle);
      }
      if (cartDelegateParameter!.onRemoveCart != null) {
        onRemoveCart = (productBundle) => cartDelegateParameter!.onRemoveCart!(productBundle);
      }
    }
    return HorizontalProductBundleListItemControllerState(
      productBundle: productBundle,
      onAddWishlist: onAddToWishlist,
      onRemoveWishlist: onRemoveFromWishlist,
      onAddCart: onAddCart,
      onRemoveCart: onRemoveCart
    );
  }
}