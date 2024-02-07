import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/banner/transparent_banner.dart';
import '../entity/banner/transparent_banner_with_type_list_parameter.dart';
import '../repository/banner_repository.dart';

class GetHandycraftsContentsBannerUseCase {
  final BannerRepository bannerRepository;

  const GetHandycraftsContentsBannerUseCase({
    required this.bannerRepository
  });

  FutureProcessing<LoadDataResult<List<TransparentBanner>>> execute() {
    return bannerRepository.transparentBannerWithTypeList(
      TransparentBannerWithTypeListParameter(
        type: "handycrafts"
      )
    );
  }
}