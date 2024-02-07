import 'package:collection/collection.dart';

import '../../domain/entity/summaryvalue/summary_value.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/response_wrapper.dart';

extension SummaryValueEntityMappingExt on ResponseWrapper {
  List<SummaryValue> mapFromResponseToSummaryValueList() {
    String indexToString(int index) {
      return (index + 1).toString();
    }
    if (response is List) {
      return (response as List).mapIndexed<SummaryValue>(
        (index, summaryResponse) => ResponseWrapper(summaryResponse).mapFromResponseToSummaryValue(indexToString(index))
      ).toList();
    } else if (response is Map) {
      return [ResponseWrapper(response).mapFromResponseToSummaryValue(indexToString(0))];
    } else {
      return [];
    }
  }

  SummaryValue mapFromResponseToSummaryValue(String id) {
    return SummaryValue(
      id: id,
      name: MultiLanguageString(response["name"]),
      type: response["type"],
      value: response["value"]
    );
  }
}