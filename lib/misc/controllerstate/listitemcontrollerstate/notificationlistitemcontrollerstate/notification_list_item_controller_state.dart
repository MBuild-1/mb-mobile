import '../../../../domain/entity/notification/short_notification.dart';
import '../list_item_controller_state.dart';

class NotificationListItemControllerState extends ListItemControllerState {
  ShortNotification shortNotification;
  void Function(ShortNotification)? onTap;

  NotificationListItemControllerState({
    required this.shortNotification,
    this.onTap
  });
}