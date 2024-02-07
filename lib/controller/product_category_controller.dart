import '../domain/entity/product/productcategory/product_category.dart';
import '../domain/entity/product/productcategory/product_category_paging_parameter.dart';
import '../domain/usecase/get_product_category_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class ProductCategoryController extends BaseGetxController {
  final GetProductCategoryPagingUseCase getProductCategoryPagingUseCase;

  ProductCategoryController(
    super.controllerManager,
    this.getProductCategoryPagingUseCase
  );

  Future<LoadDataResult<PagingDataResult<ProductCategory>>> getProductCategoryPaging(ProductCategoryPagingParameter productCategoryPagingParameter) {
    return getProductCategoryPagingUseCase.execute(productCategoryPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-category-paging").value
    );
  }
}