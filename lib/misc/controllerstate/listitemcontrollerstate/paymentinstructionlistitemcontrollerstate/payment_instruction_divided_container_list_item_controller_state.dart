import '../../../../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';
import 'payment_instruction_container_list_item_controller_state.dart';

class PaymentInstructionDividedContainerListItemControllerState extends ListItemControllerState {
  LoadDataResult<PaymentInstructionTransactionSummary> Function() paymentInstructionTransactionSummaryLoadDataResult;
  PaymentInstructionContainerStorageListItemControllerState paymentInstructionContainerStorageListItemControllerState;
  ErrorProvider Function() onGetErrorProvider;
  void Function() onUpdateState;

  PaymentInstructionDividedContainerListItemControllerState({
    required this.paymentInstructionTransactionSummaryLoadDataResult,
    required this.paymentInstructionContainerStorageListItemControllerState,
    required this.onGetErrorProvider,
    required this.onUpdateState,
  });
}