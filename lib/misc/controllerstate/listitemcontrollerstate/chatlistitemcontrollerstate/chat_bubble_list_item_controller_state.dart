import '../../../../domain/entity/chat/help/help_message.dart';
import '../../../../domain/entity/user/user.dart';
import '../list_item_controller_state.dart';

class ChatBubbleListItemControllerState extends ListItemControllerState {
  HelpMessage helpMessage;
  User loggedUser;

  ChatBubbleListItemControllerState({
    required this.helpMessage,
    required this.loggedUser
  });
}