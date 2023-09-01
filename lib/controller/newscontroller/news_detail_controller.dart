import 'package:get/get.dart';
import 'package:masterbagasi/misc/ext/rx_ext.dart';

import '../../domain/entity/news/news.dart';
import '../../domain/entity/news/news_detail_parameter.dart';
import '../../domain/usecase/get_news_detail_use_case.dart';
import '../../misc/load_data_result.dart';
import '../base_getx_controller.dart';

class NewsDetailController extends BaseGetxController {
  final GetNewsDetailUseCase getNewsDetailUseCase;

  LoadDataResult<News> _newsDetailLoadDataResult = NoLoadDataResult<News>();
  late Rx<LoadDataResultWrapper<News>> newsDetailLoadDataResultWrapperRx;
  bool _hasLoadNewsDetail = false;

  NewsDetailController(
    super.controllerManager,
    this.getNewsDetailUseCase
  ) {
    newsDetailLoadDataResultWrapperRx = LoadDataResultWrapper<News>(_newsDetailLoadDataResult).obs;
  }

  void loadNewsDetail(String newsId) async {
    if (_hasLoadNewsDetail) {
      return;
    }
    _newsDetailLoadDataResult = IsLoadingLoadDataResult<News>();
    _updateNewsDetailState();
    _newsDetailLoadDataResult = await getNewsDetailUseCase.execute(
      NewsDetailParameter(newsId: newsId)
    ).future(
      parameter: apiRequestManager.addRequestToCancellationPart("news-detail").value
    );
    _updateNewsDetailState();
  }

  void _updateNewsDetailState() {
    newsDetailLoadDataResultWrapperRx.valueFromLast(
      (value) => LoadDataResultWrapper<News>(_newsDetailLoadDataResult)
    );
    update();
  }
}