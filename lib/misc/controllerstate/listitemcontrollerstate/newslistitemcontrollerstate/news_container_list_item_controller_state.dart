import '../../../../domain/entity/news/news.dart';
import '../list_item_controller_state.dart';

class NewsContainerListItemControllerState extends ListItemControllerState {
  List<News> newsList;
  void Function() onUpdateState;
  void Function(News) onNewsTap;

  NewsContainerListItemControllerState({
    required this.newsList,
    required this.onUpdateState,
    required this.onNewsTap
  });
}