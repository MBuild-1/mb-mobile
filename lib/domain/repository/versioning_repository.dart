import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/versioning/canbeupdatedversioning/all_versioning_parameter.dart';
import '../entity/versioning/canbeupdatedversioning/all_versioning_response.dart';
import '../entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';

abstract class VersioningRepository {
  FutureProcessing<LoadDataResult<AllVersioningResponse>> allVersioning(AllVersioningParameter canBeUpdatedVersioningParameter);
  FutureProcessing<LoadDataResult<VersioningBasedFilterResponse>> versioningBasedFilter(VersioningBasedFilterParameter versioningBasedFilterParameter);
}