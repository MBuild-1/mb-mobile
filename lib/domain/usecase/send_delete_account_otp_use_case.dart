import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_parameter.dart';
import '../entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_response.dart';
import '../repository/user_repository.dart';

class SendDeleteAccountOtpUseCase {
  final UserRepository userRepository;

  const SendDeleteAccountOtpUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<SendDeleteAccountOtpResponse>> execute(SendDeleteAccountOtpParameter verifyDeleteAccountOtpParameter) {
    return userRepository.sendDeleteAccountOtp(verifyDeleteAccountOtpParameter);
  }
}