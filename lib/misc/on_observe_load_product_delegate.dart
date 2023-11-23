import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/address/address.dart';
import '../domain/entity/cart/cart.dart';
import '../domain/entity/coupon/coupon.dart';
import '../domain/entity/delivery/delivery_review.dart';
import '../domain/entity/news/news.dart';
import '../domain/entity/product/productbrand/product_brand.dart';
import '../domain/entity/product/productbundle/product_bundle.dart';
import '../domain/entity/product/productcategory/product_category.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import '../domain/entity/wishlist/add_wishlist_response.dart';
import '../presentation/widget/titleanddescriptionitem/title_and_description_item.dart';
import 'carouselbackground/carousel_background.dart';
import 'carousellistitemtype/carousel_list_item_type.dart';
import 'constant.dart';
import 'controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import 'controllerstate/listitemcontrollerstate/failed_prompt_indicator_list_item_controller_state.dart';
import 'controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import 'controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_component_entity_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import 'errorprovider/error_provider.dart';
import 'injector.dart';
import 'load_data_result.dart';
import 'multi_language_string.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/carousel_background_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/cart_delegate_parameterized_entity_and_list_item_controllere_state_mediator_parameter.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/cart_refresh_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/compound_parameterized_entity_and_list_item_controller_state_mediator.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/wishlist_delegate_parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'shimmercarousellistitemgenerator/factory/cart_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/coupon_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/delivery_review_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/news_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_brand_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_category_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/shimmer_carousel_list_item_generator.dart';
import 'shimmercarousellistitemgenerator/type/cart_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/coupon_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/delivery_review_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/news_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_brand_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_category_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_shimmer_carousel_list_item_generator_type.dart';
import 'typedef.dart';

class _GetCarouselListItemControllerStateParameter<T> {
  dynamic data;
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<T> itemList;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectParameterEntityAndListItem;
  void Function()? onAfterProcess;

  _GetCarouselListItemControllerStateParameter({
    required this.data,
    required this.title,
    required this.description,
    required this.itemList,
    required this.onInjectParameterEntityAndListItem,
    this.onAfterProcess
  });
}

class OnObserveLoadProductDelegateFactory {
  CarouselParameterizedEntityAndListItemControllerStateMediatorParameter Function(dynamic data)? onInjectCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductBrandCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductCategoryCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductEntryCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductBundleCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadDeliveryReviewCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadNewsCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadCouponCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadCartCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadAddressCarouselParameterizedEntity;

  CarouselListItemControllerState _getCarouselListItemControllerState({
    required _GetCarouselListItemControllerStateParameter getCarouselListItemControllerStateParameter
  }) {
    TitleInterceptor? titleInterceptor;
    CarouselBackground? carouselBackground;
    CarouselListItemType? carouselListItemType;
    ParameterizedEntityAndListItemControllerStateMediatorParameter? additionalParameter;
    if (onInjectCarouselParameterizedEntity != null) {
      titleInterceptor = onInjectCarouselParameterizedEntity!(getCarouselListItemControllerStateParameter.data).titleInterceptor;
      carouselBackground = onInjectCarouselParameterizedEntity!(getCarouselListItemControllerStateParameter.data).carouselBackground;
      carouselListItemType = onInjectCarouselParameterizedEntity!(getCarouselListItemControllerStateParameter.data).carouselListItemType;
      additionalParameter = onInjectCarouselParameterizedEntity!(getCarouselListItemControllerStateParameter.data).additionalParameter;
    }
    if (getCarouselListItemControllerStateParameter.onAfterProcess != null) {
      getCarouselListItemControllerStateParameter.onAfterProcess!();
    }
    dynamic injectedParameter = getCarouselListItemControllerStateParameter.onInjectParameterEntityAndListItem != null ? getCarouselListItemControllerStateParameter.onInjectParameterEntityAndListItem!() : null;
    if (additionalParameter != null) {
      if (injectedParameter == null) {
        injectedParameter = additionalParameter;
      } else {
        if (injectedParameter is CompoundParameterizedEntityAndListItemControllerStateMediatorParameter) {
          if (additionalParameter is CompoundParameterizedEntityAndListItemControllerStateMediatorParameter) {
            injectedParameter.parameterizedEntityAndListItemControllerStateMediatorParameterList.addAll(
              additionalParameter.parameterizedEntityAndListItemControllerStateMediatorParameterList
            );
          } else {
            injectedParameter.parameterizedEntityAndListItemControllerStateMediatorParameterList.add(additionalParameter);
          }
        } else {
          injectedParameter = CompoundParameterizedEntityAndListItemControllerStateMediatorParameter(
            parameterizedEntityAndListItemControllerStateMediatorParameterList: [
              if (additionalParameter is CompoundParameterizedEntityAndListItemControllerStateMediatorParameter) ...[
                ...additionalParameter.parameterizedEntityAndListItemControllerStateMediatorParameterList
              ] else ...[
                additionalParameter
              ]
            ]
          );
        }
      }
    }
    return CarouselListItemControllerState(
      title: getCarouselListItemControllerStateParameter.title.toEmptyStringNonNull,
      titleInterceptor: titleInterceptor,
      description: getCarouselListItemControllerStateParameter.description.toEmptyStringNonNull,
      padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
      itemListItemControllerState: getCarouselListItemControllerStateParameter.itemList.map<ListItemControllerState>(
        (item) {
          return Injector.locator<HorizontalParameterizedEntityAndListItemControllerStateMediator>().mapWithParameter(
            item, parameter: injectedParameter
          );
        }
      ).toList(),
      carouselBackground: carouselBackground,
      carouselListItemType: carouselListItemType
    );
  }

