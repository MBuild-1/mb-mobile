import '../list_item_controller_state.dart';

class PurchaseSectionNotificationListItemControllerState extends ListItemControllerState {
  int step;
  bool isLoadingStep;

  PurchaseSectionNotificationListItemControllerState({
    required this.step,
    required this.isLoadingStep
  });
}