import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../domain/entity/coupon/coupon.dart';
import '../domain/entity/product/productbrand/product_brand.dart';
import '../domain/entity/product/productbundle/product_bundle.dart';
import '../domain/entity/product/productcategory/product_category.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import 'constant.dart';
import 'controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import 'controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import 'entityandlistitemcontrollerstatemediator/horizontal_entity_and_list_item_controller_state_mediator.dart';
import 'injector.dart';
import 'multi_language_string.dart';
import 'parameterizedcomponententityandlistitemcontrollerstatemediatorparameter/parameterized_entity_and_list_item_controller_state_mediator_parameter.dart';
import 'shimmercarousellistitemgenerator/factory/coupon_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_brand_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_bundle_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_category_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import 'shimmercarousellistitemgenerator/type/coupon_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_brand_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_bundle_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_category_shimmer_carousel_list_item_generator_type.dart';
import 'shimmercarousellistitemgenerator/type/product_shimmer_carousel_list_item_generator_type.dart';

class OnObserveLoadProductDelegateFactory {
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductBrandCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductCategoryCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductEntryCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadProductBundleCarouselParameterizedEntity;
  ParameterizedEntityAndListItemControllerStateMediatorParameter Function()? onInjectLoadCouponCarouselParameterizedEntity;