  OnObserveLoadProductDelegate generateOnObserveLoadProductDelegate() {
    return OnObserveLoadProductDelegate(
      onObserveSuccessLoadProductBrandCarousel: (onObserveSuccessLoadProductBrandCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadProductBrandCarouselParameter.data,
            title: onObserveSuccessLoadProductBrandCarouselParameter.title,
            description: onObserveSuccessLoadProductBrandCarouselParameter.description,
            itemList: onObserveSuccessLoadProductBrandCarouselParameter.productBrandList,
            onInjectParameterEntityAndListItem: onInjectLoadProductBrandCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadProductBrandCarousel: (onObserveLoadingLoadProductBrandCarouselParameter) {
        return ShimmerCarouselListItemControllerState<ProductBrandShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<ProductBrandShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadProductCategoryCarousel: (onObserveSuccessLoadProductCategoryCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadProductCategoryCarouselParameter.data,
            title: onObserveSuccessLoadProductCategoryCarouselParameter.title,
            description: onObserveSuccessLoadProductCategoryCarouselParameter.description,
            itemList: onObserveSuccessLoadProductCategoryCarouselParameter.productCategoryList,
            onInjectParameterEntityAndListItem: onInjectLoadProductCategoryCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadProductCategoryCarousel: (onObserveLoadingLoadProductCategoryCarouselParameter) {
        return ShimmerCarouselListItemControllerState<ProductCategoryShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<ProductCategoryShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadProductEntryCarousel: (onObserveSuccessLoadProductEntryCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadProductEntryCarouselParameter.data,
            title: onObserveSuccessLoadProductEntryCarouselParameter.title,
            description: onObserveSuccessLoadProductEntryCarouselParameter.description,
            itemList: onObserveSuccessLoadProductEntryCarouselParameter.productEntryList,
            onInjectParameterEntityAndListItem: onInjectLoadProductEntryCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadProductEntryCarousel: (onObserveLoadingLoadProductEntryCarouselParameter) {
        return ShimmerCarouselListItemControllerState<ProductShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<ProductShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadProductBundleCarousel: (onObserveSuccessLoadProductBundleCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadProductBundleCarouselParameter.data,
            title: onObserveSuccessLoadProductBundleCarouselParameter.title,
            description: onObserveSuccessLoadProductBundleCarouselParameter.description,
            itemList: onObserveSuccessLoadProductBundleCarouselParameter.productBundleList,
            onInjectParameterEntityAndListItem: onInjectLoadProductBundleCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadProductBundleCarousel: (onObserveLoadingLoadProductBundleCarouselParameter) {
        return ShimmerCarouselListItemControllerState<ProductBundleShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<ProductBundleShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadDeliveryReviewCarousel: (onObserveSuccessLoadDeliveryReviewCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadDeliveryReviewCarouselParameter.data,
            title: onObserveSuccessLoadDeliveryReviewCarouselParameter.title,
            description: onObserveSuccessLoadDeliveryReviewCarouselParameter.description,
            itemList: onObserveSuccessLoadDeliveryReviewCarouselParameter.deliveryReviewList,
            onInjectParameterEntityAndListItem: onInjectLoadDeliveryReviewCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadDeliveryReviewCarousel: (onObserveLoadingLoadDeliveryReviewCarouselParameter) {
        return ShimmerCarouselListItemControllerState<DeliveryReviewShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<DeliveryReviewShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadNewsCarousel: (onObserveSuccessLoadNewsCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadNewsCarouselParameter.data,
            title: onObserveSuccessLoadNewsCarouselParameter.title,
            description: onObserveSuccessLoadNewsCarouselParameter.description,
            itemList: onObserveSuccessLoadNewsCarouselParameter.newsList,
            onInjectParameterEntityAndListItem: onInjectLoadNewsCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadNewsCarousel: (onObserveLoadingLoadNewsCarouselParameter) {
        return ShimmerCarouselListItemControllerState<NewsShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<NewsShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadCouponCarousel: (onObserveSuccessLoadCouponCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadCouponCarouselParameter.data,
            title: onObserveSuccessLoadCouponCarouselParameter.title,
            description: onObserveSuccessLoadCouponCarouselParameter.description,
            itemList: onObserveSuccessLoadCouponCarouselParameter.couponList,
            onInjectParameterEntityAndListItem: onInjectLoadCouponCarouselParameterizedEntity
          )
        );
      },
      onObserveLoadingLoadCouponCarousel: (onObserveLoadingLoadCouponCarouselParameter) {
        return ShimmerCarouselListItemControllerState<CouponShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<CouponShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadCartCarousel: (onObserveSuccessLoadCartCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadCartCarouselParameter.data,
            title: onObserveSuccessLoadCartCarouselParameter.title,
            description: onObserveSuccessLoadCartCarouselParameter.description,
            itemList: onObserveSuccessLoadCartCarouselParameter.cartList,
            onInjectParameterEntityAndListItem: onInjectLoadCartCarouselParameterizedEntity,
            onAfterProcess: () => _getCartRefreshDelegate(
              getRepeatableParameter: () => onObserveSuccessLoadCartCarouselParameter.repeatableDynamicItemCarouselAdditionalParameter
            )
          )
        );
      },
      onObserveFailedLoadCartCarousel: (onObserveFailedLoadCartCarouselParameter) {
        _getCartRefreshDelegate(
          getRepeatableParameter: () => onObserveFailedLoadCartCarouselParameter.repeatableDynamicItemCarouselAdditionalParameter
        );
        return FailedPromptIndicatorListItemControllerState(
          e: onObserveFailedLoadCartCarouselParameter.e,
          errorProvider: Injector.locator<ErrorProvider>()
        );
      },
      onObserveLoadingLoadCartCarousel: (onObserveLoadingLoadCartCarouselParameter) {
        _getCartRefreshDelegate(
          getRepeatableParameter: () => onObserveLoadingLoadCartCarouselParameter.repeatableDynamicItemCarouselAdditionalParameter
        );
        return ShimmerCarouselListItemControllerState<CartShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<CartShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
      onObserveSuccessLoadAddressCarousel: (onObserveSuccessLoadAddressCarouselParameter) {
        return _getCarouselListItemControllerState(
          getCarouselListItemControllerStateParameter: _GetCarouselListItemControllerStateParameter(
            data: onObserveSuccessLoadAddressCarouselParameter.data,
            title: onObserveSuccessLoadAddressCarouselParameter.title,
            description: onObserveSuccessLoadAddressCarouselParameter.description,
            itemList: onObserveSuccessLoadAddressCarouselParameter.addressList.map<AddressCarouselCompoundParameterized>(
              (address) => AddressCarouselCompoundParameterized(
                address: address,
                onObserveSuccessLoadAddressCarouselParameter: onObserveSuccessLoadAddressCarouselParameter
              )
            ).toList(),
            onInjectParameterEntityAndListItem: onInjectLoadAddressCarouselParameterizedEntity,
          )
        );
      },
      onObserveFailedLoadAddressCarousel: (onObserveFailedLoadAddressCarouselParameter) {
        return FailedPromptIndicatorListItemControllerState(
          e: onObserveFailedLoadAddressCarouselParameter.e,
          errorProvider: Injector.locator<ErrorProvider>(),
          buttonText: onObserveFailedLoadAddressCarouselParameter.buttonText,
          onPressed: onObserveFailedLoadAddressCarouselParameter.onPressed,
        );
      },
      onObserveLoadingLoadAddressCarousel: (onObserveLoadingLoadAddressCarouselParameter) {
        return ShimmerCarouselListItemControllerState<CartShimmerCarouselListItemGeneratorType>(
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          showTitleShimmer: true,
          showDescriptionShimmer: false,
          showItemShimmer: true,
          shimmerCarouselListItemGenerator: Injector.locator<CartShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
        );
      },
    );
  }

  CartRefreshDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? _getCartRefreshDelegate({required RepeatableDynamicItemCarouselAdditionalParameter? Function() getRepeatableParameter}) {
    var parameter = onInjectLoadCartCarouselParameterizedEntity != null ? onInjectLoadCartCarouselParameterizedEntity!() : null;
    List<ParameterizedEntityAndListItemControllerStateMediatorParameter> parameterList = [];
    if (parameter is CompoundParameterizedEntityAndListItemControllerStateMediatorParameter) {
      parameterList = parameter.parameterizedEntityAndListItemControllerStateMediatorParameterList;
    } else if (parameter != null) {
      parameterList.add(parameter);
    }
    CartRefreshDelegateParameterizedEntityAndListItemControllerStateMediatorParameter? cartRefreshDelegate;
    for (var iteratedParameter in parameterList) {
      if (iteratedParameter is CartRefreshDelegateParameterizedEntityAndListItemControllerStateMediatorParameter) {
        cartRefreshDelegate = iteratedParameter;
      }
    }
    if (cartRefreshDelegate != null) {
      RepeatableDynamicItemCarouselAdditionalParameter? repeatableDynamicItemCarouselAdditionalParameter = getRepeatableParameter();
      if (repeatableDynamicItemCarouselAdditionalParameter != null) {
        cartRefreshDelegate.onGetRepeatableDynamicItemCarouselAdditionalParameter(repeatableDynamicItemCarouselAdditionalParameter);
      }
    }
    return cartRefreshDelegate;
  }
}

class OnObserveLoadProductDelegate {
  ListItemControllerState Function(OnObserveSuccessLoadProductBrandCarouselParameter) onObserveSuccessLoadProductBrandCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductBrandCarouselParameter) onObserveLoadingLoadProductBrandCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadProductCategoryCarouselParameter) onObserveSuccessLoadProductCategoryCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductCategoryCarouselParameter) onObserveLoadingLoadProductCategoryCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadProductEntryCarouselParameter) onObserveSuccessLoadProductEntryCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductEntryCarouselParameter) onObserveLoadingLoadProductEntryCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadProductBundleCarouselParameter) onObserveSuccessLoadProductBundleCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductBundleCarouselParameter) onObserveLoadingLoadProductBundleCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadDeliveryReviewCarouselParameter) onObserveSuccessLoadDeliveryReviewCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadDeliveryReviewCarouselParameter) onObserveLoadingLoadDeliveryReviewCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadNewsCarouselParameter) onObserveSuccessLoadNewsCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadNewsCarouselParameter) onObserveLoadingLoadNewsCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadCouponCarouselParameter) onObserveSuccessLoadCouponCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadCouponCarouselParameter) onObserveLoadingLoadCouponCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadCartCarouselParameter) onObserveSuccessLoadCartCarousel;
  ListItemControllerState Function(OnObserveFailedLoadCartCarouselParameter) onObserveFailedLoadCartCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadCartCarouselParameter) onObserveLoadingLoadCartCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadAddressCarouselParameter) onObserveSuccessLoadAddressCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadAddressCarouselParameter) onObserveLoadingLoadAddressCarousel;
  ListItemControllerState Function(OnObserveFailedLoadAddressCarouselParameter) onObserveFailedLoadAddressCarousel;

  OnObserveLoadProductDelegate({
    required this.onObserveSuccessLoadProductBrandCarousel,
    required this.onObserveLoadingLoadProductBrandCarousel,
    required this.onObserveSuccessLoadProductCategoryCarousel,
    required this.onObserveLoadingLoadProductCategoryCarousel,
    required this.onObserveSuccessLoadProductEntryCarousel,
    required this.onObserveLoadingLoadProductEntryCarousel,
    required this.onObserveSuccessLoadProductBundleCarousel,
    required this.onObserveLoadingLoadProductBundleCarousel,
    required this.onObserveSuccessLoadDeliveryReviewCarousel,
    required this.onObserveLoadingLoadDeliveryReviewCarousel,
    required this.onObserveSuccessLoadNewsCarousel,
    required this.onObserveLoadingLoadNewsCarousel,
    required this.onObserveSuccessLoadCouponCarousel,
    required this.onObserveLoadingLoadCouponCarousel,
    required this.onObserveSuccessLoadCartCarousel,
    required this.onObserveFailedLoadCartCarousel,
    required this.onObserveLoadingLoadCartCarousel,
    required this.onObserveSuccessLoadAddressCarousel,
    required this.onObserveLoadingLoadAddressCarousel,
    required this.onObserveFailedLoadAddressCarousel
  });
}

class OnObserveSuccessLoadProductBundleCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBundle> productBundleList;
  dynamic data;

  OnObserveSuccessLoadProductBundleCarouselParameter({
    required this.title,
    required this.description,
    required this.productBundleList,
    this.data
  });
}

class OnObserveLoadingLoadProductBundleCarouselParameter {}

class OnObserveSuccessLoadProductBrandCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBrand> productBrandList;
  dynamic data;

  OnObserveSuccessLoadProductBrandCarouselParameter({
    required this.title,
    required this.description,
    required this.productBrandList,
    this.data
  });
}

class OnObserveLoadingLoadProductBrandCarouselParameter {}

class OnObserveSuccessLoadProductCategoryCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductCategory> productCategoryList;
  dynamic data;

  OnObserveSuccessLoadProductCategoryCarouselParameter({
    required this.title,
    required this.description,
    required this.productCategoryList,
    this.data
  });
}

class OnObserveLoadingLoadProductCategoryCarouselParameter {}

class OnObserveSuccessLoadProductEntryCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductEntry> productEntryList;
  dynamic data;

  OnObserveSuccessLoadProductEntryCarouselParameter({
    required this.title,
    required this.description,
    required this.productEntryList,
    this.data
  });
}

class OnObserveLoadingLoadProductEntryCarouselParameter {}

