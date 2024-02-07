import '../support_vertical_grid_list_item_controller_state.dart';
import 'payment_method_list_item_controller_state.dart';

class VerticalGridPaymentMethodListItemControllerState extends PaymentMethodListItemControllerState with SupportVerticalGridListItemControllerStateMixin {
  VerticalGridPaymentMethodListItemControllerState({
    required super.paymentMethod,
    super.onSelectPaymentMethod,
    required super.isSelected
  });
}