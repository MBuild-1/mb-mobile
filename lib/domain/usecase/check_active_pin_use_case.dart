import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/pin/checkactivepin/check_active_pin_parameter.dart';
import '../entity/pin/checkactivepin/check_active_pin_response.dart';
import '../repository/user_repository.dart';

class CheckActivePinUseCase {
  final UserRepository userRepository;

  const CheckActivePinUseCase({
    required this.userRepository
  });

  FutureProcessing<LoadDataResult<CheckActivePinResponse>> execute(CheckActivePinParameter checkActivePinParameter) {
    return userRepository.checkActivePin(checkActivePinParameter);
  }
}