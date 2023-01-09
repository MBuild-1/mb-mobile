import 'package:dio/dio.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/product_detail_parameter.dart';
import '../../../domain/entity/product_list_parameter.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import '../../model/product_model.dart';
import 'product_data_source.dart';

class DefaultProductDataSource implements ProductDataSource {
  final Dio dio;

  const DefaultProductDataSource({
    required this.dio
  });

  @override
  FutureProcessing<List<ProductModel>> productList(ProductListParameter productListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/products", cancelToken: cancelToken)
        .map<List<ProductModel>>(
          onMap: (value) => value.wrapResponse().response["products"].map<ProductModel>(
            (productModelResponse) => ProductModel.fromJson(productModelResponse)
          ).toList()
        );
    });
  }

  @override
  FutureProcessing<ProductModel> productDetail(ProductDetailParameter productDetailParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("", cancelToken: cancelToken, options: OptionsBuilder.withBaseUrl(productDetailParameter.productDetailEndpoint).buildExtended())
        .map(onMap: (value) => ProductModel.fromJson(value.wrapResponse().response["data"]));
    });
  }
}