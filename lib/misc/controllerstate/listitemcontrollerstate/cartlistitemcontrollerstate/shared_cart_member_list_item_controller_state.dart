import '../../../../domain/entity/bucket/bucket_member.dart';
import '../../../../presentation/widget/sharedcart/shared_cart_member_item.dart';
import '../list_item_controller_state.dart';

class SharedCartMemberListItemControllerState extends ListItemControllerState {
  BucketMember bucketMember;
  void Function() onTapDelete;
  void Function() onTapMore;
  void Function(SharedCartAcceptOrDeclineMemberResult)? onAcceptOrDeclineMember;
  bool isExpanded;

  SharedCartMemberListItemControllerState({
    required this.bucketMember,
    required this.onTapDelete,
    required this.onTapMore,
    required this.onAcceptOrDeclineMember,
    required this.isExpanded
  });
}