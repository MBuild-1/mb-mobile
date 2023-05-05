import '../../../../domain/entity/address/address.dart';
import '../../../../presentation/widget/address/address_item.dart';
import '../list_item_controller_state.dart';

class AddressContainerListItemControllerState extends ListItemControllerState {
  List<Address> address;
  OnSelectAddress? onSelectAddress;
  void Function() onUpdateState;
  AddressContainerStorageListItemControllerState addressContainerStorageListItemControllerState;

  AddressContainerListItemControllerState({
    required this.address,
    this.onSelectAddress,
    required this.onUpdateState,
    required this.addressContainerStorageListItemControllerState
  });
}

abstract class AddressContainerStorageListItemControllerState {}