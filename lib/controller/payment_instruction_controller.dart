import '../domain/entity/payment/paymentinstruction/payment_instruction_parameter.dart';
import '../domain/entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../domain/usecase/payment_instruction_use_case.dart';
import '../misc/load_data_result.dart';
import 'base_getx_controller.dart';

class PaymentInstructionController extends BaseGetxController {
  final PaymentInstructionUseCase paymentInstructionUseCase;

  PaymentInstructionController(
    super.controllerManager,
    this.paymentInstructionUseCase
  );

  Future<LoadDataResult<PaymentInstructionResponse>> getPaymentInstruction(PaymentInstructionParameter paymentInstructionParameter) {
    return paymentInstructionUseCase.execute(paymentInstructionParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("payment-instruction").value
    );
  }
}