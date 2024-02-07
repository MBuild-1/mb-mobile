import '../../domain/entity/summaryvalue/summary_value.dart';

extension SummaryValueExt on SummaryValue {
  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      "name": name.value,
      "type": type,
      "value": value
    };
  }
}