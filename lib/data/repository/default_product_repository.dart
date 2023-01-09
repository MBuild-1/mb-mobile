import 'package:masterbagasi/data/model/product_model.dart';

import '../../domain/entity/product.dart';
import '../../domain/entity/product_detail_parameter.dart';
import '../../domain/entity/product_list_parameter.dart';
import '../../domain/repository/product_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/productdatasource/product_data_source.dart';

class DefaultProductRepository implements ProductRepository {
  final ProductDataSource productDataSource;

  const DefaultProductRepository({
    required this.productDataSource
  });

  @override
  FutureProcessing<LoadDataResult<List<Product>>> productList(ProductListParameter productListParameter) {
    return productDataSource.productList(productListParameter)
      .map<List<Product>>(onMap: (productModelList) => productModelList.map((productModel) => productModel.toProduct()).toList())
      .mapToLoadDataResult<List<Product>>();
  }

  @override
  FutureProcessing<LoadDataResult<Product>> productDetail(ProductDetailParameter productDetailParameter) {
    return productDataSource.productDetail(productDetailParameter)
      .map<Product>(onMap: (productModel) => productModel.toProduct())
      .mapToLoadDataResult<Product>();
  }
}