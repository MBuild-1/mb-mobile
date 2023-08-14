import 'list_item_controller_state.dart';

class StackContainerListItemControllerState extends ListItemControllerState {
  List<ListItemControllerState> childListItemControllerStateList;

  StackContainerListItemControllerState({
    required this.childListItemControllerStateList
  });
}