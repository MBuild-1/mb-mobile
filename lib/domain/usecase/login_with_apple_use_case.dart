import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/login/login_with_apple_parameter.dart';
import '../entity/login/login_with_apple_response.dart';
import '../repository/user_repository.dart';

class LoginWithAppleUseCase {
  final UserRepository userRepository;

  const LoginWithAppleUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<LoginWithAppleResponse>> execute(LoginWithAppleParameter loginWithAppleParameter) {
    return userRepository.loginWithApple(loginWithAppleParameter);
  }
}