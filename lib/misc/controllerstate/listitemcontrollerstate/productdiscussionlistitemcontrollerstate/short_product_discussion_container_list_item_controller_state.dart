import '../../../../domain/entity/product/productdiscussion/product_discussion.dart';
import 'base_product_discussion_container_list_item_controller_state.dart';

class ShortProductDiscussionContainerListItemControllerState extends BaseProductDiscussionContainerListItemControllerState {
  void Function(ProductDiscussion)? onTapMore;

  ShortProductDiscussionContainerListItemControllerState({
    required super.productDiscussionListItemValue,
    required super.onGetErrorProvider,
    required super.onUpdateState,
    required this.onTapMore,
    required super.onGotoReplyProductDiscussionPage,
  });
}