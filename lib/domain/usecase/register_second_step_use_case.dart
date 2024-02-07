import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/register/register_second_step_parameter.dart';
import '../entity/register/register_second_step_response.dart';
import '../repository/user_repository.dart';

class RegisterSecondStepUseCase {
  final UserRepository userRepository;

  const RegisterSecondStepUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<RegisterSecondStepResponse>> execute(RegisterSecondStepParameter registerSecondStepParameter) {
    return userRepository.registerSecondStep(registerSecondStepParameter);
  }
}