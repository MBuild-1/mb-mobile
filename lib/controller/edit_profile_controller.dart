import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/load_data_result_ext.dart';

import '../domain/entity/user/edituser/edit_user_parameter.dart';
import '../domain/entity/user/edituser/edit_user_response.dart';
import '../domain/entity/user/getuser/get_user_parameter.dart';
import '../domain/entity/user/user.dart';
import '../domain/entity/verifyeditprofile/authidentity/auth_identity_parameter_and_response.dart';
import '../domain/entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../domain/entity/verifyeditprofile/authidentity/parameter/auth_identity_parameter.dart';
import '../domain/usecase/auth_identity_use_case.dart';
import '../domain/usecase/edit_user_use_case.dart';
import '../domain/usecase/get_user_use_case.dart';
import '../misc/load_data_result.dart';
import '../misc/typedef.dart';
import 'base_getx_controller.dart';

typedef _OnEditProfileBack = void Function();
typedef _OnShowEditProfileRequestProcessLoadingCallback = Future<void> Function();
typedef _OnEditProfileRequestProcessSuccessCallback = Future<void> Function();
typedef _OnShowEditProfileRequestProcessFailedCallback = Future<void> Function(dynamic e);
typedef _OnShowAuthIdentityRequestProcessLoadingCallback = Future<void> Function();
typedef _OnAuthIdentityRequestProcessSuccessCallback = Future<void> Function(AuthIdentityParameterAndResponse);
typedef _OnShowAuthIdentityRequestProcessFailedCallback = Future<void> Function(dynamic e);

class EditProfileController extends BaseGetxController {
  final EditUserUseCase editUserUseCase;
  final GetUserUseCase getUserUseCase;
  final AuthIdentityUseCase authIdentityUseCase;

  EditProfileDelegate? _editProfileDelegate;

  EditProfileController(
    super.controllerManager,
    this.editUserUseCase,
    this.getUserUseCase,
    this.authIdentityUseCase
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

  void authIdentity(AuthIdentityParameter authIdentityParameter, {bool usingBackListener = false}) async {
    if (_editProfileDelegate != null) {
      _editProfileDelegate!.onUnfocusAllWidget();
      _editProfileDelegate!.onShowAuthIdentityRequestProcessLoadingCallback();
      LoadDataResult<AuthIdentityResponse> authIdentityResponseLoadDataResult = await authIdentityUseCase.execute(
        authIdentityParameter
      ).future(
        parameter: apiRequestManager.addRequestToCancellationPart('auth-identity').value
      );
      if (usingBackListener) {
        _editProfileDelegate!.onEditProfileBack();
      }
      if (authIdentityResponseLoadDataResult.isSuccess) {
        _editProfileDelegate!.onAuthIdentityRequestProcessSuccessCallback(
          AuthIdentityParameterAndResponse(
            authIdentityParameter: authIdentityParameter,
            authIdentityResponse: authIdentityResponseLoadDataResult.resultIfSuccess!
          )
        );
      } else {
        _editProfileDelegate!.onShowAuthIdentityRequestProcessFailedCallback(authIdentityResponseLoadDataResult.resultIfFailed);
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
  _OnShowAuthIdentityRequestProcessLoadingCallback onShowAuthIdentityRequestProcessLoadingCallback;
  _OnAuthIdentityRequestProcessSuccessCallback onAuthIdentityRequestProcessSuccessCallback;
  _OnShowAuthIdentityRequestProcessFailedCallback onShowAuthIdentityRequestProcessFailedCallback;

  EditProfileDelegate({
    required this.onUnfocusAllWidget,
    required this.onEditProfileBack,
    required this.onShowEditProfileRequestProcessLoadingCallback,
    required this.onEditProfileRequestProcessSuccessCallback,
    required this.onShowEditProfileRequestProcessFailedCallback,
    required this.onShowAuthIdentityRequestProcessLoadingCallback,
    required this.onAuthIdentityRequestProcessSuccessCallback,
    required this.onShowAuthIdentityRequestProcessFailedCallback
  });
}