class OnObserveSuccessLoadDeliveryReviewCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<DeliveryReview> deliveryReviewList;
  dynamic data;

  OnObserveSuccessLoadDeliveryReviewCarouselParameter({
    required this.title,
    required this.description,
    required this.deliveryReviewList,
    this.data
  });
}

class OnObserveLoadingLoadDeliveryReviewCarouselParameter {}

class OnObserveSuccessLoadNewsCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<News> newsList;
  dynamic data;

  OnObserveSuccessLoadNewsCarouselParameter({
    required this.title,
    required this.description,
    required this.newsList,
    this.data
  });
}

class OnObserveLoadingLoadNewsCarouselParameter {}

class OnObserveSuccessLoadCouponCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<Coupon> couponList;
  dynamic data;

  OnObserveSuccessLoadCouponCarouselParameter({
    required this.title,
    required this.description,
    required this.couponList,
    this.data
  });
}

class OnObserveLoadingLoadCouponCarouselParameter {}

class OnObserveSuccessLoadCartCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<Cart> cartList;
  dynamic data;
  RepeatableDynamicItemCarouselAdditionalParameter? repeatableDynamicItemCarouselAdditionalParameter;

  OnObserveSuccessLoadCartCarouselParameter({
    required this.title,
    required this.description,
    required this.cartList,
    this.data,
    this.repeatableDynamicItemCarouselAdditionalParameter
  });
}

