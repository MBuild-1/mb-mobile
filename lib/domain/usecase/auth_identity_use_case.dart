import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../entity/verifyeditprofile/authidentity/parameter/auth_identity_parameter.dart';
import '../repository/user_repository.dart';

class AuthIdentityUseCase {
  final UserRepository userRepository;

  AuthIdentityUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<AuthIdentityResponse>> execute(AuthIdentityParameter authIdentityParameter) {
    return userRepository.authIdentity(authIdentityParameter);
  }
}