import '../../../../domain/entity/notification/notification.dart';
import '../../../../domain/entity/notification/short_notification.dart';
import '../../../../presentation/widget/colorful_chip_tab_bar.dart';
import '../../../errorprovider/error_provider.dart';
import '../../../load_data_result.dart';
import '../list_item_controller_state.dart';

class NotificationContainerListItemControllerState extends ListItemControllerState {
  List<ShortNotification> notificationList;
  void Function() onUpdateState;
  void Function(ShortNotification)? Function(ShortNotification) onNotificationTap;
  void Function()? onMarkAllNotification;
  LoadDataResult<int> Function() purchaseStatusLoadDataResult;
  LoadDataResult<int> Function() notificationLoadDataResult;
  LoadDataResult<int> Function() transactionNotificationLoadDataResult;
  LoadDataResult<int> Function() infoNotificationLoadDataResult;
  LoadDataResult<int> Function() promoNotificationLoadDataResult;
  ErrorProvider Function() onGetErrorProvider;
  ColorfulChipTabBarController notificationTabColorfulChipTabBarController;
  List<ColorfulChipTabBarData> notificationColorfulChipTabBarDataList;

  NotificationContainerListItemControllerState({
    required this.notificationList,
    required this.onUpdateState,
    required this.onNotificationTap,
    required this.onMarkAllNotification,
    required this.purchaseStatusLoadDataResult,
    required this.notificationLoadDataResult,
    required this.transactionNotificationLoadDataResult,
    required this.infoNotificationLoadDataResult,
    required this.promoNotificationLoadDataResult,
    required this.onGetErrorProvider,
    required this.notificationTabColorfulChipTabBarController,
    required this.notificationColorfulChipTabBarDataList
  });
}