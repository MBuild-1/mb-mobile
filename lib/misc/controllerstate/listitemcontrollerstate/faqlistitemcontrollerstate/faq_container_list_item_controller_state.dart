import '../list_item_controller_state.dart';
import 'faq_list_item_controller_state.dart';

class FaqContainerListItemControllerState extends ListItemControllerState {
  List<FaqListItemValue> faqListItemValueList;
  void Function() onUpdateState;
  bool showHeader;

  FaqContainerListItemControllerState({
    required this.faqListItemValueList,
    required this.onUpdateState,
    required this.showHeader
  });
}