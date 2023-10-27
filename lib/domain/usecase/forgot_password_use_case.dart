import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/forgotpassword/forgot_password_parameter.dart';
import '../entity/forgotpassword/forgot_password_response.dart';
import '../repository/user_repository.dart';

class ForgotPasswordUseCase {
  final UserRepository userRepository;

  const ForgotPasswordUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<ForgotPasswordResponse>> execute(ForgotPasswordParameter forgotPasswordParameter) {
    return userRepository.forgotPassword(forgotPasswordParameter);
  }
}