import '../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_parameter.dart';
import '../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';
import '../../domain/repository/versioning_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/versioningdatasource/versioning_data_source.dart';

class DefaultVersioningRepository implements VersioningRepository {
  final VersioningDataSource versioningDataSource;

  const DefaultVersioningRepository({
    required this.versioningDataSource
  });

  @override
  FutureProcessing<LoadDataResult<CanBeUpdatedVersioningResponse>> canBeUpdatedVersioning(CanBeUpdatedVersioningParameter canBeUpdatedVersioningParameter) {
    return versioningDataSource.canBeUpdatedVersioning(canBeUpdatedVersioningParameter).mapToLoadDataResult<CanBeUpdatedVersioningResponse>();
  }
}