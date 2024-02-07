import '../../../../domain/entity/chat/product/get_product_message_by_user_response.dart';
import '../list_item_controller_state.dart';

class ProductChatHistoryListItemControllerState extends ListItemControllerState {
  GetProductMessageByUserResponseMember getProductMessageByUserResponseMember;
  void Function(GetProductMessageByUserResponseMember)? onTap;

  ProductChatHistoryListItemControllerState({
    required this.getProductMessageByUserResponseMember,
    this.onTap
  });
}