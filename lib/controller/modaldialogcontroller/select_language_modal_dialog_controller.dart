import '../../domain/entity/selectlanguage/select_language.dart';
import 'modal_dialog_controller.dart';

typedef _OnGetSelectedLanguage = SelectLanguage? Function();
typedef _OnSaveSelectedLanguage = Future<void> Function(String);

class SelectLanguageModalDialogController extends ModalDialogController {
  SelectLanguageDelegate? _selectLanguageDelegate;

  SelectLanguageModalDialogController(
    super.controllerManager,
  );

  SelectLanguageModalDialogController setSelectLanguageDelegate(SelectLanguageDelegate selectLanguageDelegate) {
    _selectLanguageDelegate = selectLanguageDelegate;
    return this;
  }

  void saveSelectedLanguage(SelectLanguage? selectedLanguage) {
    if (_selectLanguageDelegate != null) {
      SelectLanguage? selectedLanguage = _selectLanguageDelegate!.onGetSelectedLanguage();
      if (selectedLanguage != null) {
        _selectLanguageDelegate!.onSaveSelectedLanguage(selectedLanguage.localeString);
      }
    }
  }
}

class SelectLanguageDelegate {
  _OnGetSelectedLanguage onGetSelectedLanguage;
  _OnSaveSelectedLanguage onSaveSelectedLanguage;

  SelectLanguageDelegate({
    required this.onGetSelectedLanguage,
    required this.onSaveSelectedLanguage
  });
}