import '../../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_parameter.dart';
import '../../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class VersioningDataSource {
  FutureProcessing<CanBeUpdatedVersioningResponse> canBeUpdatedVersioning(CanBeUpdatedVersioningParameter canBeUpdatedVersioningParameter);
}