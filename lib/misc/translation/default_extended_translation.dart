import '../constant.dart';
import 'extended_translation.dart';

class DefaultExtendedTranslation extends ExtendedTranslation {
  @override
  Map<String, Map<String, String>> get keys => {
    Constant.textInIdLanguageKey: {
      "Start": "Mulai",
      "Next": "Berikutnya",
      "Skip": "Lewati"
    }
  };

  @override
  Map<String, Map<String, OnInitTextSpan>> get keysForTextSpan => {};
}