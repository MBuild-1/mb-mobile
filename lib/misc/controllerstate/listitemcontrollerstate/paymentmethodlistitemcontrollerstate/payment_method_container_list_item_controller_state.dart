import '../../../../domain/entity/payment/payment_method.dart';
import '../../../../domain/entity/payment/payment_method_group.dart';
import '../list_item_controller_state.dart';

class PaymentMethodContainerListItemControllerState extends ListItemControllerState {
  List<PaymentMethodGroup> paymentMethodGroupList;
  String? Function() onGetSelectedPaymentMethodId;
  void Function(PaymentMethod) onSelectPaymentMethod;
  void Function() onUpdateState;

  PaymentMethodContainerListItemControllerState({
    required this.paymentMethodGroupList,
    required this.onGetSelectedPaymentMethodId,
    required this.onSelectPaymentMethod,
    required this.onUpdateState,
  });
}