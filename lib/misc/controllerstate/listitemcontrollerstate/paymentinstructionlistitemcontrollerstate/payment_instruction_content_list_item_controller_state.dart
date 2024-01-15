import '../../../../domain/entity/payment/paymentinstruction/payment_instruction.dart';
import '../list_item_controller_state.dart';

class PaymentInstructionContentListItemControllerState extends ListItemControllerState {
  int number;
  PaymentInstruction paymentInstruction;

  PaymentInstructionContentListItemControllerState({
    required this.number,
    required this.paymentInstruction
  });
}