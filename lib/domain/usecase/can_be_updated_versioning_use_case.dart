import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/versioning/canbeupdatedversioning/can_be_updated_versioning_parameter.dart';
import '../entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';
import '../repository/versioning_repository.dart';

class CanBeUpdatedVersioningUseCase {
  final VersioningRepository versioningRepository;

  const CanBeUpdatedVersioningUseCase({
    required this.versioningRepository
  });

  FutureProcessing<LoadDataResult<CanBeUpdatedVersioningResponse>> execute(CanBeUpdatedVersioningParameter canBeUpdatedVersioningParameter) {
    return versioningRepository.canBeUpdatedVersioning(canBeUpdatedVersioningParameter);
  }
}