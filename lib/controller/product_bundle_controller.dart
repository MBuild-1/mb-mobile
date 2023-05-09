import '../domain/entity/product/productbundle/product_bundle.dart';
import '../domain/entity/product/productbundle/product_bundle_paging_parameter.dart';
import '../domain/usecase/get_product_bundle_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class ProductBundleController extends BaseGetxController {
  final GetProductBundlePagingUseCase getProductBundlePagingUseCase;

  ProductBundleController(super.controllerManager, this.getProductBundlePagingUseCase);

  Future<LoadDataResult<PagingDataResult<ProductBundle>>> getProductBundlePaging(ProductBundlePagingParameter productBundlePagingParameter) {
    return getProductBundlePagingUseCase.execute(productBundlePagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-bundle").value
    );
  }
}