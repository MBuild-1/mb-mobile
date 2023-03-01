import '../../domain/entity/login/login_parameter.dart';
import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/register/register_parameter.dart';
import '../../domain/entity/register/register_response.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/getuser/get_user_response.dart';
import '../../domain/repository/user_repository.dart';
import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../datasource/userdatasource/user_data_source.dart';

class DefaultUserRepository implements UserRepository {
  final UserDataSource userDataSource;

  const DefaultUserRepository({
    required this.userDataSource
  });

  @override
  FutureProcessing<LoadDataResult<LoginResponse>> login(LoginParameter loginParameter) {
    return userDataSource.login(loginParameter).mapToLoadDataResult<LoginResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RegisterResponse>> register(RegisterParameter registerParameter) {
    return userDataSource.register(registerParameter).mapToLoadDataResult<RegisterResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetUserResponse>> getUser(GetUserParameter getUserParameter) {
    return userDataSource.getUser(getUserParameter).mapToLoadDataResult<GetUserResponse>();
  }
}