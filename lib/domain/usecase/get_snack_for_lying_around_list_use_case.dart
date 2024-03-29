import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/product_with_condition_paging_parameter.dart';
import '../entity/product/productentry/product_entry.dart';
import '../repository/product_repository.dart';

class GetSnackForLyingAroundListUseCase {
  final ProductRepository productRepository;

  const GetSnackForLyingAroundListUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<ProductEntry>>> execute() {
    return productRepository.productWithConditionPaging(
      ProductWithConditionPagingParameter(
        page: 1,
        itemEachPageCount: 20,
        withCondition: {
          'category': 'cemilan-buat-rebahan',
        }
      )
    ).map(
      onMap: (productEntryPagingDataResultLoadDataResult) {
        return productEntryPagingDataResultLoadDataResult.map<List<ProductEntry>>((productEntryPagingDataResult) {
          return productEntryPagingDataResult.itemList;
        });
      }
    );
  }
}