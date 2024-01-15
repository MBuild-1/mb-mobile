import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

import '../date_util.dart';
import '../paging/pagingresult/paging_data_result.dart';
import '../response_wrapper.dart';

extension MainStructureResponseWrapperExt on Response<dynamic> {
  MainStructureResponseWrapper wrapResponse() {
    return MainStructureResponseWrapper.factory(data);
  }
}

extension DateTimeResponseWrapperExt on ResponseWrapper {
  DateTime? mapFromResponseToDateTime({DateFormat? dateFormat, bool convertIntoLocalTime = true}) {
    DateTime? fetchedDateTime = response != null ? (dateFormat ?? DateUtil.anthonyInputDateFormat).parse(response) : null;
    if (!convertIntoLocalTime) {
      return fetchedDateTime;
    }
    Duration? timezoneOffset = fetchedDateTime?.timeZoneOffset;
    return fetchedDateTime?.add(timezoneOffset!);
  }
}

extension PagingResponseWrapperExt on ResponseWrapper {
  PagingDataResult<T> mapFromResponseToPagingDataResult<T>(List<T> Function(dynamic dataResponse) onMapToPagingDataResult) {
    bool isResponseMap = response is Map<String, dynamic>;
    dynamic data = isResponseMap ? response["data"] : response;
    dynamic currentPage = isResponseMap ? response["current_page"] : null;
    return PagingDataResult<T>(
      page: currentPage ?? 1,
      totalPage: (isResponseMap ? response["last_page"] : null) ?? 1,
      totalItem: (isResponseMap ? response["total"] : null) ?? -1,
      itemList: onMapToPagingDataResult(data)
    );
  }
}

extension DoubleResponseWrapperExt on ResponseWrapper {
  double? mapFromResponseToDouble() {
    if (response is int) {
      return (response as int).toDouble();
    } else if (response is double) {
      return response;
    } else if (response is String) {
      return double.tryParse(response);
    } else {
      return response;
    }
  }
}

extension IntResponseWrapperExt on ResponseWrapper {
  int? mapFromResponseToInt() {
    if (response is int) {
      return response;
    } else if (response is double) {
      return (response as double).toInt();
    } else if (response is String) {
      return int.tryParse(response);
    } else {
      return response;
    }
  }
}