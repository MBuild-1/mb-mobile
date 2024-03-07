import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/versioning/canbeupdatedversioning/all_versioning_response.dart';
import '../../domain/entity/versioning/versioning.dart';
import '../../domain/entity/versioning/versioningbasedfilter/versioning_based_filter_response.dart';
import '../../misc/response_wrapper.dart';

extension VersioningEntityMappingExt on ResponseWrapper {
  List<Versioning> mapFromResponseToVersioningList() {
    return response.map<Versioning>(
      (versioningResponse) => ResponseWrapper(versioningResponse).mapFromResponseToVersioning()
    ).toList();
  }
}

extension VersioningDetailEntityMappingExt on ResponseWrapper {
  AllVersioningResponse mapFromResponseToAllVersioningResponse() {
    return AllVersioningResponse(
      versioningList: ResponseWrapper(response).mapFromResponseToVersioningList()
    );
  }

  VersioningBasedFilterResponse mapFromResponseToVersioningBasedFilterResponse() {
    return VersioningBasedFilterResponse(
      versioning: ResponseWrapper(response).mapFromResponseToVersioning()
    );
  }

  Versioning mapFromResponseToVersioning() {
    return Versioning(
      id: response["id"],
      version: response["version"],
      buildNumber: response["build_number"],
      appleLogin: ResponseWrapper(response["apple_signin"]).mapFromResponseToInt() ?? 1,
      googleLogin: ResponseWrapper(response["google_signin"]).mapFromResponseToInt() ?? 1,
      mustBeUpdatedToNewerVersion: ResponseWrapper(response["must_be_updated_to_newer_version"]).mapFromResponseToInt() ?? 0,
      isLatest: ResponseWrapper(response["is_latest"]).mapFromResponseToInt() ?? 0,
    );
  }
}