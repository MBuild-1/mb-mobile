import '../../../domain/entity/location/location.dart';
import 'list_item_controller_state.dart';

class DeliveryToListItemControllerState extends ListItemControllerState {
  Location location;

  DeliveryToListItemControllerState({
    required this.location
  });
}