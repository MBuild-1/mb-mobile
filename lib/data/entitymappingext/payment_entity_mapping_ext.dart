import '../../domain/entity/payment/payment_method.dart';
import '../../domain/entity/payment/payment_method_group.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../../misc/response_wrapper.dart';

extension PaymentEntityMappingExt on ResponseWrapper {

}

extension PaymentDetailEntityMappingExt on ResponseWrapper {
  PaymentMethodListResponse mapFromResponseToPaymentMethodListResponse() {
    return PaymentMethodListResponse(
      paymentMethodGroupList: response.map<PaymentMethodGroup>(
        (paymentMethodGroupResponse) => ResponseWrapper(paymentMethodGroupResponse).mapFromResponseToPaymentMethodGroup()
      ).toList()
    );
  }

  PaymentMethodGroup mapFromResponseToPaymentMethodGroup() {
    return PaymentMethodGroup(
      id: response["id"],
      name: response["name"],
      clientName: response["client_name"],
      active: response["active"],
      paymentMethodList: response["settling"].map<PaymentMethod>(
        (paymentMethodResponse) => ResponseWrapper(paymentMethodResponse).mapFromResponseToPaymentMethod()
      ).toList()
    );
  }

  PaymentMethod mapFromResponseToPaymentMethod() {
    return PaymentMethod(
      id: response["id"],
      paymentGroupId: response["payment_group_id"],
      paymentGroup: response["payment_group"],
      paymentType: response["payment_type"],
      paymentActive: response["payment_active"],
      paymentImage: response["payment_image"],
      serviceFee: response["service_fee"],
      taxRate: response["tax_rate"]
    );
  }
}