import '../../domain/entity/product.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/productlistitemcontrollerstate/vertical_product_list_item_controller_state.dart';
import '../paging/pagingresult/paging_result_with_parameter.dart';
import '../shimmercarousellistitemgenerator/factory/product_shimmer_carousel_list_item_generator_factory.dart';
import 'additional_paging_result_parameter_checker.dart';

class ProductPagingResultParameterChecker extends AdditionalPagingResultParameterChecker<int, ListItemControllerState> {
  final ProductShimmerCarouselListItemGeneratorFactory productShimmerCarouselListItemGeneratorFactory;

  ProductPagingResultParameterChecker({
    required this.productShimmerCarouselListItemGeneratorFactory
  });

  @override
  PagingResultParameter<ListItemControllerState>? getAdditionalPagingResultParameter(
    AdditionalPagingResultCheckerParameter additionalPagingResultCheckerParameter
  ) {
    int page = additionalPagingResultCheckerParameter.page;
    List<ListItemControllerState> shimmerVerticalProductListItemControllerState = List<ListItemControllerState>.generate(6, (index) => ShimmerVerticalProductListItemControllerState(
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
          ...shimmerVerticalProductListItemControllerState
        ],
        showOriginalLoaderIndicator: false
      );
    } else {
      return null;
    }
  }
}