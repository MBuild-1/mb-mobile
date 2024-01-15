import '../../../../misc/multi_language_string.dart';

class PaymentInstruction {
  String id;
  int sequence;
  MultiLanguageString text;

  PaymentInstruction({
    required this.id,
    required this.sequence,
    required this.text
  });
}