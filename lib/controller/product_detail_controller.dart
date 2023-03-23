import '../domain/entity/product/product.dart';
import '../domain/entity/product/product_detail_parameter.dart';
import '../domain/usecase/get_product_detail_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class ProductDetailController extends BaseGetxController {
  final GetProductDetailUseCase getProductDetailUseCase;

  ProductDetailController(super.controllerManager, this.getProductDetailUseCase);

  Future<LoadDataResult<Product>> getProductDetail(ProductDetailParameter productDetailParameter) {
    return getProductDetailUseCase.execute(productDetailParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-detail").value
    );
  }
}