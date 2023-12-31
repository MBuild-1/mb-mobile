import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../entity/payment/paymentmethodlist/payment_method_list_response.dart';

abstract class PaymentRepository {
  FutureProcessing<LoadDataResult<PaymentMethodListResponse>> paymentMethodList(PaymentMethodListParameter paymentMethodListParameter);
}