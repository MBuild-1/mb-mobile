import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/login/third_party_login_visibility.dart';
import '../entity/login/third_party_login_visibility_parameter.dart';
import '../entity/versioning/versioningbasedfilter/versioning_based_filter_parameter.dart';
import '../repository/versioning_repository.dart';

class ThirdPartyLoginVisibilityUseCase {
  final VersioningRepository versioningRepository;

  const ThirdPartyLoginVisibilityUseCase({
    required this.versioningRepository
  });

  FutureProcessing<LoadDataResult<ThirdPartyLoginVisibility>> execute(ThirdPartyLoginVisibilityParameter thirdPartyLoginVisibilityParameter) {
    return versioningRepository.versioningBasedFilter(
      VersioningBasedFilterParameter(
        version: thirdPartyLoginVisibilityParameter.version,
        buildNumber: thirdPartyLoginVisibilityParameter.buildNumber,
        deviceName: thirdPartyLoginVisibilityParameter.deviceName
      )
    ).map<LoadDataResult<ThirdPartyLoginVisibility>>(
      onMap: (valueLoadDataResult) {
        LoadDataResult<ThirdPartyLoginVisibility> thirdPartyLoginVisibilityLoadDataResult = valueLoadDataResult.map<ThirdPartyLoginVisibility>(
          (value) => ThirdPartyLoginVisibility(
            isGoogleLoginVisible: value.versioning.googleLogin == 1,
            isAppleLoginVisible: value.versioning.appleLogin == 1
          )
        );
        if (thirdPartyLoginVisibilityLoadDataResult.isFailed) {
          thirdPartyLoginVisibilityLoadDataResult = SuccessLoadDataResult<ThirdPartyLoginVisibility>(
            value: ThirdPartyLoginVisibility(
              isGoogleLoginVisible: false,
              isAppleLoginVisible: false
            )
          );
        }
        return thirdPartyLoginVisibilityLoadDataResult;
      }
    );
  }
}