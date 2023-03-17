import '../../domain/entity/province/province.dart';
import '../../misc/response_wrapper.dart';

extension ProvinceEntityMappingExt on ResponseWrapper {
  Province mapFromResponseToProvince() {
    return Province(
      id: response["id"],
      name: response["name"],
      description: response["description"],
      slug: response["slug"],
      icon: response["icon"],
      background: response["background"],
      bannerDesktop: response["banner_desktop"],
      bannerMobile: response["banner_mobile"],
    );
  }
}