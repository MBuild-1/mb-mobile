import '../list_item_controller_state.dart';

class PaymentInstructionHeaderListItemControllerState extends ListItemControllerState {
  String title;
  bool isExpanded;
  void Function()? onTap;

  PaymentInstructionHeaderListItemControllerState({
    required this.title,
    required this.isExpanded,
    this.onTap
  });
}