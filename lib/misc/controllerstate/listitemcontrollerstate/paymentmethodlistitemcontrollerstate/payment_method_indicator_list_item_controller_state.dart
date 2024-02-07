import '../../../../domain/entity/payment/payment_method.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

class PaymentMethodIndicatorListItemControllerState extends ListItemControllerState {
  LoadDataResult<PaymentMethod> Function() selectedPaymentMethodLoadDataResult;
  void Function() onSelectPaymentMethod;
  void Function() onRemovePaymentMethod;
  ErrorProvider Function() errorProvider;

  PaymentMethodIndicatorListItemControllerState({
    required this.selectedPaymentMethodLoadDataResult,
    required this.onSelectPaymentMethod,
    required this.onRemovePaymentMethod,
    required this.errorProvider
  });
}