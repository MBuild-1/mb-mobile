import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/payment_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/payment/paymentinstruction/payment_instruction_parameter.dart';
import '../../../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../../../domain/entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../../../domain/entity/payment/shippingpayment/shipping_payment_parameter.dart';
import '../../../domain/entity/payment/shippingpayment/shipping_payment_response.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import 'payment_data_source.dart';

class DefaultPaymentDataSource implements PaymentDataSource {
  final Dio dio;

  const DefaultPaymentDataSource({
    required this.dio
  });

  @override
  FutureProcessing<PaymentMethodListResponse> paymentMethodList(PaymentMethodListParameter paymentMethodListParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/settling/payment-group", cancelToken: cancelToken)
        .map<PaymentMethodListResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToPaymentMethodListResponse());
    });
  }

  @override
  FutureProcessing<PaymentInstructionResponse> paymentInstruction(PaymentInstructionParameter paymentInstructionParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/settling/payment-guide/${paymentInstructionParameter.settlingId}", cancelToken: cancelToken)
        .map<PaymentInstructionResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToPaymentInstructionResponse());
    });
  }

  @override
  FutureProcessing<ShippingPaymentResponse> shippingPayment(ShippingPaymentParameter shippingPaymentParameter) {
    return DioHttpClientProcessing((cancelToken) {
      dynamic data = {
        "settling_id": shippingPaymentParameter.settlingId,
        "combined_order_id": shippingPaymentParameter.combinedOrderId,
        "expire": shippingPaymentParameter.expire
      };
      return dio.post("/user/order/trigger/shipping-payment", data: data, cancelToken: cancelToken)
        .map<ShippingPaymentResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToShippingPaymentResponse());
    });
  }
}