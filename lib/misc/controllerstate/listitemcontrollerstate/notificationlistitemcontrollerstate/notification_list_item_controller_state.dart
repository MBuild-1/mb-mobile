import '../../../../domain/entity/notification/notification.dart';
import '../list_item_controller_state.dart';

class NotificationListItemControllerState extends ListItemControllerState {
  Notification notification;

  NotificationListItemControllerState({
    required this.notification
  });
}