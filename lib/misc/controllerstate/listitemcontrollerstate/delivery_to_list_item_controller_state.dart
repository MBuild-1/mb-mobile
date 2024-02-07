import '../../../domain/entity/address/address.dart';
import '../../../presentation/page/modaldialogpage/select_address_modal_dialog_page.dart';
import '../../errorprovider/error_provider.dart';
import '../../load_data_result.dart';
import 'list_item_controller_state.dart';

class DeliveryToListItemControllerState extends ListItemControllerState {
  LoadDataResult<Address> addressLoadDataResult;
  ErrorProvider errorProvider;
  void Function(Address)? onAddressSelectedChanged;
  void Function()? onGotoAddAddress;
  SelectAddressModalDialogPageActionDelegate selectAddressModalDialogPageActionDelegate;

  DeliveryToListItemControllerState({
    required this.addressLoadDataResult,
    required this.errorProvider,
    this.onAddressSelectedChanged,
    this.onGotoAddAddress,
    required this.selectAddressModalDialogPageActionDelegate
  });
}