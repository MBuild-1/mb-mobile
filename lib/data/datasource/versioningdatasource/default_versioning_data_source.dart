import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/versioning_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_parameter.dart';
import '../../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'versioning_data_source.dart';

class DefaultVersioningDataSource implements VersioningDataSource {
  final Dio dio;

  const DefaultVersioningDataSource({
    required this.dio
  });

  @override
  FutureProcessing<CanBeUpdatedVersioningResponse> canBeUpdatedVersioning(CanBeUpdatedVersioningParameter canBeUpdatedVersioningParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get(
        "/dashboard/versioning",
        cancelToken: cancelToken,
        options: OptionsBuilder.multipartData().withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<CanBeUpdatedVersioningResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToCanBeUpdatedVersioningResponse()
      );
    });
  }
}