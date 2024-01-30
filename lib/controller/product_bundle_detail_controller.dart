import '../domain/entity/product/productbundle/product_bundle_detail.dart';
import '../domain/entity/product/productbundle/product_bundle_detail_by_slug_parameter.dart';
import '../domain/entity/product/productbundle/product_bundle_detail_parameter.dart';
import '../domain/usecase/get_product_bundle_detail_by_slug_use_case.dart';
import '../domain/usecase/get_product_bundle_detail_use_case.dart';
import '../misc/controllercontentdelegate/wishlist_and_cart_controller_content_delegate.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class ProductBundleDetailController extends BaseGetxController {
  final GetProductBundleDetailUseCase getProductBundleDetailUseCase;
  final GetProductBundleDetailBySlugUseCase getProductBundleDetailBySlugUseCase;
  final WishlistAndCartControllerContentDelegate wishlistAndCartControllerContentDelegate;

  ProductBundleDetailController(
    super.controllerManager,
    this.getProductBundleDetailUseCase,
    this.getProductBundleDetailBySlugUseCase,
    this.wishlistAndCartControllerContentDelegate
  ) {
    wishlistAndCartControllerContentDelegate.setApiRequestManager(
      () => apiRequestManager
    );
  }

  Future<LoadDataResult<ProductBundleDetail>> getProductBundleDetail(ProductBundleDetailParameter productBundleDetailParameter) {
    return getProductBundleDetailUseCase.execute(productBundleDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-bundle-detail").value
    );
  }

  Future<LoadDataResult<ProductBundleDetail>> getProductBundleDetailBySlug(ProductBundleDetailBySlugParameter productBundleDetailBySlugParameter) {
    return getProductBundleDetailBySlugUseCase.execute(productBundleDetailBySlugParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-bundle-detail-by-slug").value
    );
  }
}