  OnObserveLoadProductDelegate generateOnObserveLoadProductDelegate() {
    return OnObserveLoadProductDelegate(
      onObserveSuccessLoadProductBrandCarousel: (onObserveSuccessLoadProductBrandCarouselParameter) {
        return CarouselListItemControllerState(
          title: onObserveSuccessLoadProductBrandCarouselParameter.title.toEmptyStringNonNull,
          description: onObserveSuccessLoadProductBrandCarouselParameter.description.toEmptyStringNonNull,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          itemListItemControllerState: onObserveSuccessLoadProductBrandCarouselParameter.productBrandList.map<ListItemControllerState>(
            (productBrand) {
              return Injector.locator<HorizontalParameterizedEntityAndListItemControllerStateMediator>().mapWithParameter(
                productBrand, parameter: onInjectLoadProductBrandCarouselParameterizedEntity != null ? onInjectLoadProductBrandCarouselParameterizedEntity!() : null
              );
            }
          ).toList()
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
        return CarouselListItemControllerState(
          title: onObserveSuccessLoadProductCategoryCarouselParameter.title.toEmptyStringNonNull,
          description: onObserveSuccessLoadProductCategoryCarouselParameter.description.toEmptyStringNonNull,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          itemListItemControllerState: onObserveSuccessLoadProductCategoryCarouselParameter.productCategoryList.map<ListItemControllerState>(
            (productCategory) {
              return Injector.locator<HorizontalParameterizedEntityAndListItemControllerStateMediator>().mapWithParameter(
                productCategory, parameter: onInjectLoadProductCategoryCarouselParameterizedEntity != null ? onInjectLoadProductCategoryCarouselParameterizedEntity!() : null
              );
            }
          ).toList()
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
        return CarouselListItemControllerState(
          title: onObserveSuccessLoadProductEntryCarouselParameter.title.toEmptyStringNonNull,
          description: onObserveSuccessLoadProductEntryCarouselParameter.description.toEmptyStringNonNull,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          itemListItemControllerState: onObserveSuccessLoadProductEntryCarouselParameter.productEntryList.map<ListItemControllerState>(
            (productEntry) {
              return Injector.locator<HorizontalParameterizedEntityAndListItemControllerStateMediator>().mapWithParameter(
                productEntry, parameter: onInjectLoadProductEntryCarouselParameterizedEntity != null ? onInjectLoadProductEntryCarouselParameterizedEntity!() : null
              );
            }
          ).toList()
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
        return CarouselListItemControllerState(
          title: onObserveSuccessLoadProductBundleCarouselParameter.title.toEmptyStringNonNull,
          description: onObserveSuccessLoadProductBundleCarouselParameter.description.toEmptyStringNonNull,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          itemListItemControllerState: onObserveSuccessLoadProductBundleCarouselParameter.productBundleList.map<ListItemControllerState>(
            (productBundle) {
              return Injector.locator<HorizontalParameterizedEntityAndListItemControllerStateMediator>().mapWithParameter(
                productBundle, parameter: onInjectLoadProductBundleCarouselParameterizedEntity != null ? onInjectLoadProductBundleCarouselParameterizedEntity!() : null
              );
            }
          ).toList()
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
      onObserveSuccessLoadCouponCarousel: (onObserveSuccessLoadCouponCarouselParameter) {
        return CarouselListItemControllerState(
          title: onObserveSuccessLoadCouponCarouselParameter.title.toEmptyStringNonNull,
          description: onObserveSuccessLoadCouponCarouselParameter.description.toEmptyStringNonNull,
          padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem),
          itemListItemControllerState: onObserveSuccessLoadCouponCarouselParameter.couponList.map<ListItemControllerState>(
            (coupon) {
              return Injector.locator<HorizontalParameterizedEntityAndListItemControllerStateMediator>().mapWithParameter(
                coupon, parameter: onInjectLoadCouponCarouselParameterizedEntity != null ? onInjectLoadCouponCarouselParameterizedEntity!() : null
              );
            }
          ).toList()
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
    );
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
  ListItemControllerState Function(OnObserveSuccessLoadCouponCarouselParameter) onObserveSuccessLoadCouponCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadCouponCarouselParameter) onObserveLoadingLoadCouponCarousel;

  OnObserveLoadProductDelegate({
    required this.onObserveSuccessLoadProductBrandCarousel,
    required this.onObserveLoadingLoadProductBrandCarousel,
    required this.onObserveSuccessLoadProductCategoryCarousel,
    required this.onObserveLoadingLoadProductCategoryCarousel,
    required this.onObserveSuccessLoadProductEntryCarousel,
    required this.onObserveLoadingLoadProductEntryCarousel,
    required this.onObserveSuccessLoadProductBundleCarousel,
    required this.onObserveLoadingLoadProductBundleCarousel,
    required this.onObserveSuccessLoadCouponCarousel,
    required this.onObserveLoadingLoadCouponCarousel
  });
}

class OnObserveSuccessLoadProductBundleCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBundle> productBundleList;

  OnObserveSuccessLoadProductBundleCarouselParameter({
    required this.title,
    required this.description,
    required this.productBundleList
  });
}

class OnObserveLoadingLoadProductBundleCarouselParameter {}

class OnObserveSuccessLoadProductBrandCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductBrand> productBrandList;

  OnObserveSuccessLoadProductBrandCarouselParameter({
    required this.title,
    required this.description,
    required this.productBrandList
  });
}

class OnObserveLoadingLoadProductBrandCarouselParameter {}

class OnObserveSuccessLoadProductCategoryCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductCategory> productCategoryList;

  OnObserveSuccessLoadProductCategoryCarouselParameter({
    required this.title,
    required this.description,
    required this.productCategoryList
  });
}

class OnObserveLoadingLoadProductCategoryCarouselParameter {}

class OnObserveSuccessLoadProductEntryCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<ProductEntry> productEntryList;

  OnObserveSuccessLoadProductEntryCarouselParameter({
    required this.title,
    required this.description,
    required this.productEntryList
  });
}

class OnObserveLoadingLoadProductEntryCarouselParameter {}

class OnObserveSuccessLoadCouponCarouselParameter {
  MultiLanguageString? title;
  MultiLanguageString? description;
  List<Coupon> couponList;

  OnObserveSuccessLoadCouponCarouselParameter({
    required this.title,
    required this.description,
    required this.couponList
  });
}

class OnObserveLoadingLoadCouponCarouselParameter {}