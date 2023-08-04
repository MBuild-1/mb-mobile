import '../../../../domain/entity/chat/help/help_message.dart';
import '../../../../domain/entity/user/user.dart';
import '../list_item_controller_state.dart';

class ChatContainerListItemControllerState extends ListItemControllerState {
  List<HelpMessage> helpMessageList;
  User loggedUser;

  ChatContainerListItemControllerState({
    required this.helpMessageList,
    required this.loggedUser
  });
}