import '../domain/entity/product/productbrand/product_brand.dart';
import '../domain/entity/product/productbrand/product_brand_paging_parameter.dart';
import '../domain/usecase/get_product_brand_paging_use_case.dart';
import '../domain/usecase/get_selected_fashion_brands_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class ProductBrandController extends BaseGetxController {
  final GetProductBrandPagingUseCase getProductBrandPagingUseCase;
  final GetSelectedFashionBrandsPagingUseCase getSelectedFashionBrandsPagingUseCase;

  ProductBrandController(
    super.controllerManager,
    this.getProductBrandPagingUseCase,
    this.getSelectedFashionBrandsPagingUseCase
  );

  Future<LoadDataResult<PagingDataResult<ProductBrand>>> getProductBrandPaging(ProductBrandPagingParameter productBrandPagingParameter) {
    return getProductBrandPagingUseCase.execute(productBrandPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-brand-paging").value
    );
  }

  Future<LoadDataResult<PagingDataResult<ProductBrand>>> getSelectedFashionBrandsPaging(ProductBrandPagingParameter productBrandPagingParameter) {
    return getSelectedFashionBrandsPagingUseCase.execute(productBrandPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("selected-product-brand-paging").value
    );
  }
}