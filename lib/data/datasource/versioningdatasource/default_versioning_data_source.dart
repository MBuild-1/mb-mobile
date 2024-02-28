import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/versioning_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/versioning/canbeupdatedversioning/all_versioning_parameter.dart';
import '../../../domain/entity/versioning/canbeupdatedversioning/all_versioning_response.dart';
import '../../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';
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
  FutureProcessing<AllVersioningResponse> allVersioning(AllVersioningParameter allVersioningParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get(
        "/dashboard/versioning",
        cancelToken: cancelToken,
        options: OptionsBuilder.multipartData().withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<AllVersioningResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToAllVersioningResponse()
      );
    });
  }

  @override
  FutureProcessing<VersioningBasedFilterResponse> versioningBasedFilter(VersioningBasedFilterParameter versioningBasedFilterParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get(
        "/dashboard/versioning",
        cancelToken: cancelToken,
        queryParameters: <String, dynamic>{
          if (versioningBasedFilterParameter.version.isNotEmptyString) "version": versioningBasedFilterParameter.version!,
          if (versioningBasedFilterParameter.buildNumber != null) "build_number": versioningBasedFilterParameter.buildNumber
        },
        options: OptionsBuilder.multipartData().withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<VersioningBasedFilterResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToVersioningBasedFilterResponse()
      );
    });
  }
}