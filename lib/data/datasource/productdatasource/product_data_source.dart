import 'package:masterbagasi/domain/entity/product_list_parameter.dart';

import '../../../domain/entity/product_detail_parameter.dart';
import '../../../misc/processing/future_processing.dart';
import '../../model/product_model.dart';

abstract class ProductDataSource {
  FutureProcessing<List<ProductModel>> productList(ProductListParameter productListParameter);
  FutureProcessing<ProductModel> productDetail(ProductDetailParameter productDetailParameter);
}