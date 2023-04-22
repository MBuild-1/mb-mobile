import '../domain/entity/product/product_with_condition_paging_parameter.dart';
import '../domain/entity/product/productentry/product_entry.dart';
import '../domain/usecase/get_product_entry_with_condition_paging_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/paging/pagingresult/paging_data_result.dart';
import 'base_getx_controller.dart';

class ProductEntryController extends BaseGetxController {
  final GetProductEntryWithConditionPagingUseCase getProductEntryWithConditionPagingUseCase;

  ProductEntryController(
    super.controllerManager,
    this.getProductEntryWithConditionPagingUseCase
  );

  Future<LoadDataResult<PagingDataResult<ProductEntry>>> getProductEntryPaging(ProductWithConditionPagingParameter productWithConditionPagingParameter) {
    return getProductEntryWithConditionPagingUseCase.execute(productWithConditionPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("product-entry-is-viral").value
    );
  }
}