import '../../domain/entity/versioning/canbeupdatedversioning/all_versioning_parameter.dart';
import '../../domain/entity/versioning/canbeupdatedversioning/all_versioning_response.dart';
import '../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';
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
  FutureProcessing<LoadDataResult<AllVersioningResponse>> allVersioning(AllVersioningParameter canBeUpdatedVersioningParameter) {
    return versioningDataSource.allVersioning(canBeUpdatedVersioningParameter).mapToLoadDataResult<AllVersioningResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<VersioningBasedFilterResponse>> versioningBasedFilter(VersioningBasedFilterParameter versioningBasedFilterParameter) {
    return versioningDataSource.versioningBasedFilter(versioningBasedFilterParameter).mapToLoadDataResult<VersioningBasedFilterResponse>();
  }
}