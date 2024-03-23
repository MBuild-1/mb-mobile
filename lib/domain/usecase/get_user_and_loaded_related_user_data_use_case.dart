import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/delivery/country_based_id_parameter.dart';
import '../entity/user/getuser/get_user_parameter.dart';
import '../entity/user/getuser/get_user_response.dart';
import '../entity/user/user.dart';
import '../entity/user/user_and_loaded_related_user_data.dart';
import '../repository/address_repository.dart';
import '../repository/user_repository.dart';

class GetUserAndLoadedRelatedUserDataUseCase {
  final UserRepository userRepository;
  final AddressRepository addressRepository;

  const GetUserAndLoadedRelatedUserDataUseCase({
    required this.userRepository,
    required this.addressRepository
  });

  FutureProcessing<LoadDataResult<UserAndLoadedRelatedUserData>> execute(GetUserParameter getUserParameter) {
    return FutureProcessing<LoadDataResult<UserAndLoadedRelatedUserData>>(({parameter}) async {
      LoadDataResult<GetUserResponse> getUserResponseLoadDataResult = await userRepository.getUser(
        getUserParameter
      ).future(
        parameter: parameter
      );
      if (getUserResponseLoadDataResult.isSuccess) {
        GetUserResponse getUserResponse = getUserResponseLoadDataResult.resultIfSuccess!;
        User user = getUserResponse.user;
        UserProfile userProfile = user.userProfile;
        String? countryId = userProfile.countryId;
        UserAndLoadedRelatedUserData returnValue({
          required String countryCode,
          required String countryName
        }) {
          return UserAndLoadedRelatedUserData(
            user: user,
            countryName: countryName,
            countryCode: countryCode
          );
        }
        if (countryId.isNotEmptyString) {
          return await addressRepository.countryBasedId(
            CountryBasedIdParameter(countryId: userProfile.countryId!)
          ).future(
            parameter: parameter
          ).map(
            (value) => returnValue(
              countryCode: value.country.code,
              countryName: value.country.name
            )
          );
        } else {
          // Load default Indonesia (idn)
          return SuccessLoadDataResult<UserAndLoadedRelatedUserData>(
            value: returnValue(
              countryCode: "ID",
              countryName: "Indonesia"
            )
          );
        }
      } else {
        return getUserResponseLoadDataResult.map((_) => throw UnimplementedError());
      }
    });
  }
}