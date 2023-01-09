import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../domain/entity/product.dart';
import '../constant.dart';
import '../controllerstate/listitemcontrollerstate/carousel_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/title_and_description_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/virtual_spacing_list_item_controller_state.dart';
import '../injector.dart';
import '../paging/pagingresult/paging_result_with_parameter.dart';
import '../shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import '../shimmercarousellistitemgenerator/type/product_shimmer_carousel_list_item_generator_type.dart';
import 'additional_paging_result_parameter_checker.dart';

class HomePagingResultParameterChecker extends AdditionalPagingResultParameterChecker<int, ListItemControllerState> {
  final ProductShimmerCarouselListItemGeneratorFactory productShimmerCarouselListItemGeneratorFactory;

  HomePagingResultParameterChecker({
    required this.productShimmerCarouselListItemGeneratorFactory
  });

  @override
  PagingResultParameter<ListItemControllerState>? getAdditionalPagingResultParameter(
    AdditionalPagingResultCheckerParameter additionalPagingResultCheckerParameter
  ) {
    int page = additionalPagingResultCheckerParameter.page;
    List<ListItemControllerState> shimmerVerticalProductListItemControllerState = List<ListItemControllerState>.generate(4, (index) => ShimmerVerticalProductListItemControllerState(
      product: Product(
        id: -1,
        name: "Dummy Shimmer Product",
        defaultImageUrl: "",
        pricePerGram: 0,
        productPlu: "",
        productCode: "",
        unit: "",
        price: 0,
        sku: "",
        productSellingPrice: 0,
        productDiscountPrice: 0,
      )
    ));
    if (page == 1) {
      return PagingResultParameter<ListItemControllerState>(
        additionalItemList: <ListItemControllerState>[
          ShimmerCarouselListItemControllerState<Product, ProductShimmerCarouselListItemGeneratorType>(
            showTitleShimmer: true,
            showDescriptionShimmer: true,
            showItemShimmer: true,
            shimmerCarouselListItemGenerator: Injector.locator<ProductShimmerCarouselListItemGeneratorFactory>().getShimmerCarouselListItemGeneratorType()
          ),
          VirtualSpacingListItemControllerState(height: Constant.paddingListItem),
          ShimmerTitleAndDescriptionListItemControllerState(
            padding: EdgeInsets.only(
              left: Constant.paddingListItem,
              right: Constant.paddingListItem,
            ),
            title: "Other Product".tr,
            description: "${"Discover our other product in SuperIndo".tr}.",
            verticalSpace: (0.3).h
          ),
          ...shimmerVerticalProductListItemControllerState
        ],
        showOriginalLoaderIndicator: false
      );
    } else {
      return null;
    }
  }
}