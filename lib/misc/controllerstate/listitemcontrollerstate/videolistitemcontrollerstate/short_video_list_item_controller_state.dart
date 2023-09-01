import '../../../../domain/entity/video/shortvideo/short_video.dart';
import '../list_item_controller_state.dart';
import '../support_vertical_grid_list_item_controller_state.dart';

class ShortVideoListItemControllerState extends ListItemControllerState with SupportVerticalGridListItemControllerStateMixin {
  ShortVideo shortVideo;

  ShortVideoListItemControllerState({
    required this.shortVideo
  });
}