class OnObserveFailedLoadCartCarouselParameter {
  dynamic e;
  RepeatableDynamicItemCarouselAdditionalParameter? repeatableDynamicItemCarouselAdditionalParameter;

  OnObserveFailedLoadCartCarouselParameter({
    required this.e,
    this.repeatableDynamicItemCarouselAdditionalParameter
  });
}

class OnObserveLoadingLoadCartCarouselParameter {
  RepeatableDynamicItemCarouselAdditionalParameter? repeatableDynamicItemCarouselAdditionalParameter;

  OnObserveLoadingLoadCartCarouselParameter({
    this.repeatableDynamicItemCarouselAdditionalParameter
  });
}

class OnObserveSuccessLoadAddressCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<Address> addressList;
  dynamic data;

  OnObserveSuccessLoadAddressCarouselParameter({
    required this.title,
    required this.description,
    required this.addressList,
    this.data
  });
}

class OnObserveFailedLoadAddressCarouselParameter {
  dynamic e;
  String? buttonText;
  void Function()? onPressed;

  OnObserveFailedLoadAddressCarouselParameter({
    required this.e,
    this.buttonText,
    this.onPressed
  });
}

class OnObserveLoadingLoadAddressCarouselParameter {}

class AddressCarouselCompoundParameterized {
  OnObserveSuccessLoadAddressCarouselParameter onObserveSuccessLoadAddressCarouselParameter;
  Address address;

  AddressCarouselCompoundParameterized({
    required this.onObserveSuccessLoadAddressCarouselParameter,
    required this.address
  });
}