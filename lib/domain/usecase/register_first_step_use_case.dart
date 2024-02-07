import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/register/register_first_step_parameter.dart';
import '../entity/register/register_first_step_response.dart';
import '../repository/user_repository.dart';

class RegisterFirstStepUseCase {
  final UserRepository userRepository;

  const RegisterFirstStepUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<RegisterFirstStepResponse>> execute(RegisterFirstStepParameter registerFirstStepParameter) {
    return userRepository.registerFirstStep(registerFirstStepParameter);
  }
}