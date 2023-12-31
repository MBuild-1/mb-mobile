import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../repository/payment_repository.dart';

class PaymentMethodListUseCase {
  final PaymentRepository paymentRepository;

  const PaymentMethodListUseCase({
    required this.paymentRepository
  });

  FutureProcessing<LoadDataResult<PaymentMethodListResponse>> execute(PaymentMethodListParameter paymentMethodListParameter) {
    return paymentRepository.paymentMethodList(paymentMethodListParameter);
  }
}