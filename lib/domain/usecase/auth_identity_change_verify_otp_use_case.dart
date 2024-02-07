import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/verifyeditprofile/authidentitychangeverifyotp/auth_identity_change_verify_otp_response.dart';
import '../entity/verifyeditprofile/authidentitychangeverifyotp/parameter/auth_identity_change_verify_otp_parameter.dart';
import '../repository/user_repository.dart';

class AuthIdentityChangeVerifyOtpUseCase {
  final UserRepository userRepository;

  AuthIdentityChangeVerifyOtpUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<AuthIdentityChangeVerifyOtpResponse>> execute(AuthIdentityChangeVerifyOtpParameter authIdentityChangeVerifyOtpParameter) {
    return userRepository.authIdentityChangeVerifyOtp(authIdentityChangeVerifyOtpParameter);
  }
}