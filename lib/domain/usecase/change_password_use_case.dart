import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/changepassword/change_password_parameter.dart';
import '../entity/changepassword/change_password_response.dart';
import '../repository/user_repository.dart';

class ChangePasswordUseCase {
  final UserRepository userRepository;

  const ChangePasswordUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<ChangePasswordResponse>> execute(ChangePasswordParameter changePasswordParameter) {
    return userRepository.changePassword(changePasswordParameter);
  }
}