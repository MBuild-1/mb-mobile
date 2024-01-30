import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/entity/changepassword/change_password_parameter.dart';
import 'package:masterbagasi/domain/entity/changepassword/change_password_response.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_parameter.dart';
import '../../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_response.dart';
import '../../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_parameter.dart';
import '../../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_response.dart';
import '../../../domain/entity/forgotpassword/forgot_password_parameter.dart';
import '../../../domain/entity/forgotpassword/forgot_password_response.dart';
import '../../../domain/entity/login/login_parameter.dart';
import '../../../domain/entity/login/login_response.dart';
import '../../../domain/entity/login/login_with_google_parameter.dart';
import '../../../domain/entity/login/login_with_google_response.dart';
import '../../../domain/entity/logout/logout_parameter.dart';
import '../../../domain/entity/logout/logout_response.dart';
import '../../../domain/entity/pin/checkactivepin/check_active_pin_parameter.dart';
import '../../../domain/entity/pin/checkactivepin/check_active_pin_response.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/change_modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/create_modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/validate_while_login_modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinresponse/modify_pin_response.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/remove_modify_pin_parameter.dart';
import '../../../domain/entity/pin/modifypin/modifypinparameter/validate_modify_pin_parameter.dart';
import '../../../domain/entity/register/register_first_step_parameter.dart';
import '../../../domain/entity/register/register_first_step_response.dart';
import '../../../domain/entity/register/register_parameter.dart';
import '../../../domain/entity/register/register_response.dart';
import '../../../domain/entity/register/register_second_step_parameter.dart';
import '../../../domain/entity/register/register_second_step_response.dart';
import '../../../domain/entity/register/register_with_google_parameter.dart';
import '../../../domain/entity/register/register_with_google_response.dart';
import '../../../domain/entity/register/sendregisterotp/sendregisterotpparameter/email_send_register_otp_parameter.dart';
import '../../../domain/entity/register/sendregisterotp/sendregisterotpparameter/wa_send_register_otp_parameter.dart';
import '../../../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../../../domain/entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../../../domain/entity/register/verify_register_parameter.dart';
import '../../../domain/entity/register/verify_register_response.dart';
import '../../../domain/entity/resetpassword/check/check_reset_password_parameter.dart';
import '../../../domain/entity/resetpassword/check/check_reset_password_response.dart';
import '../../../domain/entity/resetpassword/reset_password_parameter.dart';
import '../../../domain/entity/resetpassword/reset_password_response.dart';
import '../../../domain/entity/user/edituser/edit_user_parameter.dart';
import '../../../domain/entity/user/edituser/edit_user_response.dart';
import '../../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../../domain/entity/user/getuser/get_user_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/parameter/auth_identity_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/parameter/email_auth_identity_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentity/parameter/phone_auth_identity_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/auth_identity_change_input_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/auth_identity_change_input_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/email_auth_identity_change_input_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/phone_auth_identity_change_input_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/auth_identity_change_verify_otp_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/auth_identity_change_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/email_auth_identity_change_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/phone_auth_identity_change_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/auth_identity_verify_otp_response.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/auth_identity_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/email_auth_identity_verify_otp_parameter.dart';
import '../../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/phone_auth_identity_verify_otp_parameter.dart';
import '../../../misc/date_util.dart';
import '../../../misc/error/message_error.dart';
import '../../../misc/http_client.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
import '../../../misc/response_wrapper.dart';
import 'user_data_source.dart';

class DefaultUserDataSource implements UserDataSource {
  final Dio dio;

  const DefaultUserDataSource({
    required this.dio
  });

