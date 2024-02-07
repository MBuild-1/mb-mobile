import '../../domain/entity/news/news.dart';
import '../../domain/entity/news/news_paging_parameter.dart';
import '../../domain/usecase/get_news_paging_use_case.dart';
import '../../misc/load_data_result.dart';
import '../../misc/paging/pagingresult/paging_data_result.dart';
import '../base_getx_controller.dart';

class NewsController extends BaseGetxController {
  final GetNewsPagingUseCase getNewsPagingUseCase;

  NewsController(
    super.controllerManager,
    this.getNewsPagingUseCase
  );

  Future<LoadDataResult<PagingDataResult<News>>> getNewsPaging(NewsPagingParameter newsPagingParameter) {
    return getNewsPagingUseCase.execute(newsPagingParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("news-paging").value
    );
  }
}