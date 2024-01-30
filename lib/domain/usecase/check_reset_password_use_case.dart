import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/resetpassword/check/check_reset_password_parameter.dart';
import '../entity/resetpassword/check/check_reset_password_response.dart';
import '../repository/user_repository.dart';

class CheckResetPasswordUseCase {
  final UserRepository userRepository;

  const CheckResetPasswordUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<CheckResetPasswordResponse>> execute(CheckResetPasswordParameter checkResetPasswordParameter) {
    return userRepository.checkResetPassword(checkResetPasswordParameter);
  }
}