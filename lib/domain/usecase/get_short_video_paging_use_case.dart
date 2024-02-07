import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/video/shortvideo/short_video.dart';
import '../entity/video/shortvideo/short_video_paging_parameter.dart';
import '../repository/feed_repository.dart';

class GetShortVideoPagingUseCase {
  final FeedRepository feedRepository;

  const GetShortVideoPagingUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<PagingDataResult<ShortVideo>>> execute(ShortVideoPagingParameter shortVideoPagingParameter) {
    return feedRepository.shortVideoPaging(shortVideoPagingParameter);
  }
}