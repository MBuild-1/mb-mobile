import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/payment/paymentinstruction/payment_instruction_parameter.dart';
import '../entity/payment/paymentinstruction/payment_instruction_response.dart';
import '../repository/payment_repository.dart';

class PaymentInstructionUseCase {
  final PaymentRepository paymentRepository;

  const PaymentInstructionUseCase({
    required this.paymentRepository
  });

  FutureProcessing<LoadDataResult<PaymentInstructionResponse>> execute(PaymentInstructionParameter paymentInstructionParameter) {
    return paymentRepository.paymentInstruction(paymentInstructionParameter);
  }
}