import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/versioning/canbeupdatedversioning/can_be_updated_versioning_parameter.dart';
import '../entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';

abstract class VersioningRepository {
  FutureProcessing<LoadDataResult<CanBeUpdatedVersioningResponse>> canBeUpdatedVersioning(CanBeUpdatedVersioningParameter canBeUpdatedVersioningParameter);
}