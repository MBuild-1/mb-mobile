import '../../../domain/entity/user/user_and_loaded_related_user_data.dart';
import '../../errorprovider/error_provider.dart';
import '../../load_data_result.dart';
import 'list_item_controller_state.dart';

class MenuProfileHeaderListItemControllerState extends ListItemControllerState {
  LoadDataResult<UserAndLoadedRelatedUserData> userLoadDataResult;
  ErrorProvider errorProvider;

  MenuProfileHeaderListItemControllerState({
    required this.userLoadDataResult,
    required this.errorProvider
  });
}