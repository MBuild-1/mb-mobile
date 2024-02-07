import '../../../../domain/entity/payment/payment_method.dart';
import '../list_item_controller_state.dart';

abstract class PaymentMethodListItemControllerState extends ListItemControllerState {
  PaymentMethod paymentMethod;
  void Function(PaymentMethod)? onSelectPaymentMethod;
  bool isSelected;

  PaymentMethodListItemControllerState({
    required this.paymentMethod,
    this.onSelectPaymentMethod,
    required this.isSelected
  });
}