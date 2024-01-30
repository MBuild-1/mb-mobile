import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/resetpassword/reset_password_parameter.dart';
import '../entity/resetpassword/reset_password_response.dart';
import '../repository/user_repository.dart';

class ResetPasswordUseCase {
  final UserRepository userRepository;

  const ResetPasswordUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<ResetPasswordResponse>> execute(ResetPasswordParameter resetPasswordParameter) {
    return userRepository.resetPassword(resetPasswordParameter);
  }
}