import '../../../../domain/entity/notification/notification.dart';
import '../../../../presentation/widget/colorful_chip_tab_bar.dart';
import '../list_item_controller_state.dart';

class NotificationContainerListItemControllerState extends ListItemControllerState {
  List<Notification> notificationList;
  void Function() onUpdateState;
  void Function(Notification) onNotificationTap;
  ColorfulChipTabBarController notificationTabColorfulChipTabBarController;
  List<ColorfulChipTabBarData> notificationColorfulChipTabBarDataList;

  NotificationContainerListItemControllerState({
    required this.notificationList,
    required this.onUpdateState,
    required this.onNotificationTap,
    required this.notificationTabColorfulChipTabBarController,
    required this.notificationColorfulChipTabBarDataList
  });
}