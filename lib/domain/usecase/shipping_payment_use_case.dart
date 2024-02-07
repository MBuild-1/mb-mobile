import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/payment/shippingpayment/shipping_payment_parameter.dart';
import '../entity/payment/shippingpayment/shipping_payment_response.dart';
import '../repository/payment_repository.dart';

class ShippingPaymentUseCase {
  final PaymentRepository paymentRepository;

  const ShippingPaymentUseCase({
    required this.paymentRepository
  });

  FutureProcessing<LoadDataResult<ShippingPaymentResponse>> execute(ShippingPaymentParameter shippingPaymentParameter) {
    return paymentRepository.shippingPayment(shippingPaymentParameter);
  }
}