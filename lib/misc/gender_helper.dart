import 'constant.dart';
import 'gender.dart';
import 'multi_language_string.dart';

class _GenderHelperImpl {
  List<Gender> get genderList => <Gender>[
    Gender(
      value: "Male",
      text: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Male",
        Constant.textInIdLanguageKey: "Laki-laki"
      })
    ),
    Gender(
      value: "Female",
      text: MultiLanguageString({
        Constant.textEnUsLanguageKey: "Female",
        Constant.textInIdLanguageKey: "Perempuan"
      })
    ),
  ];
}

// ignore: non_constant_identifier_names
final _GenderHelperImpl GenderHelper = _GenderHelperImpl();