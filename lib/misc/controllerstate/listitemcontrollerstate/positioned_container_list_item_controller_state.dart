import 'list_item_controller_state.dart';

class PositionedContainerListItemControllerState extends ListItemControllerState {
  double? left;
  double? top;
  double? right;
  double? bottom;
  double? width;
  double? height;
  ListItemControllerState childListItemControllerState;

  PositionedContainerListItemControllerState({
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.childListItemControllerState
  });
}