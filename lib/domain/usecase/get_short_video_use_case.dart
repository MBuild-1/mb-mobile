import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/video/shortvideo/short_video.dart';
import '../entity/video/shortvideo/short_video_list_parameter.dart';
import '../repository/feed_repository.dart';

class GetShortVideoUseCase {
  final FeedRepository feedRepository;

  const GetShortVideoUseCase({
    required this.feedRepository
  });

  FutureProcessing<LoadDataResult<List<ShortVideo>>> execute() {
    return feedRepository.shortVideoList(ShortVideoListParameter()).map<LoadDataResult<List<ShortVideo>>>(
      onMap: (loadDataResult) => loadDataResult.map(
        (value) => value.take(5).toList()
      )
    );
  }
}