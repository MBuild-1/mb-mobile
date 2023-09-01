import '../../../../domain/entity/video/video.dart';
import '../list_item_controller_state.dart';

class VideoContainerListItemControllerState extends ListItemControllerState {
  List<Video> videoList;
  void Function() onUpdateState;
  void Function(Video) onVideoTap;

  VideoContainerListItemControllerState({
    required this.videoList,
    required this.onUpdateState,
    required this.onVideoTap
  });
}