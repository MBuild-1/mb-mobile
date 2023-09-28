import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/domain/entity/changepassword/change_password_parameter.dart';
import 'package:masterbagasi/domain/entity/changepassword/change_password_response.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

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
import '../../../domain/entity/register/register_parameter.dart';
import '../../../domain/entity/register/register_response.dart';
import '../../../domain/entity/register/register_with_google_parameter.dart';
import '../../../domain/entity/register/register_with_google_response.dart';
import '../../../domain/entity/user/edituser/edit_user_parameter.dart';
import '../../../domain/entity/user/edituser/edit_user_response.dart';
import '../../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../../domain/entity/user/getuser/get_user_response.dart';
import '../../../misc/date_util.dart';
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
        "email": loginParameter.email,
        "password": loginParameter.password
      }
    );
    return DioHttpClientProcessing((cancelToken) {
      return dio.post("/auth/login", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<LoginResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToLoginResponse());
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
      return dio.post("/auth/google", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
        .map<LoginWithGoogleResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToLoginWithGoogleResponse());
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
      return dio.post("/auth/register", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
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
      return dio.post("/auth/google", data: formData, cancelToken: cancelToken, options: OptionsBuilder.multipartData().build())
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
    return DioHttpClientProcessing((cancelToken) {
      dynamic formData = <String, dynamic>{
        if (editUserParameter.name.isNotEmptyString) "name": editUserParameter.name,
        if (editUserParameter.email.isNotEmptyString) "email": editUserParameter.email,
        if (editUserParameter.gender.isNotEmptyString) "gender": editUserParameter.gender,
        if (editUserParameter.birthDateTime != null) "date_birth": DateUtil.standardDateFormat.format(editUserParameter.birthDateTime!),
        if (editUserParameter.placeBirth.isNotEmptyString) "place_birth": editUserParameter.placeBirth,
        if (editUserParameter.phoneNumber.isNotEmptyString) "phone_number": editUserParameter.phoneNumber
      };
      return dio.put("/user/profile", data: formData, cancelToken: cancelToken)
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
          return dio.put(modifyPinEndpoint, cancelToken: cancelToken);
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
}