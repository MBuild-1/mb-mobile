import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../entity/pin/modifypin/modify_pin_response.dart';
import '../repository/user_repository.dart';

class ModifyPinUseCase {
  final UserRepository userRepository;

  const ModifyPinUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<ModifyPinResponse>> execute(ModifyPinParameter modifyPinParameter) {
    return userRepository.modifyPin(modifyPinParameter);
  }
}