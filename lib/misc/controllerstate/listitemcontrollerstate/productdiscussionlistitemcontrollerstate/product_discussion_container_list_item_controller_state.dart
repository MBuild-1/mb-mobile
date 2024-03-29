import '../../../../domain/entity/discussion/support_discussion.dart';
import '../../../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';
import 'base_product_discussion_container_list_item_controller_state.dart';
import 'product_discussion_list_item_controller_state.dart';

class ProductDiscussionContainerListItemControllerState extends BaseProductDiscussionContainerListItemControllerState {
  LoadDataResult<SupportDiscussion> Function() onGetSupportDiscussion;
  bool Function() onGetIsBasedUser;
  ProductDiscussionContainerInterceptingActionListItemControllerState productDiscussionContainerInterceptingActionListItemControllerState;
  void Function(ProductDiscussionDialog) onReplyProductDiscussionDialog;
  String? Function() onGetDiscussionProductId;
  Map<String, LoadDataResult<SupportDiscussion>> Function() onGetSupportDiscussionBasedDiscussionId;
  void Function(LoadDataResult<SupportDiscussion>) onTapProductDiscussionHeader;

  ProductDiscussionContainerListItemControllerState({
    required super.productDiscussionListItemValue,
    required this.onGetSupportDiscussion,
    required this.onGetIsBasedUser,
    required super.onGetErrorProvider,
    required super.onUpdateState,
    required this.productDiscussionContainerInterceptingActionListItemControllerState,
    required this.onReplyProductDiscussionDialog,
    required this.onGetDiscussionProductId,
    required this.onGetSupportDiscussionBasedDiscussionId,
    required super.onGotoReplyProductDiscussionPage,
    required this.onTapProductDiscussionHeader
  });
}

abstract class ProductDiscussionContainerInterceptingActionListItemControllerState extends ListItemControllerState {
  void Function(ProductDiscussionListItemValue)? get onUpdateProductDiscussionListItemValue;
}