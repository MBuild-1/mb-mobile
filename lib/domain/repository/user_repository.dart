import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/changepassword/change_password_parameter.dart';
import '../entity/changepassword/change_password_response.dart';
import '../entity/login/login_parameter.dart';
import '../entity/login/login_response.dart';
import '../entity/login/login_with_google_parameter.dart';
import '../entity/login/login_with_google_response.dart';
import '../entity/logout/logout_parameter.dart';
import '../entity/logout/logout_response.dart';
import '../entity/pin/checkactivepin/check_active_pin_parameter.dart';
import '../entity/pin/checkactivepin/check_active_pin_response.dart';
import '../entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../entity/pin/modifypin/modifypinresponse/modify_pin_response.dart';
import '../entity/register/register_parameter.dart';
import '../entity/register/register_response.dart';
import '../entity/register/register_with_google_parameter.dart';
import '../entity/register/register_with_google_response.dart';
import '../entity/user/edituser/edit_user_parameter.dart';
import '../entity/user/edituser/edit_user_response.dart';
import '../entity/user/getuser/get_user_parameter.dart';
import '../entity/user/getuser/get_user_response.dart';

abstract class UserRepository {
  FutureProcessing<LoadDataResult<LoginResponse>> login(LoginParameter loginParameter);
  FutureProcessing<LoadDataResult<LoginWithGoogleResponse>> loginWithGoogle(LoginWithGoogleParameter loginWithGoogleParameter);
  FutureProcessing<LoadDataResult<RegisterResponse>> register(RegisterParameter registerParameter);
  FutureProcessing<LoadDataResult<RegisterWithGoogleResponse>> registerWithGoogle(RegisterWithGoogleParameter registerWithGoogleParameter);
  FutureProcessing<LoadDataResult<LogoutResponse>> logout(LogoutParameter logoutParameter);
  FutureProcessing<LoadDataResult<GetUserResponse>> getUser(GetUserParameter getUserParameter);
  FutureProcessing<LoadDataResult<EditUserResponse>> editUser(EditUserParameter editUserParameter);
  FutureProcessing<LoadDataResult<ChangePasswordResponse>> changePassword(ChangePasswordParameter changePasswordParameter);
  FutureProcessing<LoadDataResult<CheckActivePinResponse>> checkActivePin(CheckActivePinParameter checkActivePinParameter);
  FutureProcessing<LoadDataResult<ModifyPinResponse>> modifyPin(ModifyPinParameter modifyPinParameter);
}