import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/verifyeditprofile/authidentitychangeinput/auth_identity_change_input_response.dart';
import '../entity/verifyeditprofile/authidentitychangeinput/parameter/auth_identity_change_input_parameter.dart';
import '../repository/user_repository.dart';

class AuthIdentityChangeInputUseCase {
  final UserRepository userRepository;

  AuthIdentityChangeInputUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<AuthIdentityChangeInputResponse>> execute(AuthIdentityChangeInputParameter authIdentityChangeInputParameter) {
    return userRepository.authIdentityChangeInput(authIdentityChangeInputParameter);
  }
}