import '../../../domain/entity/login/login_parameter.dart';
import '../../../domain/entity/login/login_response.dart';
import '../../../domain/entity/register/register_parameter.dart';
import '../../../domain/entity/register/register_response.dart';
import '../../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../../domain/entity/user/getuser/get_user_response.dart';
import '../../../misc/processing/future_processing.dart';

abstract class UserDataSource {
  FutureProcessing<LoginResponse> login(LoginParameter loginParameter);
  FutureProcessing<RegisterResponse> register(RegisterParameter registerParameter);
  FutureProcessing<GetUserResponse> getUser(GetUserParameter getUserParameter);
}