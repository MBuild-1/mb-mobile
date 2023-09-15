import '../../../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../../errorprovider/error_provider.dart';
import '../list_item_controller_state.dart';
import 'product_discussion_list_item_controller_state.dart';

abstract class BaseProductDiscussionContainerListItemControllerState extends ListItemControllerState {
  ProductDiscussionListItemValue productDiscussionListItemValue;
  ErrorProvider Function() onGetErrorProvider;
  void Function() onUpdateState;
  void Function(ProductDiscussionDialog)? onGotoReplyProductDiscussionPage;

  BaseProductDiscussionContainerListItemControllerState({
    required this.productDiscussionListItemValue,
    required this.onGetErrorProvider,
    required this.onUpdateState,
    required this.onGotoReplyProductDiscussionPage
  });
}