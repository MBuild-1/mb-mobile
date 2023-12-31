import '../../domain/entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
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
}