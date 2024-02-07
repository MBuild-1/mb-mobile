import '../../../../misc/multi_language_string.dart';
import 'payment_instruction.dart';

class PaymentInstructionGroup {
  String id;
  MultiLanguageString name;
  int active;
  List<PaymentInstruction> paymentInstructionList;

  PaymentInstructionGroup({
    required this.id,
    required this.name,
    required this.active,
    required this.paymentInstructionList
  });
}