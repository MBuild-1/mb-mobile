import '../../../misc/multi_language_string.dart';

class SummaryValue {
  String id;
  MultiLanguageString name;
  String type;
  dynamic value;

  SummaryValue({
    required this.id,
    required this.name,
    required this.type,
    required this.value
  });
}