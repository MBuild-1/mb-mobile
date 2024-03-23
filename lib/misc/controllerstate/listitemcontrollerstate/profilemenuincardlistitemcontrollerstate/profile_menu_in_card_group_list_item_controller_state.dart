import '../list_item_controller_state.dart';
import 'profile_menu_in_card_list_item_controller_state.dart';

class ProfileMenuInCardGroupListItemControllerState extends ListItemControllerState {
  String? title;
  bool isExpand;
  bool canExpand;
  List<ProfileMenuInCardListItemControllerState> profileMenuInCardListItemControllerStateList;
  void Function() onUpdateState;

  ProfileMenuInCardGroupListItemControllerState({
    this.title,
    this.isExpand = true,
    this.canExpand = false,
    required this.onUpdateState,
    required this.profileMenuInCardListItemControllerStateList
  });
}