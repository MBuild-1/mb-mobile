import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/product_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/dummy/productdummy/product_entry_dummy.dart';
import '../../../domain/dummy/userdummy/user_dummy.dart';
import '../../../domain/entity/product/productdiscussion/create_product_discussion_parameter.dart';
import '../../../domain/entity/product/productdiscussion/create_product_discussion_response.dart';
import '../../../domain/entity/product/productdiscussion/product_discussion.dart';
import '../../../domain/entity/product/productdiscussion/product_discussion_list_parameter.dart';
import '../../../domain/entity/product/productdiscussion/reply_product_discussion_parameter.dart';
import '../../../domain/entity/product/productdiscussion/reply_product_discussion_response.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'product_discussion_data_source.dart';

class DefaultProductDiscussionDataSource implements ProductDiscussionDataSource {
  final Dio dio;
  final UserDummy userDummy;
  final ProductEntryDummy productEntryDummy;

  const DefaultProductDiscussionDataSource({
    required this.dio,
    required this.userDummy,
    required this.productEntryDummy
  });

  @override
  FutureProcessing<ProductDiscussion> productDiscussion(ProductDiscussionParameter productDiscussionParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      return dio.get("/product/discussion/product/${productDiscussionParameter.productId}", cancelToken: cancelToken)
        .map<ProductDiscussion>(onMap: (value) => value.wrapResponse().mapFromResponseToProductDiscussion());
    });
  }

  @override
  FutureProcessing<CreateProductDiscussionResponse> createProductDiscussion(CreateProductDiscussionParameter createProductDiscussionParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        if (createProductDiscussionParameter.productId.isNotEmptyString) "product_id": createProductDiscussionParameter.productId,
        if (createProductDiscussionParameter.bundleId.isNotEmptyString) "bundling_id": createProductDiscussionParameter.bundleId,
        "message": createProductDiscussionParameter.message,
      }
    );
    return DioHttpClientProcessing((cancelToken) async {
      return dio.post("/product/discussion", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<CreateProductDiscussionResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCreateProductDiscussionResponse());
    });
  }

  @override
  FutureProcessing<ReplyProductDiscussionResponse> replyProductDiscussion(ReplyProductDiscussionParameter replyProductDiscussionParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "discussion_product_id": replyProductDiscussionParameter.discussionProductId,
        "message": replyProductDiscussionParameter.message,
      }
    );
    return DioHttpClientProcessing((cancelToken) async {
      return dio.post("/product/discussion/sub", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<ReplyProductDiscussionResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToReplyProductDiscussionResponse());
    });
  }
}