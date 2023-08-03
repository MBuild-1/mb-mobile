import '../../../../domain/entity/chat/help/help_message.dart';
import '../list_item_controller_state.dart';

class ChatBubbleListItemControllerState extends ListItemControllerState {
  HelpMessage helpMessage;

  ChatBubbleListItemControllerState({
    required this.helpMessage
  });
}