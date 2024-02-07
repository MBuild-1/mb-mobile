import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../../domain/entity/payment/paymentinstruction/payment_instruction.dart';

class PaymentInstructionContentItem extends StatelessWidget {
  final int number;
  final PaymentInstruction paymentInstruction;

  const PaymentInstructionContentItem({
    super.key,
    required this.number,
    required this.paymentInstruction
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          child: Text("${number.toString()}."),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: HtmlWidget(paymentInstruction.text.toEmptyStringNonNull)
        )
      ],
    );
  }
}