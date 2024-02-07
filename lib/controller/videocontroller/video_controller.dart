import '../../domain/entity/video/defaultvideo/default_video.dart';
import '../../domain/entity/video/defaultvideo/default_video_paging_parameter.dart';
import '../../domain/entity/video/shortvideo/short_video.dart';
import '../../domain/entity/video/shortvideo/short_video_paging_parameter.dart';
import '../../domain/usecase/get_short_video_paging_use_case.dart';
import '../../domain/usecase/get_trip_default_video_paging_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../base_getx_controller.dart';

class VideoController extends BaseGetxController {
  final GetTripDefaultVideoPagingUseCase getTripDefaultVideoPagingUseCase;
  final GetShortVideoPagingUseCase getShortVideoPagingUseCase;

  VideoController(
    super.controllerManager,
    this.getTripDefaultVideoPagingUseCase,
    this.getShortVideoPagingUseCase
  );

  Future<LoadDataResult<PagingDataResult<ShortVideo>>> getShortVideoPaging(ShortVideoPagingParameter shortVideoPagingParameter) {
    return getShortVideoPagingUseCase.execute(shortVideoPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("short-video-paging").value
    );
  }

  Future<LoadDataResult<PagingDataResult<DefaultVideo>>> getDefaultVideoPaging(DefaultVideoPagingParameter defaultVideoPagingParameter) {
    return getTripDefaultVideoPagingUseCase.execute(defaultVideoPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("default-video-paging").value
    );
  }
}