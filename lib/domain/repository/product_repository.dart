import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/product.dart';
import '../entity/product_detail_parameter.dart';
import '../entity/product_list_parameter.dart';

abstract class ProductRepository {
  FutureProcessing<LoadDataResult<List<Product>>> productList(ProductListParameter productListParameter);
  FutureProcessing<LoadDataResult<Product>> productDetail(ProductDetailParameter productDetailParameter);
}