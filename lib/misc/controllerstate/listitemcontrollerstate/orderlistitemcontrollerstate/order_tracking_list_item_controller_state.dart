import '../../../../domain/entity/order/ordertracking/order_tracking.dart';
import '../../../errorprovider/error_provider.dart';
import '../list_item_controller_state.dart';

class OrderTrackingListItemControllerState extends ListItemControllerState {
  List<OrderTracking> orderTrackingList;
  ErrorProvider Function() errorProvider;
  int? maxVisibleOrderTrackingListCount;

  OrderTrackingListItemControllerState({
    required this.orderTrackingList,
    required this.errorProvider,
    this.maxVisibleOrderTrackingListCount
  });
}