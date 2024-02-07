import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/register/verify_register_parameter.dart';
import '../entity/register/verify_register_response.dart';
import '../repository/user_repository.dart';

class VerifyRegisterUseCase {
  final UserRepository userRepository;

  const VerifyRegisterUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<VerifyRegisterResponse>> execute(VerifyRegisterParameter verifyRegisterParameter) {
    return userRepository.verifyRegister(verifyRegisterParameter);
  }
}