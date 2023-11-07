import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../repository/user_repository.dart';

class SendRegisterOtpUseCase {
  final UserRepository userRepository;

  const SendRegisterOtpUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<SendRegisterOtpResponse>> execute(SendRegisterOtpParameter sendRegisterOtpParameter) {
    return userRepository.sendRegisterOtp(sendRegisterOtpParameter);
  }
}