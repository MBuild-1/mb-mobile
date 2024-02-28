import '../../domain/entity/versioning/canbeupdatedversioning/can_be_updated_versioning_response.dart';
import '../../domain/entity/versioning/versioning.dart';
import '../../misc/response_wrapper.dart';

extension VersioningEntityMappingExt on ResponseWrapper {
  List<Versioning> mapFromResponseToVersioningList() {
    return response.map<Versioning>(
      (versioningResponse) => ResponseWrapper(versioningResponse).mapFromResponseToVersioning()
    ).toList();
  }
}

extension VersioningDetailEntityMappingExt on ResponseWrapper {
  CanBeUpdatedVersioningResponse mapFromResponseToCanBeUpdatedVersioningResponse() {
    return CanBeUpdatedVersioningResponse(
      versioningList: ResponseWrapper(response).mapFromResponseToVersioningList()
    );
  }

  Versioning mapFromResponseToVersioning() {
    return Versioning(
      id: response["id"],
      version: response["version"],
      buildNumber: response["build_number"]
    );
  }
}