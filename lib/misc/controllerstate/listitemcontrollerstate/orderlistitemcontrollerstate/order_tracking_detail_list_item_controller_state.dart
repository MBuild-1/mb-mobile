import '../../../../domain/entity/order/ordertracking/order_tracking.dart';
import '../../../errorprovider/error_provider.dart';
import '../list_item_controller_state.dart';

class OrderTrackingDetailListItemControllerState extends ListItemControllerState {
  OrderTracking orderTracking;
  ErrorProvider Function() errorProvider;

  OrderTrackingDetailListItemControllerState({
    required this.orderTracking,
    required this.errorProvider,
  });
}