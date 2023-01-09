import 'package:dio/dio.dart';

import '../date_util.dart';
import '../response_wrapper.dart';

extension MainStructureResponseWrapperExt on Response<dynamic> {
  MainStructureResponseWrapper wrapResponse() {
    return MainStructureResponseWrapper.factory(data);
  }
}

extension DateTimeResponseWrapperExt on ResponseWrapper {
  DateTime? mapFromResponseToDateTime() {
    return response != null ? DateUtil.standardDateFormat.parse(response) : null;
  }
}