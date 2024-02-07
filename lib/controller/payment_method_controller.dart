import '../domain/entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../domain/usecase/payment_method_list_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class PaymentMethodController extends BaseGetxController {
  final PaymentMethodListUseCase paymentMethodListUseCase;

  PaymentMethodController(
    super.controllerManager,
    this.paymentMethodListUseCase
  );

  Future<LoadDataResult<PaymentMethodListResponse>> getPaymentMethodList(PaymentMethodListParameter paymentMethodListParameter) {
    return paymentMethodListUseCase.execute(paymentMethodListParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("payment-method-list").value
    );
  }
}