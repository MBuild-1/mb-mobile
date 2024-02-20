import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/faq_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/faq/faq.dart';
import '../../../domain/entity/faq/faq_list_parameter.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'faq_data_source.dart';

class DefaultFaqDataSource implements FaqDataSource {
  final Dio dio;

  DefaultFaqDataSource({
    required this.dio
  });

  @override
  FutureProcessing<List<Faq>> faqList(FaqListParameter faqListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/faq", cancelToken: cancelToken)
        .map<List<Faq>>(onMap: (value) => value.wrapResponse().mapFromResponseToFaqList());
    });
  }
}