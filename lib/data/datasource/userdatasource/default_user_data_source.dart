import 'package:dio/dio.dart';
import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/future_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';

import '../../../domain/entity/login/login_parameter.dart';
import '../../../domain/entity/login/login_response.dart';
import '../../../domain/entity/register/register_parameter.dart';
import '../../../domain/entity/register/register_response.dart';
import '../../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../../domain/entity/user/getuser/get_user_response.dart';
import '../../../misc/option_builder.dart';
import '../../../misc/processing/dio_http_client_processing.dart';
import '../../../misc/processing/future_processing.dart';
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
  FutureProcessing<GetUserResponse> getUser(GetUserParameter getUserParameter) {
    return DioHttpClientProcessing((cancelToken) {
      return dio.get("/auth/me", cancelToken: cancelToken)
        .map<GetUserResponse>(onMap: (value) => value.wrapResponse().mapFromResponseToGetUserResponse());
    });
  }
}