import '../../../../domain/entity/chat/help/help_message.dart';
import '../list_item_controller_state.dart';

class ChatContainerListItemControllerState extends ListItemControllerState {
  List<HelpMessage> helpMessageList;

  ChatContainerListItemControllerState({
    required this.helpMessageList
  });
}