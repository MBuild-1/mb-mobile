import '../../domain/entity/register/register_first_step_response.dart';
import 'register_step.dart';

class SendRegisterOtpRegisterStep extends RegisterStep {
  RegisterFirstStepResponse registerFirstStepResponse;

  SendRegisterOtpRegisterStep({
    required this.registerFirstStepResponse
  });

  @override
  int get stepNumber => 2;
}