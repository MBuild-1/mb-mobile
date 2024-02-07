import 'package:masterbagasi/domain/entity/payment/paymentinstruction/payment_instruction_response.dart';

import '../../../../domain/entity/payment/paymentinstruction/payment_instruction_group.dart';
import '../../../../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../list_item_controller_state.dart';

class PaymentInstructionContainerListItemControllerState extends ListItemControllerState {
  PaymentInstructionResponseStateValue Function() paymentInstructionResponseStateValue;
  PaymentInstructionContainerStorageListItemControllerState paymentInstructionContainerStorageListItemControllerState;
  void Function() onUpdateState;

  PaymentInstructionContainerListItemControllerState({
    required this.paymentInstructionResponseStateValue,
    required this.paymentInstructionContainerStorageListItemControllerState,
    required this.onUpdateState,
  });
}

abstract class PaymentInstructionContainerStorageListItemControllerState {}

class PaymentInstructionResponseStateValue {
  PaymentInstructionTransactionSummary paymentInstructionTransactionSummary;
  List<PaymentInstructionGroupStateValue> paymentInstructionGroupStateValueList;

  PaymentInstructionResponseStateValue({
    required this.paymentInstructionTransactionSummary,
    required this.paymentInstructionGroupStateValueList
  });
}

class PaymentInstructionGroupStateValue {
  PaymentInstructionGroup paymentInstructionGroup;
  bool isExpanded;

  PaymentInstructionGroupStateValue({
    required this.paymentInstructionGroup,
    required this.isExpanded
  });
}