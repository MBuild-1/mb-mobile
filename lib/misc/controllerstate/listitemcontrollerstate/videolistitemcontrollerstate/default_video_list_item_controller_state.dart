import '../../../../domain/entity/video/defaultvideo/default_video.dart';
import '../list_item_controller_state.dart';
import '../support_vertical_grid_list_item_controller_state.dart';

class DefaultVideoListItemControllerState extends ListItemControllerState with SupportVerticalGridListItemControllerStateMixin {
  @override
  int get maxRow => 1;

  DefaultVideo defaultVideo;

  DefaultVideoListItemControllerState({
    required this.defaultVideo
  });
}