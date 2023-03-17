import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:masterbagasi/data/datasource/productdatasource/default_product_data_source.dart';
import 'package:masterbagasi/data/datasource/productdatasource/product_data_source.dart';
import 'package:masterbagasi/data/repository/default_product_repository.dart';
import 'package:masterbagasi/domain/dummy/productdummy/product_bundle_dummy.dart';
import 'package:masterbagasi/domain/entity/product/product.dart';
import 'package:masterbagasi/domain/entity/product/product_detail_parameter.dart';
import 'package:masterbagasi/domain/entity/product/product_list_parameter.dart';
import 'package:masterbagasi/domain/repository/product_repository.dart';
import 'package:masterbagasi/domain/usecase/get_product_detail_use_case.dart';
import 'package:masterbagasi/domain/usecase/get_product_list_use_case.dart';
import 'package:masterbagasi/misc/http_client.dart';
import 'package:masterbagasi/misc/load_data_result.dart';

void main() {
  group('Product Use Case Test', () {
    late ProductDataSource productDataSource;
    late ProductRepository productRepository;
    late ProductBundleDummy productBundleDummy;

    // Get product list
    late GetProductListUseCase getProductList;
    late ProductListParameter productListParameter;

    // Get product detail
    late GetProductDetailUseCase getProductDetail;
    late ProductDetailParameter productDetailParameter;

    late Dio dio;
    late DioAdapter dioAdapter;

    setUp(() {
      dio = DioHttpClient.of();
      dioAdapter = DioAdapter(dio: dio);

      productBundleDummy = ProductBundleDummy();
      productDataSource = DefaultProductDataSource(dio: dio, productBundleDummy: productBundleDummy);
      productRepository = DefaultProductRepository(productDataSource: productDataSource);

      // Get product list
      getProductList = GetProductListUseCase(productRepository: productRepository);
      productListParameter = ProductListParameter();
    });

    test('get product', () async {
      dioAdapter.onGet(
        "/products",
        (server) => server.reply(
          200,
          jsonDecode("{\"isSuccess\":true,\"statusCode\":200,\"products\":[{\"id\":1579,\"name\":\"SO KLIN ROYALE PARFUM COLLECTION STARRY NIGHT\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/4230522.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"4230522\",\"product_code\":\"119\",\"unit\":\"800 ML\",\"price\":\"15000\",\"sku\":\"8998866808415\",\"product_selling_price\":\"27490\",\"product_discount_price\":\"15000\",\"detail-endpoint\":\"https://run.mocky.io/v3/a405cac1-0f33-4ace-bfa4-0b54a07e5db8\"},{\"id\":921,\"name\":\"MAMY POKO DIAPERS BABY PANTS 46\'S BOY\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/6730640.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"6730640\",\"product_code\":\"119\",\"unit\":\"46 PCS\",\"price\":\"137900\",\"sku\":\"8851111401727\",\"product_selling_price\":\"242390\",\"product_discount_price\":\"137900\",\"detail-endpoint\":\"https://run.mocky.io/v3/52f92062-4082-4c8b-bced-2e521473755e\"},{\"id\":809,\"name\":\"FARMHOUSE SMOKED BEEF\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/5500083.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"5500083\",\"product_code\":\"119\",\"unit\":\"225 Gram\",\"price\":\"40674\",\"sku\":\"8998888512956\",\"product_selling_price\":\"67790\",\"product_discount_price\":\"40674\",\"detail-endpoint\":\"https://run.mocky.io/v3/b6e8ffe3-2ccc-4f49-b5de-9257ebc653b5\"},{\"id\":2699,\"name\":\"CUSSONS KIDS BODY WASH PUMP ACTIVE\&NOURISH\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/6830426.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"6830426\",\"product_code\":\"119\",\"unit\":\"350 ML\",\"price\":\"21990\",\"sku\":\"\",\"product_selling_price\":\"29490\",\"product_discount_price\":\"21990\",\"detail-endpoint\":\"https://run.mocky.io/v3/7592b404-d161-4e23-a1ed-997a0cc6e48b\"},{\"id\":3113,\"name\":\"BAGUS FRESH AIR FRESHENER LEMON\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/4430635.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"4430635\",\"product_code\":\"119\",\"unit\":\"10 Gram\",\"price\":\"15900\",\"sku\":\"\",\"product_selling_price\":\"15900\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/d50fdc3a-a555-43ab-ba3b-8b7e6c4cf68e\"},{\"id\":433,\"name\":\"KOPIKO CANDY COFFEE\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/2405330.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"2405330\",\"product_code\":\"119\",\"unit\":\"90 Gram\",\"price\":\"8990\",\"sku\":\"8996001320051\",\"product_selling_price\":\"8990\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/f691a869-1255-4f47-9b9e-7b99782b2369\"},{\"id\":435,\"name\":\"KOPIKO CANDY CAPPUCCINO\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/2430527.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"2430527\",\"product_code\":\"119\",\"unit\":\"150 Gram\",\"price\":\"8990\",\"sku\":\"8996001320136\",\"product_selling_price\":\"8990\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/31b89c4d-873b-4921-b735-cb084e88b717\"},{\"id\":361,\"name\":\"OREO SANDWICH VANILLA\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/2030470.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"2030470\",\"product_code\":\"119\",\"unit\":\"133 Gram\",\"price\":\"8490\",\"sku\":\"8992760221028\",\"product_selling_price\":\"8490\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/0a706d93-7c65-4d20-a58f-57edf6dc0855\"},{\"id\":1491,\"name\":\"GIV BODY WASH PASS.FLOWERS\&SB\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/3330907.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"3330907\",\"product_code\":\"119\",\"unit\":\"450 ML\",\"price\":\"13900\",\"sku\":\"8998866806015\",\"product_selling_price\":\"23190\",\"product_discount_price\":\"13900\",\"detail-endpoint\":\"https://run.mocky.io/v3/a738b604-9ab1-4b1a-a3f5-b6058e1cc6ca\"},{\"id\":1845,\"name\":\"MANJUN SEAWEED CORN OIL\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/6030260.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"6030260\",\"product_code\":\"119\",\"unit\":\"15 Gram\",\"price\":\"20712\",\"sku\":\"8802241126141\",\"product_selling_price\":\"25890\",\"product_discount_price\":\"20712\",\"detail-endpoint\":\"https://run.mocky.io/v3/c1b06a23-613c-4344-a9c9-5d55fbc83c19\"}]}")
        ),
        queryParameters: {},
        headers: {},
      );
      CancelToken cancelToken = CancelToken();
      LoadDataResult<List<Product>> getProductListResponseLoadDataResult = await getProductList.execute(productListParameter).future(parameter: cancelToken);
      expect(getProductListResponseLoadDataResult is SuccessLoadDataResult<List<Product>>, true);
      List<Product> productList = (getProductListResponseLoadDataResult as SuccessLoadDataResult<List<Product>>).value;
      expect(productList.length, 10);
    });

    test('get product category', () async {
      dioAdapter.onGet(
        "/products",
        (server) => server.reply(
          200,
          jsonDecode("{\"isSuccess\":true,\"statusCode\":200,\"products\":[{\"id\":1579,\"name\":\"SO KLIN ROYALE PARFUM COLLECTION STARRY NIGHT\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/4230522.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"4230522\",\"product_code\":\"119\",\"unit\":\"800 ML\",\"price\":\"15000\",\"sku\":\"8998866808415\",\"product_selling_price\":\"27490\",\"product_discount_price\":\"15000\",\"detail-endpoint\":\"https://run.mocky.io/v3/a405cac1-0f33-4ace-bfa4-0b54a07e5db8\"},{\"id\":921,\"name\":\"MAMY POKO DIAPERS BABY PANTS 46\'S BOY\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/6730640.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"6730640\",\"product_code\":\"119\",\"unit\":\"46 PCS\",\"price\":\"137900\",\"sku\":\"8851111401727\",\"product_selling_price\":\"242390\",\"product_discount_price\":\"137900\",\"detail-endpoint\":\"https://run.mocky.io/v3/52f92062-4082-4c8b-bced-2e521473755e\"},{\"id\":809,\"name\":\"FARMHOUSE SMOKED BEEF\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/5500083.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"5500083\",\"product_code\":\"119\",\"unit\":\"225 Gram\",\"price\":\"40674\",\"sku\":\"8998888512956\",\"product_selling_price\":\"67790\",\"product_discount_price\":\"40674\",\"detail-endpoint\":\"https://run.mocky.io/v3/b6e8ffe3-2ccc-4f49-b5de-9257ebc653b5\"},{\"id\":2699,\"name\":\"CUSSONS KIDS BODY WASH PUMP ACTIVE\&NOURISH\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/6830426.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"6830426\",\"product_code\":\"119\",\"unit\":\"350 ML\",\"price\":\"21990\",\"sku\":\"\",\"product_selling_price\":\"29490\",\"product_discount_price\":\"21990\",\"detail-endpoint\":\"https://run.mocky.io/v3/7592b404-d161-4e23-a1ed-997a0cc6e48b\"},{\"id\":3113,\"name\":\"BAGUS FRESH AIR FRESHENER LEMON\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/4430635.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"4430635\",\"product_code\":\"119\",\"unit\":\"10 Gram\",\"price\":\"15900\",\"sku\":\"\",\"product_selling_price\":\"15900\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/d50fdc3a-a555-43ab-ba3b-8b7e6c4cf68e\"},{\"id\":433,\"name\":\"KOPIKO CANDY COFFEE\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/2405330.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"2405330\",\"product_code\":\"119\",\"unit\":\"90 Gram\",\"price\":\"8990\",\"sku\":\"8996001320051\",\"product_selling_price\":\"8990\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/f691a869-1255-4f47-9b9e-7b99782b2369\"},{\"id\":435,\"name\":\"KOPIKO CANDY CAPPUCCINO\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/2430527.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"2430527\",\"product_code\":\"119\",\"unit\":\"150 Gram\",\"price\":\"8990\",\"sku\":\"8996001320136\",\"product_selling_price\":\"8990\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/31b89c4d-873b-4921-b735-cb084e88b717\"},{\"id\":361,\"name\":\"OREO SANDWICH VANILLA\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/2030470.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"2030470\",\"product_code\":\"119\",\"unit\":\"133 Gram\",\"price\":\"8490\",\"sku\":\"8992760221028\",\"product_selling_price\":\"8490\",\"product_discount_price\":\"0\",\"detail-endpoint\":\"https://run.mocky.io/v3/0a706d93-7c65-4d20-a58f-57edf6dc0855\"},{\"id\":1491,\"name\":\"GIV BODY WASH PASS.FLOWERS\&SB\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/3330907.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"3330907\",\"product_code\":\"119\",\"unit\":\"450 ML\",\"price\":\"13900\",\"sku\":\"8998866806015\",\"product_selling_price\":\"23190\",\"product_discount_price\":\"13900\",\"detail-endpoint\":\"https://run.mocky.io/v3/a738b604-9ab1-4b1a-a3f5-b6058e1cc6ca\"},{\"id\":1845,\"name\":\"MANJUN SEAWEED CORN OIL\",\"default_image_url\":\"https://storage.googleapis.com/dev-superindo/product-image/6030260.jpg\",\"price_per_gram\":\"0\",\"product_plu\":\"6030260\",\"product_code\":\"119\",\"unit\":\"15 Gram\",\"price\":\"20712\",\"sku\":\"8802241126141\",\"product_selling_price\":\"25890\",\"product_discount_price\":\"20712\",\"detail-endpoint\":\"https://run.mocky.io/v3/c1b06a23-613c-4344-a9c9-5d55fbc83c19\"}]}")
        ),
        queryParameters: {},
        headers: {},
      );
      CancelToken cancelToken = CancelToken();
      LoadDataResult<List<Product>> getProductListResponseLoadDataResult = await getProductList.execute(productListParameter).future(parameter: cancelToken);
      expect(getProductListResponseLoadDataResult is SuccessLoadDataResult<List<Product>>, true);
      List<Product> productList = (getProductListResponseLoadDataResult as SuccessLoadDataResult<List<Product>>).value;
      expect(productList.length, 10);
    });
  });
}