import '../../../domain/entity/payment/paymentinstruction/payment_instruction_parameter.dart';
import '../../../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../../../domain/entity/payment/paymentmethodlist/payment_method_list_parameter.dart';
import '../../../domain/entity/payment/paymentmethodlist/payment_method_list_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class PaymentDataSource {
  FutureProcessing<PaymentMethodListResponse> paymentMethodList(PaymentMethodListParameter paymentMethodListParameter);
  FutureProcessing<PaymentInstructionResponse> paymentInstruction(PaymentInstructionParameter paymentInstructionParameter);
}