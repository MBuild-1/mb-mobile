import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/forgotpassword/whatsapp/whatsapp_forgot_password_parameter.dart';
import '../entity/forgotpassword/whatsapp/whatsapp_forgot_password_response.dart';
import '../repository/user_repository.dart';

class WhatsappForgotPasswordUseCase {
  final UserRepository userRepository;

  const WhatsappForgotPasswordUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<WhatsappForgotPasswordResponse>> execute(WhatsappForgotPasswordParameter whatsappForgotPasswordParameter) {
    return userRepository.whatsappForgotPassword(whatsappForgotPasswordParameter);
  }
}