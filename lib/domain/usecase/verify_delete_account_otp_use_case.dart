import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_parameter.dart';
import '../entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_response.dart';
import '../repository/user_repository.dart';

class VerifyDeleteAccountOtpUseCase {
  final UserRepository userRepository;

  const VerifyDeleteAccountOtpUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<VerifyDeleteAccountOtpResponse>> execute(VerifyDeleteAccountOtpParameter verifyDeleteAccountOtpParameter) {
    return userRepository.verifyDeleteAccountOtp(verifyDeleteAccountOtpParameter);
  }
}