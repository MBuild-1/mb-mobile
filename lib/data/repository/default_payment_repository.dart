import '../../domain/entity/payment/paymentinstruction/payment_instruction_parameter.dart';
import '../../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../../domain/entity/payment/shippingpayment/shipping_payment_parameter.dart';
import '../../domain/entity/payment/shippingpayment/shipping_payment_response.dart';
import '../../domain/repository/payment_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/paymentdatasource/payment_data_source.dart';

class DefaultPaymentRepository implements PaymentRepository {
  final PaymentDataSource paymentDataSource;

  const DefaultPaymentRepository({
    required this.paymentDataSource
  });

  @override
  FutureProcessing<LoadDataResult<PaymentMethodListResponse>> paymentMethodList(PaymentMethodListParameter paymentMethodListParameter) {
    return paymentDataSource.paymentMethodList(paymentMethodListParameter).mapToLoadDataResult<PaymentMethodListResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<PaymentInstructionResponse>> paymentInstruction(PaymentInstructionParameter paymentInstructionParameter) {
    return paymentDataSource.paymentInstruction(paymentInstructionParameter).mapToLoadDataResult<PaymentInstructionResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ShippingPaymentResponse>> shippingPayment(ShippingPaymentParameter shippingPaymentParameter) {
    return paymentDataSource.shippingPayment(shippingPaymentParameter).mapToLoadDataResult<ShippingPaymentResponse>();
  }
}