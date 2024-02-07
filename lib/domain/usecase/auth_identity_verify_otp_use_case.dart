import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/verifyeditprofile/authidentityverifyotp/auth_identity_verify_otp_response.dart';
import '../entity/verifyeditprofile/authidentityverifyotp/parameter/auth_identity_verify_otp_parameter.dart';
import '../repository/user_repository.dart';

class AuthIdentityVerifyOtpUseCase {
  final UserRepository userRepository;

  AuthIdentityVerifyOtpUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<AuthIdentityVerifyOtpResponse>> execute(AuthIdentityVerifyOtpParameter authIdentityVerifyOtpParameter) {
    return userRepository.authIdentityVerifyOtp(authIdentityVerifyOtpParameter);
  }
}