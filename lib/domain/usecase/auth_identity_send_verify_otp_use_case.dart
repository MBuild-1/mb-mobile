import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_parameter.dart';
import '../entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_response.dart';
import '../repository/user_repository.dart';

class AuthIdentitySendVerifyOtpUseCase {
  final UserRepository userRepository;

  AuthIdentitySendVerifyOtpUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<AuthIdentitySendVerifyOtpResponse>> execute(AuthIdentitySendVerifyOtpParameter authIdentitySendVerifyOtpParameter) {
    return userRepository.authIdentitySendVerifyOtp(authIdentitySendVerifyOtpParameter);
  }
}