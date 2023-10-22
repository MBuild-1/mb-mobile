import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/user/edituser/edit_user_parameter.dart';
import '../domain/entity/user/edituser/edit_user_response.dart';
import '../domain/entity/user/getuser/get_user_parameter.dart';
import '../domain/entity/user/user.dart';
import '../domain/usecase/edit_user_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnEditProfileBack = void Function();
typedef _OnShowEditProfileRequestProcessLoadingCallback = Future<void> Function();
typedef _OnEditProfileRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowEditProfileRequestProcessFailedCallback = Future<void> Function(dynamic e);

class EditProfileController extends BaseGetxController {
  final EditUserUseCase editUserUseCase;
  final GetUserUseCase getUserUseCase;

  EditProfileDelegate? _editProfileDelegate;

  EditProfileController(
    super.controllerManager,
    this.editUserUseCase,
    this.getUserUseCase
  );

  Future<LoadDataResult<User>> getUserProfile(GetUserParameter getUserParameter) {
    return getUserUseCase.execute(getUserParameter).future(
      parameter: apiRequestManager.addRequestToCancellationPart("user-profile").value
    ).map<User>(
      (getUserResponse) => getUserResponse.user
    );
  }

  void editProfile(EditUserParameter editUserParameter) async {
    if (_editProfileDelegate != null) {
      _editProfileDelegate!.onUnfocusAllWidget();
      _editProfileDelegate!.onShowEditProfileRequestProcessLoadingCallback();
      LoadDataResult<EditUserResponse> editUserResponseLoadDataResult = await editUserUseCase.execute(
        editUserParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('edit-profile').value
      );
      _editProfileDelegate!.onEditProfileBack();
      if (editUserResponseLoadDataResult.isSuccess) {
        _editProfileDelegate!.onEditProfileRequestProcessSuccessCallback();
      } else {
        _editProfileDelegate!.onShowEditProfileRequestProcessFailedCallback(editUserResponseLoadDataResult.resultIfFailed);
      }
    }
  }

  void setEditProfileDelegate(EditProfileDelegate editProfileDelegate) {
    _editProfileDelegate = editProfileDelegate;
  }
}

class EditProfileDelegate {
  OnUnfocusAllWidget onUnfocusAllWidget;
  _OnEditProfileBack onEditProfileBack;
  _OnShowEditProfileRequestProcessLoadingCallback onShowEditProfileRequestProcessLoadingCallback;
  _OnEditProfileRequestProcessSuccessCallback onEditProfileRequestProcessSuccessCallback;
  _OnShowEditProfileRequestProcessFailedCallback onShowEditProfileRequestProcessFailedCallback;

  EditProfileDelegate({
    required this.onUnfocusAllWidget,
    required this.onEditProfileBack,
    required this.onShowEditProfileRequestProcessLoadingCallback,
    required this.onEditProfileRequestProcessSuccessCallback,
    required this.onShowEditProfileRequestProcessFailedCallback
  });
}