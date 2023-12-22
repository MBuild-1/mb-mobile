import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/verifyeditprofile/authidentitychange/auth_identity_change_parameter.dart';
import '../entity/verifyeditprofile/authidentitychange/auth_identity_change_response.dart';
import '../repository/user_repository.dart';

class AuthIdentityChangeUseCase {
  final UserRepository userRepository;

  AuthIdentityChangeUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<AuthIdentityChangeResponse>> execute(AuthIdentityChangeParameter authIdentityChangeParameter) {
    return userRepository.authIdentityChange(authIdentityChangeParameter);
  }
}