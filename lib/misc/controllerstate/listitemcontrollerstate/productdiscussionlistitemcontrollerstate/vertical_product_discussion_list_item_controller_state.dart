import 'product_discussion_list_item_controller_state.dart';

class VerticalProductDiscussionListItemControllerState extends ProductDiscussionListItemControllerState {
  VerticalProductDiscussionListItemControllerState({
    required super.productDiscussionDetailListItemValue,
    required super.isExpanded,
    super.onProductDiscussionTap,
    required super.supportDiscussionLoadDataResult,
    required super.errorProvider
  });
}