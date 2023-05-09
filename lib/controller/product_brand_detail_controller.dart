import '../domain/entity/product/productbrand/product_brand_detail.dart';
import '../domain/entity/product/productbrand/product_brand_detail_parameter.dart';
import '../domain/usecase/get_product_brand_detail_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class ProductBrandDetailController extends BaseGetxController {
  final GetProductBrandDetailUseCase getProductBrandDetailUseCase;

  ProductBrandDetailController(super.controllerManager, this.getProductBrandDetailUseCase);

  Future<LoadDataResult<ProductBrandDetail>> getProductBrandDetail(ProductBrandDetailParameter productBrandDetailParameter) {
    return getProductBrandDetailUseCase.execute(productBrandDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-brand-detail").value
    );
  }
}