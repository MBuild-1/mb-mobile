import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/user/edituser/edit_user_parameter.dart';
import '../entity/user/edituser/edit_user_response.dart';
import '../repository/user_repository.dart';

class EditUserUseCase {
  final UserRepository userRepository;

  const EditUserUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<EditUserResponse>> execute(EditUserParameter editUserParameter) {
    return userRepository.editUser(editUserParameter);
  }
}