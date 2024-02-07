import '../../../misc/multi_language_string.dart';

class Faq {
  String id;
  MultiLanguageString titleMultiLanguageString;
  MultiLanguageString contentMultiLanguageString;

  Faq({
    required this.id,
    required this.titleMultiLanguageString,
    required this.contentMultiLanguageString
  });
}