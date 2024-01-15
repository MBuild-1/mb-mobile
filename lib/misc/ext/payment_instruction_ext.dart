import 'dart:convert';

import 'package:masterbagasi/data/entitymappingext/payment_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'package:masterbagasi/misc/ext/summary_value_ext.dart';

import '../../domain/entity/payment/paymentinstruction/payment_instruction.dart';
import '../../domain/entity/payment/paymentinstruction/payment_instruction_group.dart';
import '../../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../controllerstate/listitemcontrollerstate/paymentinstructionlistitemcontrollerstate/payment_instruction_container_list_item_controller_state.dart';
import '../response_wrapper.dart';

extension PaymentInstructionResponseStringExt on String? {
  PaymentInstructionResponse toPaymentInstructionResponseFromJsonString() {
    return ResponseWrapper(json.decode(toEmptyStringNonNull)).mapFromResponseToPaymentInstructionResponse();
  }
}

extension PaymentInstructionResponseExt on PaymentInstructionResponse {
  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      "payment_summary": paymentInstructionTransactionSummary.paymentInstructionTransactionSummaryValueList.map<Map<String, dynamic>>(
        (summaryValue) => summaryValue.toJsonMap()
      ).toList(),
      "payment_guide": paymentInstructionGroupList.map<Map<String, dynamic>>(
        (paymentInstructionGroup) => paymentInstructionGroup.toJsonMap()
      ).toList()
    };
  }

  String toJsonMapString() {
    return json.encode(toJsonMap());
  }

  PaymentInstructionResponseStateValue toPaymentInstructionResponseStateValue() {
    return PaymentInstructionResponseStateValue(
      paymentInstructionTransactionSummary: paymentInstructionTransactionSummary,
      paymentInstructionGroupStateValueList: paymentInstructionGroupList.map<PaymentInstructionGroupStateValue>(
        (paymentInstructionGroup) => paymentInstructionGroup.toPaymentInstructionGroupStateValue()
      ).toList()
    );
  }
}

extension PaymentInstructionGroupExt on PaymentInstructionGroup {
  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      "id": id,
      "name": name.value,
      "active": active,
      "payment_guide_lists": paymentInstructionList.map<Map<String, dynamic>>(
        (paymentInstruction) => paymentInstruction.toJsonMap()
      ).toList()
    };
  }

  PaymentInstructionGroupStateValue toPaymentInstructionGroupStateValue() {
    return PaymentInstructionGroupStateValue(
      paymentInstructionGroup: this,
      isExpanded: true
    );
  }
}

extension PaymentInstructionExt on PaymentInstruction {
  Map<String, dynamic> toJsonMap() {
    return <String, dynamic>{
      "id": id,
      "text": text.value,
      "sequence": sequence
    };
  }
}