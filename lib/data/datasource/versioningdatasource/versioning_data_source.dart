import '../../../domain/entity/versioning/canbeupdatedversioning/all_versioning_parameter.dart';
import '../../../domain/entity/versioning/canbeupdatedversioning/all_versioning_response.dart';
import '../../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class VersioningDataSource {
  FutureProcessing<AllVersioningResponse> allVersioning(AllVersioningParameter canBeUpdatedVersioningParameter);
  FutureProcessing<VersioningBasedFilterResponse> versioningBasedFilter(VersioningBasedFilterParameter versioningBasedFilterParameter);
}