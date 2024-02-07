import '../../../../domain/entity/selectlanguage/select_language.dart';
import '../list_item_controller_state.dart';

abstract class SelectLanguageListItemControllerState extends ListItemControllerState {
  SelectLanguage selectLanguage;
  bool isSelected;
  void Function(SelectLanguage)? onSelectLanguage;

  SelectLanguageListItemControllerState({
    required this.selectLanguage,
    required this.isSelected,
    required this.onSelectLanguage
  });
}