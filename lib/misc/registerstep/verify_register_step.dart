import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import 'register_step.dart';

class VerifyRegisterStep extends RegisterStep {
  SendRegisterOtpParameter sendRegisterOtpParameter;
  SendRegisterOtpResponse sendRegisterOtpResponse;

  VerifyRegisterStep({
    required this.sendRegisterOtpParameter,
    required this.sendRegisterOtpResponse
  });

  @override
  int get stepNumber => 3;
}