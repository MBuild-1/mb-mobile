import '../support_vertical_grid_list_item_controller_state.dart';
import 'news_list_item_controller_state.dart';

class VerticalNewsListItemControllerState extends NewsListItemControllerState with SupportVerticalGridListItemControllerStateMixin {
  @override
  int get maxRow => 1;

  VerticalNewsListItemControllerState({
    required super.news,
    super.onTapNews
  });
}

class ShimmerVerticalNewsListItemControllerState extends VerticalNewsListItemControllerState {
  ShimmerVerticalNewsListItemControllerState({
    required super.news
  });
}