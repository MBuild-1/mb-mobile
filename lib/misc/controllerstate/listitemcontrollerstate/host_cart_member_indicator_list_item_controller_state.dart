import '../../../domain/entity/bucket/bucket_member.dart';
import 'list_item_controller_state.dart';

class HostCartMemberIndicatorListItemControllerState extends ListItemControllerState {
  BucketMember bucketMember;
  int memberNo;
  bool isMe;

  HostCartMemberIndicatorListItemControllerState({
    required this.bucketMember,
    required this.memberNo,
    required this.isMe
  });
}