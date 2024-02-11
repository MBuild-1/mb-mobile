import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/register/register_with_apple_parameter.dart';
import '../entity/register/register_with_apple_response.dart';
import '../repository/user_repository.dart';

class RegisterWithAppleUseCase {
  final UserRepository userRepository;

  const RegisterWithAppleUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<RegisterWithAppleResponse>> execute(RegisterWithAppleParameter registerWithAppleParameter) {
    return userRepository.registerWithApple(registerWithAppleParameter);
  }
}