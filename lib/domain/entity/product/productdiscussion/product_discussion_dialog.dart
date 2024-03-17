import '../../user/user.dart';
import '../product_in_discussion.dart';
import 'product_discussion_user.dart';

class ProductDiscussionDialog {
  String id;
  String? productId;
  String? bundleId;
  String userId;
  String discussion;
  DateTime discussionDate;
  ProductDiscussionUser productDiscussionUser;
  ProductInDiscussion? productInDiscussion;
  List<ProductDiscussionDialog> replyProductDiscussionDialogList;

  ProductDiscussionDialog({
    required this.id,
    required this.productId,
    required this.bundleId,
    required this.userId,
    required this.discussion,
    required this.discussionDate,
    required this.productDiscussionUser,
    required this.productInDiscussion,
    this.replyProductDiscussionDialogList = const []
  });
}