import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/video/defaultvideo/default_video.dart';
import '../entity/video/defaultvideo/default_video_paging_parameter.dart';
import '../repository/feed_repository.dart';

class GetTripDefaultVideoPagingUseCase {
  final FeedRepository feedRepository;

  const GetTripDefaultVideoPagingUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<DefaultVideo>>> execute(DefaultVideoPagingParameter defaultVideoPagingParameter) {
    return feedRepository.defaultVideoPaging(defaultVideoPagingParameter);
  }
}