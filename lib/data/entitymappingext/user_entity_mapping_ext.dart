import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/changepassword/change_password_response.dart';
import '../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_response.dart';
import '../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_response.dart';
import '../../domain/entity/forgotpassword/forgot_password_response.dart';
import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/login/login_with_apple_response.dart';
import '../../domain/entity/login/login_with_google_response.dart';
import '../../domain/entity/logout/logout_response.dart';
import '../../domain/entity/pin/checkactivepin/check_active_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/change_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/create_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/remove_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/validate_modify_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/validate_while_login_modify_pin_response.dart';
import '../../domain/entity/register/register_first_step_response.dart';
import '../../domain/entity/register/register_response.dart';
import '../../domain/entity/register/register_second_step_response.dart';
import '../../domain/entity/register/register_with_apple_response.dart';
import '../../domain/entity/register/register_with_google_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/email_send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/wa_send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/email_send_register_otp_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/wa_send_register_otp_response.dart';
import '../../domain/entity/register/verify_register_response.dart';
import '../../domain/entity/resetpassword/check/check_reset_password_response.dart';
import '../../domain/entity/resetpassword/reset_password_response.dart';
import '../../domain/entity/user/edituser/edit_user_response.dart';
import '../../domain/entity/user/getuser/get_user_response.dart';
import '../../domain/entity/user/user.dart';
import '../../domain/entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/auth_identity_change_input_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentityverifyotp/auth_identity_verify_otp_response.dart';
import '../../misc/error/message_error.dart';
import '../../misc/response_wrapper.dart';

extension UserEntityMappingExt on ResponseWrapper {
  LoginResponse mapFromResponseToLoginResponse() {
    return LoginResponse(
      userId: response["user"]["id"],
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  LoginWithGoogleResponse mapFromResponseToLoginWithGoogleResponse() {
    return LoginWithGoogleResponse(
      userId: response["user"]["id"],
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  LoginWithAppleResponse mapFromResponseToLoginWithAppleResponse() {
    return LoginWithAppleResponse(
      userId: response["user"]["id"],
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  RegisterFirstStepResponse mapFromResponseToRegisterFirstStepResponse() {
    return RegisterFirstStepResponse(
      emailActive: response["email_active"],
      phoneActive: response["phone_active"],
      credential: response["credential"],
    );
  }

  VerifyRegisterResponse mapFromResponseToVerifyRegisterResponse() {
    return VerifyRegisterResponse(
      credential: response["credential"]
    );
  }

  SendRegisterOtpResponse mapFromResponseToSendRegisterOtpResponse(SendRegisterOtpParameter sendRegisterOtpParameter) {
    dynamic credential = response["credential"];
    if (sendRegisterOtpParameter is EmailSendRegisterOtpParameter) {
      return EmailSendRegisterOtpResponse(
        credential: credential
      );
    } else if (sendRegisterOtpParameter is WaSendRegisterOtpParameter) {
      return WaSendRegisterOtpResponse(
        credential: credential
      );
    } else {
      throw MessageError(title: "Send register otp parameter is not suitable");
    }
  }

  RegisterSecondStepResponse mapFromResponseToRegisterSecondStepResponse() {
    RegisterResponse registerResponse = ResponseWrapper(response).mapFromResponseToRegisterResponse();
    return RegisterSecondStepResponse(
      userId: registerResponse.userId,
      token: registerResponse.token,
      tokenType: registerResponse.tokenType,
      expiresIn: registerResponse.expiresIn
    );
  }

  RegisterResponse mapFromResponseToRegisterResponse() {
    return RegisterResponse(
      userId: response["user"]["id"],
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  RegisterWithGoogleResponse mapFromResponseToRegisterWithGoogleResponse() {
    return RegisterWithGoogleResponse(
      userId: response["user"]["id"],
      token: response["access_token"],
      tokenType: response["token_type"],
      expiresIn: response["expires_in"]
    );
  }

  RegisterWithAppleResponse mapFromResponseToRegisterWithAppleResponse() {
    return RegisterWithAppleResponse(
      userId: response["user"]["id"],
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

  EditUserResponse mapFromResponseToEditUserResponse() {
    return EditUserResponse();
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

  ForgotPasswordResponse mapFromResponseToForgotPasswordResponse() {
    return ForgotPasswordResponse();
  }

  CheckResetPasswordResponse mapFromResponseToCheckResetPasswordResponse() {
    return CheckResetPasswordResponse();
  }

  ResetPasswordResponse mapFromResponseToResetPasswordResponse() {
    return ResetPasswordResponse();
  }

  SendDeleteAccountOtpResponse mapFromResponseToSendDeleteAccountOtpResponse() {
    return SendDeleteAccountOtpResponse();
  }

  VerifyDeleteAccountOtpResponse mapFromResponseToVerifyDeleteAccountOtpResponse() {
    return VerifyDeleteAccountOtpResponse();
  }

  AuthIdentityResponse mapFromResponseToAuthIdentityResponse() {
    return AuthIdentityResponse(data: response ?? "");
  }

  AuthIdentitySendVerifyOtpResponse mapFromResponseToAuthIdentitySendVerifyOtpResponse() {
    return AuthIdentitySendVerifyOtpResponse();
  }

  AuthIdentityVerifyOtpResponse mapFromResponseToAuthIdentityVerifyOtpResponse() {
    return AuthIdentityVerifyOtpResponse();
  }

  AuthIdentityChangeInputResponse mapFromResponseToAuthIdentityChangeInputResponse() {
    return AuthIdentityChangeInputResponse();
  }

  AuthIdentityChangeResponse mapFromResponseToAuthIdentityChangeResponse() {
    return AuthIdentityChangeResponse();
  }
}

extension UserDetailEntityMappingExt on ResponseWrapper {
  User mapFromResponseToUser() {
    return User(
      id: response["id"],
      name: response["name"],
      email: (response["email"] as String?).toEmptyStringNonNull,
      role: response["role"],
      userProfile: ResponseWrapper(response["user_profile"]).mapFromResponseToUserProfile(),
      createdAt: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime()!
    );
  }

  UserProfile mapFromResponseToUserProfile() {
    if (response == null) {
      return NoUserProfile();
    }
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