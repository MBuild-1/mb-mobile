import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../domain/entity/changepassword/change_password_response.dart';
import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/login/login_with_google_response.dart';
import '../../domain/entity/logout/logout_response.dart';
import '../../domain/entity/pin/checkactivepin/check_active_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/change_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/create_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/remove_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/validate_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/validate_while_login_modify_pin_response.dart';
import '../../domain/entity/register/register_response.dart';
import '../../domain/entity/register/register_with_google_response.dart';
import '../../domain/entity/user/getuser/get_user_response.dart';
import '../../domain/entity/user/user.dart';
import '../../misc/response_wrapper.dart';

extension UserEntityMappingExt on ResponseWrapper {
  LoginResponse mapFromResponseToLoginResponse() {
    return LoginResponse(
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  LoginWithGoogleResponse mapFromResponseToLoginWithGoogleResponse() {
    return LoginWithGoogleResponse(
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  RegisterResponse mapFromResponseToRegisterResponse() {
    return RegisterResponse(
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  RegisterWithGoogleResponse mapFromResponseToRegisterWithGoogleResponse() {
    return RegisterWithGoogleResponse(
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  LogoutResponse mapFromResponseToLogoutResponse() {
    return LogoutResponse();
  }

  GetUserResponse mapFromResponseToGetUserResponse() {
    return GetUserResponse(
      user: ResponseWrapper(response).mapFromResponseToUser()
    );
  }

  ChangePasswordResponse mapFromResponseToChangePasswordResponse() {
    return ChangePasswordResponse();
  }

  CreateModifyPinResponse mapFromResponseToCreateModifyPinResponse() {
    return CreateModifyPinResponse();
  }

  ChangeModifyPinResponse mapFromResponseToChangeModifyPinResponse() {
    return ChangeModifyPinResponse();
  }

  RemoveModifyPinResponse mapFromResponseToRemoveModifyPinResponse() {
    return RemoveModifyPinResponse();
  }

  ValidateModifyPinResponse mapFromResponseToValidateModifyPinResponse() {
    return ValidateModifyPinResponse();
  }

  ValidateWhileLoginModifyPinResponse mapFromResponseToValidateWhileLoginModifyPinResponse(LoginResponse loginResponse) {
    return ValidateWhileLoginModifyPinResponse(
      loginResponse: loginResponse
    );
  }

  CheckActivePinResponse mapFromResponseToCheckActivePinResponse() {
    return CheckActivePinResponse(
      active: response["active"]
    );
  }
}

extension UserDetailEntityMappingExt on ResponseWrapper {
  User mapFromResponseToUser() {
    return User(
      id: response["id"],
      name: response["name"],
      email: response["email"],
      role: response["role"],
      userProfile: ResponseWrapper(response["user_profile"]).mapFromResponseToUserProfile(),
      createdAt: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime()!
    );
  }

  UserProfile mapFromResponseToUserProfile() {
    return UserProfile(
      id: response["id"],
      userId: response["user_id"],
      avatar: response["avatar"],
      gender: response["gender"],
      dateBirth: ResponseWrapper(response["date_birth"]).mapFromResponseToDateTime(),
      placeBirth: response["place_birth"],
      phoneNumber: response["phone_number"]
    );
  }
}