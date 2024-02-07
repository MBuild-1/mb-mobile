import 'product_discussion_dialog_item.dart';

class VerticalProductDiscussionDialogItem extends ProductDiscussionDialogItem {
  const VerticalProductDiscussionDialogItem({
    super.key,
    required super.productDiscussionDialog,
    required super.isExpanded,
    super.isMainProductDiscussion = false,
    super.onTapProductDiscussionDialog,
    required super.isLoading
  });
}