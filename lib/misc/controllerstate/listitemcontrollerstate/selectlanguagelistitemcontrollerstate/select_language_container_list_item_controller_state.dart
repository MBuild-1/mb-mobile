import '../../../../domain/entity/selectlanguage/select_language.dart';
import '../list_item_controller_state.dart';

typedef OnGetSelectLanguage = SelectLanguage? Function();

class SelectLanguageContainerListItemControllerState extends ListItemControllerState {
  List<SelectLanguage> selectLanguageList;
  OnGetSelectLanguage? onGetSelectLanguage;
  void Function(SelectLanguage) onSelectLanguage;
  void Function() onUpdateState;

  SelectLanguageContainerListItemControllerState({
    required this.selectLanguageList,
    this.onGetSelectLanguage,
    required this.onSelectLanguage,
    required this.onUpdateState
  });
}