  @override
  FutureProcessing<LoginResponse> login(LoginParameter loginParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "credential": loginParameter.credential,
        "password": loginParameter.password
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post(
        "/auth/login",
        data: formData,
        queryParameters: {"device_id": loginParameter.pushNotificationSubscriptionId},
        cancelToken: cancelToken,
        options: OptionsBuilder.multipartData().withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<LoginResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToLoginResponse()
      );
    });
  }

  @override
  FutureProcessing<LoginWithGoogleResponse> loginWithGoogle(LoginWithGoogleParameter loginWithGoogleParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "id_token": loginWithGoogleParameter.idToken,
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/auth/google", data: formData, queryParameters: {"device_id": loginWithGoogleParameter.pushNotificationSubscriptionId}, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<LoginWithGoogleResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToLoginWithGoogleResponse());
    });
  }

  @override
  FutureProcessing<RegisterFirstStepResponse> registerFirstStep(RegisterFirstStepParameter registerFirstStepParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "credential": registerFirstStepParameter.emailOrPhoneNumber
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post(
        "/auth/check/credential",
        data: formData,
        cancelToken: cancelToken,
        options: OptionsBuilder.multipartData().withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<RegisterFirstStepResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToRegisterFirstStepResponse()
      );
    });
  }

  @override
  FutureProcessing<SendRegisterOtpResponse> sendRegisterOtp(SendRegisterOtpParameter sendRegisterOtpParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "credential": sendRegisterOtpParameter.credential
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post(
        () {
          if (sendRegisterOtpParameter is EmailSendRegisterOtpParameter) {
            return "/auth/send/otp/email";
          } else if (sendRegisterOtpParameter is WaSendRegisterOtpParameter) {
            return "/verify/otp/wa";
          } else {
            throw MessageError(title: "Send register otp parameter is not suitable");
          }
        }(),
        data: formData,
        cancelToken: cancelToken,
        options: () {
          OptionsBuilder optionsBuilder = OptionsBuilder.multipartData();
          if (sendRegisterOtpParameter is EmailSendRegisterOtpParameter) {
            optionsBuilder.withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1"));
          }
          return optionsBuilder.buildExtended();
        }()
      ).map<SendRegisterOtpResponse>(
        onMap: (value) {
          return value.wrapResponse().mapFromResponseToSendRegisterOtpResponse(sendRegisterOtpParameter);
        }
      );
    });
  }

  @override
  FutureProcessing<VerifyRegisterResponse> verifyRegister(VerifyRegisterParameter verifyRegisterParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "credential": verifyRegisterParameter.credential,
        "otp": verifyRegisterParameter.otp
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post(
        "/check/verify/otp",
        data: formData,
        cancelToken: cancelToken,
      ).map<VerifyRegisterResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToVerifyRegisterResponse()
      );
    });
  }

  @override
  FutureProcessing<RegisterSecondStepResponse> registerSecondStep(RegisterSecondStepParameter registerSecondStepParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "credential": registerSecondStepParameter.credential,
        "name": registerSecondStepParameter.name,
        "password": registerSecondStepParameter.password,
        "password_confirmation": registerSecondStepParameter.passwordConfirmation,
        "gender": registerSecondStepParameter.gender
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post(
        "/auth/register",
        data: formData,
        cancelToken: cancelToken,
        queryParameters: {"device_id": registerSecondStepParameter.pushNotificationSubscriptionId},
        options: OptionsBuilder.multipartData().withBaseUrl(dio.options.baseUrl.replaceAll("v1", "v1.1")).buildExtended()
      ).map<RegisterSecondStepResponse>(
        onMap: (value) => value.wrapResponse().mapFromResponseToRegisterSecondStepResponse()
      );
    });
  }

  @override
  FutureProcessing<RegisterResponse> register(RegisterParameter registerParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "name": registerParameter.name,
        "email": registerParameter.email,
        "password": registerParameter.password,
        "password_confirmation": registerParameter.passwordConfirmation
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/auth/register", data: formData, queryParameters: {"device_id": registerParameter.pushNotificationSubscriptionId}, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<RegisterResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToRegisterResponse());
    });
  }

  @override
  FutureProcessing<RegisterWithGoogleResponse> registerWithGoogle(RegisterWithGoogleParameter registerWithGoogleParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "id_token": registerWithGoogleParameter.idToken,
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/auth/google", data: formData, queryParameters: {"device_id": registerWithGoogleParameter.pushNotificationSubscriptionId}, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<RegisterWithGoogleResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToRegisterWithGoogleResponse());
    });
  }

  @override
  FutureProcessing<LogoutResponse> logout(LogoutParameter logoutParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/auth/logout", cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<LogoutResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToLogoutResponse());
    });
  }

  @override
  FutureProcessing<GetUserResponse> getUser(GetUserParameter getUserParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/auth/me", cancelToken: cancelToken)
        .map<GetUserResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetUserResponse());
    });
  }

  @override
  FutureProcessing<EditUserResponse> editUser(EditUserParameter editUserParameter) {
    return DioHttpClientProcessing((cancelToken) async {
      dynamic formData = FormData.fromMap(
        <String, dynamic>{
          "_method": "PUT",
          if (editUserParameter.avatar.isNotEmptyString) "avatar": await MultipartFile.fromFile(editUserParameter.avatar!),
          if (editUserParameter.name.isNotEmptyString) "name": editUserParameter.name,
          if (editUserParameter.email.isNotEmptyString) "email": editUserParameter.email,
          if (editUserParameter.gender.isNotEmptyString) "gender": editUserParameter.gender,
          if (editUserParameter.birthDateTime != null) "date_birth": DateUtil.standardDateFormat.format(editUserParameter.birthDateTime!),
          if (editUserParameter.placeBirth.isNotEmptyString) "place_birth": editUserParameter.placeBirth,
          if (editUserParameter.phoneNumber.isNotEmptyString) "phone_number": editUserParameter.phoneNumber
        }
      );
      return dio.post("/user/profile", data: formData, cancelToken: cancelToken)
        .map<EditUserResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToEditUserResponse());
    });
  }

  @override
  FutureProcessing<ChangePasswordResponse> changePassword(ChangePasswordParameter changePasswordParameter) {
    FormData formData = FormData.fromMap(
      <String, dynamic> {
        "current_password": changePasswordParameter.currentPassword,
        "new_password": changePasswordParameter.newPassword,
        "new_password_confirmation": changePasswordParameter.confirmNewPassword,
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/change-password", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<ChangePasswordResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToChangePasswordResponse());
    });
  }

  @override
  FutureProcessing<CheckActivePinResponse> checkActivePin(CheckActivePinParameter checkActivePinParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/active/pin", cancelToken: cancelToken)
        .map<CheckActivePinResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCheckActivePinResponse());
    });
  }

  @override
  FutureProcessing<ModifyPinResponse> modifyPin(ModifyPinParameter modifyPinParameter) {
    String modifyPinEndpoint = "";
    LoginResponse? loginResponse;
    Map<String, dynamic> formDataMap = {};
    if (modifyPinParameter is CreateModifyPinParameter) {
      modifyPinEndpoint = "/create/pin";
      formDataMap = <String, dynamic> {
        "pin": modifyPinParameter.pin,
      };
    } else if (modifyPinParameter is ChangeModifyPinParameter) {
      modifyPinEndpoint = "/change-pin";
      formDataMap = <String, dynamic> {
        "current_pin": modifyPinParameter.currentPin,
        "new_pin": modifyPinParameter.newPin,
      };
    } else if (modifyPinParameter is RemoveModifyPinParameter) {
      modifyPinEndpoint = "/remove-pin";
      formDataMap = <String, dynamic> {
        "pin": modifyPinParameter.pin,
      };
    } else if (modifyPinParameter is ValidateModifyPinParameter) {
      modifyPinEndpoint = "/check/pin";
      if (modifyPinParameter is ValidateWhileLoginModifyPinParameter) {
        loginResponse = ResponseWrapper(jsonDecode(modifyPinParameter.data)).mapFromResponseToLoginResponse();
        formDataMap = <String, dynamic> {
          "pin": modifyPinParameter.pin,
          "data": modifyPinParameter.data
        };
      } else {
        formDataMap = <String, dynamic> {
          "pin": modifyPinParameter.pin,
        };
      }
    }
    FormData formData = FormData.fromMap(formDataMap);
    return DioHttpClientProcessing((cancelToken) {
      return () {
        if (modifyPinParameter is RemoveModifyPinParameter) {
          Future<Response> checkAndRemovePin() async {
            try {
              await modifyPin(
                ValidateModifyPinParameter(pin: modifyPinParameter.pin)
              ).future(
                parameter: cancelToken
              );
              return await dio.put(modifyPinEndpoint, data: formData, cancelToken: cancelToken);
            } catch (e) {
              rethrow;
            }
          }
          return checkAndRemovePin();
        }
        OptionsBuilder optionsBuilder = OptionsBuilder.multipartData();
        Options? options;
        if (modifyPinParameter is ValidateWhileLoginModifyPinParameter) {
          if (loginResponse != null) {
            optionsBuilder.withTokenHeader(loginResponse.token);
          }
          optionsBuilder.withOptionsMergeParameter(const OptionsMergeParameter());
          options = optionsBuilder.buildExtended();
        } else {
          options = optionsBuilder.build();
        }
        return dio.post(
          modifyPinEndpoint,
          data: formData,
          cancelToken: cancelToken,
          options: options,
        );
      }().map<ModifyPinResponse>(
        onMap: (value) {
          if (modifyPinParameter is CreateModifyPinParameter) {
            return value.wrapResponse().mapFromResponseToCreateModifyPinResponse();
          } else if (modifyPinParameter is ChangeModifyPinParameter) {
            return value.wrapResponse().mapFromResponseToChangeModifyPinResponse();
          } else if (modifyPinParameter is RemoveModifyPinParameter) {
            return value.wrapResponse().mapFromResponseToRemoveModifyPinResponse();
          } else if (modifyPinParameter is ValidateModifyPinParameter) {
            if (modifyPinParameter is ValidateWhileLoginModifyPinParameter) {
              if (loginResponse != null) {
                return value.wrapResponse().mapFromResponseToValidateWhileLoginModifyPinResponse(loginResponse);
              } else {
                throw Exception("Modify PIN is not suitable");
              }
            } else {
              return value.wrapResponse().mapFromResponseToValidateModifyPinResponse();
            }
          } else {
            throw Exception("Modify PIN is not suitable");
          }
        }
      );
    });
  }

  @override
  FutureProcessing<ForgotPasswordResponse> forgotPassword(ForgotPasswordParameter forgotPasswordParameter) {
    return DioHttpClientProcessing((cancelToken) {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "email": forgotPasswordParameter.email
        }
      );
      return dio.post("/create/reset-password", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<ForgotPasswordResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToForgotPasswordResponse());
    });
  }

  @override
  FutureProcessing<CheckResetPasswordResponse> checkResetPassword(CheckResetPasswordParameter checkResetPasswordParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/check/${checkResetPasswordParameter.code}/reset-password", queryParameters: {}, cancelToken: cancelToken)
        .map<CheckResetPasswordResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToCheckResetPasswordResponse());
    });
  }

  @override
  FutureProcessing<ResetPasswordResponse> resetPassword(ResetPasswordParameter resetPasswordParameter) {
    return DioHttpClientProcessing((cancelToken) {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "code": resetPasswordParameter.code,
          "new_password": resetPasswordParameter.newPassword,
          "new_password_confirmation": resetPasswordParameter.confirmNewPassword
        }
      );
      return dio.post("/update/reset-password", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<ResetPasswordResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToResetPasswordResponse());
    });
  }

  @override
  FutureProcessing<SendDeleteAccountOtpResponse> sendDeleteAccountOtp(SendDeleteAccountOtpParameter sendDeleteAccountOtpParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/send/email/account", cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<SendDeleteAccountOtpResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToSendDeleteAccountOtpResponse());
    });
  }

  @override
  FutureProcessing<VerifyDeleteAccountOtpResponse> verifyDeleteAccountOtp(VerifyDeleteAccountOtpParameter verifyDeleteAccountOtpParameter) {
    return DioHttpClientProcessing((cancelToken) {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "otp": verifyDeleteAccountOtpParameter.otp
        }
      );
      return dio.post("/send/email/account/check", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<VerifyDeleteAccountOtpResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToVerifyDeleteAccountOtpResponse());
    });
  }

  @override
  FutureProcessing<AuthIdentityResponse> authIdentity(AuthIdentityParameter authIdentityParameter) {
    String type = "";
    if (authIdentityParameter is EmailAuthIdentityParameter) {
      type = "email";
    } else if (authIdentityParameter is PhoneAuthIdentityParameter) {
      type = "phone";
    }
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/auth/identity", queryParameters: type.isNotEmptyString ? {"type": type} : null, cancelToken: cancelToken)
        .map<AuthIdentityResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAuthIdentityResponse());
    });
  }

  @override
  FutureProcessing<AuthIdentitySendVerifyOtpResponse> authIdentitySendVerifyOtp(AuthIdentitySendVerifyOtpParameter authIdentitySendVerifyOtpParameter) {
    return DioHttpClientProcessing((cancelToken) {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "credential": authIdentitySendVerifyOtpParameter.credential
        }
      );
      return dio.post("/auth/identity/send/otp", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AuthIdentitySendVerifyOtpResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAuthIdentitySendVerifyOtpResponse());
    });
  }

  @override
  FutureProcessing<AuthIdentityVerifyOtpResponse> authIdentityVerifyOtp(AuthIdentityVerifyOtpParameter authIdentityVerifyOtpParameter) {
    return DioHttpClientProcessing((cancelToken) {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "otp": authIdentityVerifyOtpParameter.otp,
          if (authIdentityVerifyOtpParameter is EmailAuthIdentityVerifyOtpParameter) "email": authIdentityVerifyOtpParameter.email
          else if (authIdentityVerifyOtpParameter is PhoneAuthIdentityVerifyOtpParameter) "phone": authIdentityVerifyOtpParameter.phone,
        }
      );
      return dio.post("/auth/identity/otp", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AuthIdentityVerifyOtpResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAuthIdentityVerifyOtpResponse());
    });
  }

  @override
  FutureProcessing<AuthIdentityChangeInputResponse> authIdentityChangeInput(AuthIdentityChangeInputParameter authIdentityChangeInputParameter) {
    return DioHttpClientProcessing((cancelToken) {
      String lastPath = "";
      Map<String, dynamic> formDataMap = {};
      if (authIdentityChangeInputParameter is EmailAuthIdentityChangeInputParameter) {
        lastPath = "/email";
        formDataMap["email"] = authIdentityChangeInputParameter.email;
      } else if (authIdentityChangeInputParameter is PhoneAuthIdentityChangeInputParameter) {
        lastPath = "/phone";
        formDataMap["phone"] = authIdentityChangeInputParameter.phone;
      }
      FormData formData = FormData.fromMap(formDataMap);
      return dio.post("/auth/identity/change$lastPath", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AuthIdentityChangeInputResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAuthIdentityChangeInputResponse());
    });
  }

  @override
  FutureProcessing<AuthIdentityChangeVerifyOtpResponse> authIdentityChangeVerifyOtp(AuthIdentityChangeVerifyOtpParameter authIdentityChangeVerifyOtpParameter) {
    return DioHttpClientProcessing((cancelToken) {
      late AuthIdentityVerifyOtpParameter authIdentityVerifyOtpParameter;
      if (authIdentityChangeVerifyOtpParameter is EmailAuthIdentityChangeVerifyOtpParameter) {
        authIdentityVerifyOtpParameter = EmailAuthIdentityVerifyOtpParameter(
          email: authIdentityChangeVerifyOtpParameter.email,
          otp: authIdentityChangeVerifyOtpParameter.otp
        );
      } else if (authIdentityChangeVerifyOtpParameter is PhoneAuthIdentityChangeVerifyOtpParameter) {
        authIdentityVerifyOtpParameter = PhoneAuthIdentityVerifyOtpParameter(
          phone: authIdentityChangeVerifyOtpParameter.phone,
          otp: authIdentityChangeVerifyOtpParameter.otp
        );
      }
      return authIdentityVerifyOtp(authIdentityVerifyOtpParameter).map(
        onMap: (value) => AuthIdentityChangeVerifyOtpResponse()
      ).future(
        parameter: cancelToken
      );
    });
  }

  @override
  FutureProcessing<AuthIdentityChangeResponse> authIdentityChange(AuthIdentityChangeParameter authIdentityChangeParameter) {
    return DioHttpClientProcessing((cancelToken) {
      FormData formData = FormData.fromMap(
        <String, dynamic> {
          "credential": authIdentityChangeParameter.credential,
          "_method": "PUT"
        }
      );
      return dio.post("/auth/identity/change", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<AuthIdentityChangeResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToAuthIdentityChangeResponse());
    });
  }
}