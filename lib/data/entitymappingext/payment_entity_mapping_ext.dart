import 'package:masterbagasi/data/entitymappingext/summary_value_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/payment/payment_method.dart';
import '../../domain/entity/payment/payment_method_group.dart';
import '../../domain/entity/payment/paymentinstruction/payment_instruction.dart';
import '../../domain/entity/payment/paymentinstruction/payment_instruction_group.dart';
import '../../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../../domain/entity/payment/paymentinstruction/paymentinstructiontransactionsummary/payment_instruction_transaction_summary.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../../domain/entity/summaryvalue/summary_value.dart';
import '../../misc/constant.dart';
import '../../misc/error/message_error.dart';
import '../../misc/error_helper.dart';
import '../../misc/multi_language_string.dart';
import '../../misc/response_wrapper.dart';

extension PaymentEntityMappingExt on ResponseWrapper {
  List<PaymentInstructionGroup> mapFromResponseToPaymentInstructionGroupList() {
    return response.map<PaymentInstructionGroup>(
      (paymentMethodGroupResponse) => ResponseWrapper(paymentMethodGroupResponse).mapFromResponseToPaymentInstructionGroup()
    ).toList();
  }
}

extension PaymentDetailEntityMappingExt on ResponseWrapper {
  PaymentMethodListResponse mapFromResponseToPaymentMethodListResponse() {
    return PaymentMethodListResponse(
      paymentMethodGroupList: () {
        List<PaymentMethodGroup> paymentMethodGroupList = response.map<PaymentMethodGroup>(
          (paymentMethodGroupResponse) => ResponseWrapper(paymentMethodGroupResponse).mapFromResponseToPaymentMethodGroup()
        ).toList();
        return paymentMethodGroupList.where((paymentMethodGroup) => paymentMethodGroup.active == 1).toList();
      }()
    );
  }

  PaymentMethodGroup mapFromResponseToPaymentMethodGroup() {
    return PaymentMethodGroup(
      id: response["id"],
      name: response["name"],
      clientName: response["client_name"],
      active: response["active"],
      paymentMethodList: () {
        List<PaymentMethod> paymentMethodList = response["settling"].map<PaymentMethod>(
          (paymentMethodResponse) => ResponseWrapper(paymentMethodResponse).mapFromResponseToPaymentMethod()
        ).toList();
        return paymentMethodList.where((paymentMethod) => paymentMethod.paymentActive == 1).toList();
      }()
    );
  }

  PaymentMethod mapFromResponseToPaymentMethod() {
    String settlingId = "";
    String paymentName = "";
    Map<String, dynamic> responseMap = response as Map<String, dynamic>;
    for (String key in responseMap.keys) {
      if (key.contains("_settling")) {
        if (responseMap.containsKey(key)) {
          dynamic value = responseMap[key];
          if (value != null) {
            Map<String, dynamic> valueMap = value as Map<String, dynamic>;
            if (valueMap.containsKey("id")) {
              settlingId = valueMap["id"];
            } else if (valueMap.containsKey("name")) {
              paymentName = valueMap["name"];
            } else if (valueMap.containsKey("store")) {
              paymentName = valueMap["store"];
            }
          }
        }
      }
    }
    return PaymentMethod(
      id: response["id"],
      settlingId: settlingId,
      paymentName: paymentName,
      paymentGroupId: response["payment_group_id"],
      paymentGroup: response["payment_group"],
      paymentType: response["payment_type"],
      paymentActive: response["payment_active"],
      paymentImage: response["payment_image"],
      serviceFee: response["service_fee"],
      taxRate: response["tax_rate"]
    );
  }

  PaymentInstructionTransactionSummary mapFromResponseToPaymentInstructionTransactionSummary() {
    // List<SummaryValue> paymentInstructionTransactionSummaryValue = response != null ? ResponseWrapper(response).mapFromResponseToSummaryValueList() : [];
    // if (paymentInstructionTransactionSummaryValue.isEmpty) {
    //   throw ErrorHelper.generateMultiLanguageDioError(
    //     Constant.multiLanguageMessageErrorPaymentDetail
    //   );
    // }
    return PaymentInstructionTransactionSummary(
      paymentInstructionTransactionSummaryValueList: response != null ? ResponseWrapper(response).mapFromResponseToSummaryValueList() : []
    );
  }

  PaymentInstructionResponse mapFromResponseToPaymentInstructionResponse() {
    return PaymentInstructionResponse(
      paymentInstructionTransactionSummary: ResponseWrapper(response["payment_summary"]).mapFromResponseToPaymentInstructionTransactionSummary(),
      paymentInstructionGroupList: ResponseWrapper(response["payment_guide"]).mapFromResponseToPaymentInstructionGroupList()
    );
  }

  PaymentInstructionGroup mapFromResponseToPaymentInstructionGroup() {
    return PaymentInstructionGroup(
      id: response["id"],
      name: MultiLanguageString(response["name"]),
      active: response["active"],
      paymentInstructionList: response["payment_guide_lists"].map<PaymentInstruction>(
        (paymentInstructionResponse) => ResponseWrapper(paymentInstructionResponse).mapFromResponseToPaymentInstruction()
      ).toList()
    );
  }

  PaymentInstruction mapFromResponseToPaymentInstruction() {
    return PaymentInstruction(
      id: response["id"],
      sequence: ResponseWrapper(response["sequence"]).mapFromResponseToInt()!,
      text: MultiLanguageString(response["text"])
    );
  }
}