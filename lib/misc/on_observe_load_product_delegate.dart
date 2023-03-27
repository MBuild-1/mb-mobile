import '../domain/entity/product/productbrand/product_brand.dart';
import '../domain/entity/product/productbundle/product_bundle.dart';
import '../domain/entity/product/productcategory/product_category.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import 'controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import 'multi_language_string.dart';

class OnObserveLoadProductDelegate {
  ListItemControllerState Function(OnObserveSuccessLoadProductBrandCarouselParameter) onObserveSuccessLoadProductBrandCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductBrandCarouselParameter) onObserveLoadingLoadProductBrandCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadProductCategoryCarouselParameter) onObserveSuccessLoadProductCategoryCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductCategoryCarouselParameter) onObserveLoadingLoadProductCategoryCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadProductEntryCarouselParameter) onObserveSuccessLoadProductEntryCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductEntryCarouselParameter) onObserveLoadingLoadProductEntryCarousel;
  ListItemControllerState Function(OnObserveSuccessLoadProductBundleCarouselParameter) onObserveSuccessLoadProductBundleCarousel;
  ListItemControllerState Function(OnObserveLoadingLoadProductBundleCarouselParameter) onObserveLoadingLoadProductBundleCarousel;

  OnObserveLoadProductDelegate({
    required this.onObserveSuccessLoadProductBrandCarousel,
    required this.onObserveLoadingLoadProductBrandCarousel,
    required this.onObserveSuccessLoadProductCategoryCarousel,
    required this.onObserveLoadingLoadProductCategoryCarousel,
    required this.onObserveSuccessLoadProductEntryCarousel,
    required this.onObserveLoadingLoadProductEntryCarousel,
    required this.onObserveSuccessLoadProductBundleCarousel,
    required this.onObserveLoadingLoadProductBundleCarousel,
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