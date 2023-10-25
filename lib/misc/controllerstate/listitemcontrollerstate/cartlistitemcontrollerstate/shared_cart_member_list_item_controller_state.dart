import '../../../../domain/entity/bucket/bucket_member.dart';
import '../../../../presentation/widget/sharedcart/shared_cart_member_item.dart';
import '../list_item_controller_state.dart';

class SharedCartMemberListItemControllerState extends ListItemControllerState {
  BucketMember bucketMember;
  void Function()? onTapDelete;
  void Function()? onTapReady;
  void Function() onTapMore;
  void Function(SharedCartAcceptOrDeclineMemberResult)? onAcceptOrDeclineMember;
  bool isExpanded;
  bool showReadyButton;
  bool showDeleteButton;
  int readyStatus;

  SharedCartMemberListItemControllerState({
    required this.bucketMember,
    required this.onTapDelete,
    required this.onTapReady,
    required this.onTapMore,
    required this.onAcceptOrDeclineMember,
    required this.isExpanded,
    required this.showReadyButton,
    required this.showDeleteButton,
    required this.readyStatus
  });
}