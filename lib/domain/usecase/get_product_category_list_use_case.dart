import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product/productcategory/product_category.dart';
import '../entity/product/productcategory/product_category_paging_parameter.dart';
import '../repository/product_repository.dart';

class GetProductCategoryListUseCase {
  final ProductRepository productRepository;

  const GetProductCategoryListUseCase({
    required this.productRepository
  });

  FutureProcessing<LoadDataResult<List<ProductCategory>>> execute() {
    return productRepository.productCategoryPaging(
      ProductCategoryPagingParameter(page: 1, itemEachPageCount: 10)
    ).map<LoadDataResult<List<ProductCategory>>>(
      onMap: (productCategoryPagingDataResult) {
        return productCategoryPagingDataResult.map<List<ProductCategory>>(
          (productBrandPaging) => productBrandPaging.itemList
        );
      }
    );
  }
}