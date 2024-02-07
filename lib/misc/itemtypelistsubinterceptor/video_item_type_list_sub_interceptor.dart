import '../../domain/entity/video/defaultvideo/default_video.dart';
import '../../domain/entity/video/shortvideo/short_video.dart';
import '../controllerstate/listitemcontrollerstate/list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/no_content_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/videolistitemcontrollerstate/default_video_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/videolistitemcontrollerstate/short_video_list_item_controller_state.dart';
import '../controllerstate/listitemcontrollerstate/videolistitemcontrollerstate/video_container_list_item_controller_state.dart';
import '../itemtypelistinterceptor/itemtypelistinterceptorchecker/list_item_controller_state_item_type_list_interceptor_checker.dart';
import '../typedef.dart';
import 'item_type_list_sub_interceptor.dart';
import 'verticalgriditemtypelistsubinterceptor/vertical_grid_item_type_list_sub_interceptor.dart';

class VideoItemTypeListSubInterceptor extends ItemTypeListSubInterceptor<ListItemControllerState> {
  final DoubleReturned padding;
  final DoubleReturned itemSpacing;
  final ListItemControllerStateItemTypeInterceptorChecker listItemControllerStateItemTypeInterceptorChecker;

  VideoItemTypeListSubInterceptor({
    required this.padding,
    required this.itemSpacing,
    required this.listItemControllerStateItemTypeInterceptorChecker
  });

  @override
  bool intercept(
    int i,
    ListItemControllerStateWrapper oldItemTypeWrapper,
    List<ListItemControllerState> oldItemTypeList,
    List<ListItemControllerState> newItemTypeList
  ) {
    ListItemControllerState oldItemType = oldItemTypeWrapper.listItemControllerState;
    if (oldItemType is VideoContainerListItemControllerState) {
      List<ListItemControllerState> newListItemControllerStateList = [];
      List<ListItemControllerState> wishlistListItemControllerStateList = oldItemType.videoList.map<ListItemControllerState>(
        (video) {
          if (video is ShortVideo) {
            return ShortVideoListItemControllerState(
              shortVideo: video
            );
          } else if (video is DefaultVideo) {
            return DefaultVideoListItemControllerState(
              defaultVideo: video
            );
          }
          return NoContentListItemControllerState();
        }
      ).toList();
      VerticalGridPaddingContentSubInterceptorSupportListItemControllerState verticalGridPaddingContentSubInterceptorSupportListItemControllerState = VerticalGridPaddingContentSubInterceptorSupportListItemControllerState(
        childListItemControllerStateList: wishlistListItemControllerStateList
      );
      listItemControllerStateItemTypeInterceptorChecker.interceptEachListItem(
        i,
        ListItemControllerStateWrapper(verticalGridPaddingContentSubInterceptorSupportListItemControllerState),
        oldItemTypeList,
        newListItemControllerStateList
      );
      newItemTypeList.addAll(newListItemControllerStateList);
      return true;
    }
    return false;
  }
}