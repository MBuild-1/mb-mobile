import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/loginorregister/login_or_register_with_apple_via_callback_parameter.dart';
import '../entity/loginorregister/login_or_register_with_apple_via_callback_response.dart';
import '../repository/user_repository.dart';

class LoginOrRegisterWithAppleViaCallbackUseCase {
  final UserRepository userRepository;

  const LoginOrRegisterWithAppleViaCallbackUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<LoginOrRegisterWithAppleViaCallbackResponse>> execute(LoginOrRegisterWithAppleViaCallbackParameter loginOrRegisterWithAppleViaCallbackParameter) {
    return userRepository.loginOrRegisterWithAppleViaCallback(loginOrRegisterWithAppleViaCallbackParameter);
  }
}