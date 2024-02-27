import '../../domain/entity/changepassword/change_password_parameter.dart';
import '../../domain/entity/changepassword/change_password_response.dart';
import '../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_parameter.dart';
import '../../domain/entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_response.dart';
import '../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_parameter.dart';
import '../../domain/entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_response.dart';
import '../../domain/entity/forgotpassword/forgot_password_parameter.dart';
import '../../domain/entity/forgotpassword/forgot_password_response.dart';
import '../../domain/entity/forgotpassword/whatsapp/whatsapp_forgot_password_parameter.dart';
import '../../domain/entity/forgotpassword/whatsapp/whatsapp_forgot_password_response.dart';
import '../../domain/entity/login/login_parameter.dart';
import '../../domain/entity/login/login_response.dart';
import '../../domain/entity/login/login_with_apple_parameter.dart';
import '../../domain/entity/login/login_with_apple_response.dart';
import '../../domain/entity/login/login_with_google_parameter.dart';
import '../../domain/entity/login/login_with_google_response.dart';
import '../../domain/entity/logout/logout_parameter.dart';
import '../../domain/entity/logout/logout_response.dart';
import '../../domain/entity/pin/checkactivepin/check_active_pin_parameter.dart';
import '../../domain/entity/pin/checkactivepin/check_active_pin_response.dart';
import '../../domain/entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../../domain/entity/pin/modifypin/modifypinresponse/modify_pin_response.dart';
import '../../domain/entity/register/register_first_step_parameter.dart';
import '../../domain/entity/register/register_first_step_response.dart';
import '../../domain/entity/register/register_parameter.dart';
import '../../domain/entity/register/register_response.dart';
import '../../domain/entity/register/register_second_step_parameter.dart';
import '../../domain/entity/register/register_second_step_response.dart';
import '../../domain/entity/register/register_with_apple_parameter.dart';
import '../../domain/entity/register/register_with_apple_response.dart';
import '../../domain/entity/register/register_with_google_parameter.dart';
import '../../domain/entity/register/register_with_google_response.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../../domain/entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../../domain/entity/register/verify_register_parameter.dart';
import '../../domain/entity/register/verify_register_response.dart';
import '../../domain/entity/resetpassword/check/check_reset_password_parameter.dart';
import '../../domain/entity/resetpassword/check/check_reset_password_response.dart';
import '../../domain/entity/resetpassword/reset_password_parameter.dart';
import '../../domain/entity/resetpassword/reset_password_response.dart';
import '../../domain/entity/user/edituser/edit_user_parameter.dart';
import '../../domain/entity/user/edituser/edit_user_response.dart';
import '../../domain/entity/user/getuser/get_user_parameter.dart';
import '../../domain/entity/user/getuser/get_user_response.dart';
import '../../domain/entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../../domain/entity/verifyeditprofile/authidentity/parameter/auth_identity_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychange/auth_identity_change_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/auth_identity_change_input_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeinput/parameter/auth_identity_change_input_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/auth_identity_change_verify_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentitychangeverifyotp/parameter/auth_identity_change_verify_otp_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_parameter.dart';
import '../../domain/entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentityverifyotp/auth_identity_verify_otp_response.dart';
import '../../domain/entity/verifyeditprofile/authidentityverifyotp/parameter/auth_identity_verify_otp_parameter.dart';
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
  FutureProcessing<LoadDataResult<LoginWithGoogleResponse>> loginWithGoogle(LoginWithGoogleParameter loginWithGoogleParameter) {
    return userDataSource.loginWithGoogle(loginWithGoogleParameter).mapToLoadDataResult<LoginWithGoogleResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<LoginWithAppleResponse>> loginWithApple(LoginWithAppleParameter loginWithAppleParameter) {
    return userDataSource.loginWithApple(loginWithAppleParameter).mapToLoadDataResult<LoginWithAppleResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RegisterResponse>> register(RegisterParameter registerParameter) {
    return userDataSource.register(registerParameter).mapToLoadDataResult<RegisterResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RegisterWithGoogleResponse>> registerWithGoogle(RegisterWithGoogleParameter registerWithGoogleParameter) {
    return userDataSource.registerWithGoogle(registerWithGoogleParameter).mapToLoadDataResult<RegisterWithGoogleResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RegisterWithAppleResponse>> registerWithApple(RegisterWithAppleParameter registerWithAppleParameter) {
    return userDataSource.registerWithApple(registerWithAppleParameter).mapToLoadDataResult<RegisterWithAppleResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<LogoutResponse>> logout(LogoutParameter logoutParameter) {
    return userDataSource.logout(logoutParameter).mapToLoadDataResult<LogoutResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<GetUserResponse>> getUser(GetUserParameter getUserParameter) {
    return userDataSource.getUser(getUserParameter).mapToLoadDataResult<GetUserResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<EditUserResponse>> editUser(EditUserParameter editUserParameter) {
    return userDataSource.editUser(editUserParameter).mapToLoadDataResult<EditUserResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ChangePasswordResponse>> changePassword(ChangePasswordParameter changePasswordParameter) {
    return userDataSource.changePassword(changePasswordParameter).mapToLoadDataResult<ChangePasswordResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<CheckActivePinResponse>> checkActivePin(CheckActivePinParameter checkActivePinParameter) {
    return userDataSource.checkActivePin(checkActivePinParameter).mapToLoadDataResult<CheckActivePinResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ModifyPinResponse>> modifyPin(ModifyPinParameter modifyPinParameter) {
    return userDataSource.modifyPin(modifyPinParameter).mapToLoadDataResult<ModifyPinResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ForgotPasswordResponse>> forgotPassword(ForgotPasswordParameter forgotPasswordParameter) {
    return userDataSource.forgotPassword(forgotPasswordParameter).mapToLoadDataResult<ForgotPasswordResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<WhatsappForgotPasswordResponse>> whatsappForgotPassword(WhatsappForgotPasswordParameter whatsappForgotPasswordParameter) {
    return userDataSource.whatsappForgotPassword(whatsappForgotPasswordParameter).mapToLoadDataResult<WhatsappForgotPasswordResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<CheckResetPasswordResponse>> checkResetPassword(CheckResetPasswordParameter checkResetPasswordParameter) {
    return userDataSource.checkResetPassword(checkResetPasswordParameter).mapToLoadDataResult<CheckResetPasswordResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<ResetPasswordResponse>> resetPassword(ResetPasswordParameter resetPasswordParameter) {
    return userDataSource.resetPassword(resetPasswordParameter).mapToLoadDataResult<ResetPasswordResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RegisterFirstStepResponse>> registerFirstStep(RegisterFirstStepParameter registerFirstStepParameter) {
    return userDataSource.registerFirstStep(registerFirstStepParameter).mapToLoadDataResult<RegisterFirstStepResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<SendRegisterOtpResponse>> sendRegisterOtp(SendRegisterOtpParameter sendRegisterOtpParameter) {
    return userDataSource.sendRegisterOtp(sendRegisterOtpParameter).mapToLoadDataResult<SendRegisterOtpResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<VerifyRegisterResponse>> verifyRegister(VerifyRegisterParameter verifyRegisterParameter) {
    return userDataSource.verifyRegister(verifyRegisterParameter).mapToLoadDataResult<VerifyRegisterResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<RegisterSecondStepResponse>> registerSecondStep(RegisterSecondStepParameter registerSecondStepParameter) {
    return userDataSource.registerSecondStep(registerSecondStepParameter).mapToLoadDataResult<RegisterSecondStepResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<SendDeleteAccountOtpResponse>> sendDeleteAccountOtp(SendDeleteAccountOtpParameter sendDeleteAccountOtpParameter) {
    return userDataSource.sendDeleteAccountOtp(sendDeleteAccountOtpParameter).mapToLoadDataResult<SendDeleteAccountOtpResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<VerifyDeleteAccountOtpResponse>> verifyDeleteAccountOtp(VerifyDeleteAccountOtpParameter verifyDeleteAccountOtpParameter) {
    return userDataSource.verifyDeleteAccountOtp(verifyDeleteAccountOtpParameter).mapToLoadDataResult<VerifyDeleteAccountOtpResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<AuthIdentityResponse>> authIdentity(AuthIdentityParameter authIdentityParameter) {
    return userDataSource.authIdentity(authIdentityParameter).mapToLoadDataResult<AuthIdentityResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<AuthIdentitySendVerifyOtpResponse>> authIdentitySendVerifyOtp(AuthIdentitySendVerifyOtpParameter authIdentitySendVerifyOtpParameter) {
    return userDataSource.authIdentitySendVerifyOtp(authIdentitySendVerifyOtpParameter).mapToLoadDataResult<AuthIdentitySendVerifyOtpResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<AuthIdentityVerifyOtpResponse>> authIdentityVerifyOtp(AuthIdentityVerifyOtpParameter authIdentityVerifyOtpParameter) {
    return userDataSource.authIdentityVerifyOtp(authIdentityVerifyOtpParameter).mapToLoadDataResult<AuthIdentityVerifyOtpResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<AuthIdentityChangeInputResponse>> authIdentityChangeInput(AuthIdentityChangeInputParameter authIdentityChangeInputParameter) {
    return userDataSource.authIdentityChangeInput(authIdentityChangeInputParameter).mapToLoadDataResult<AuthIdentityChangeInputResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<AuthIdentityChangeVerifyOtpResponse>> authIdentityChangeVerifyOtp(AuthIdentityChangeVerifyOtpParameter authIdentityChangeVerifyOtpParameter) {
    return userDataSource.authIdentityChangeVerifyOtp(authIdentityChangeVerifyOtpParameter).mapToLoadDataResult<AuthIdentityChangeVerifyOtpResponse>();
  }

  @override
  FutureProcessing<LoadDataResult<AuthIdentityChangeResponse>> authIdentityChange(AuthIdentityChangeParameter authIdentityChangeParameter) {
    return userDataSource.authIdentityChange(authIdentityChangeParameter).mapToLoadDataResult<AuthIdentityChangeResponse>();
  }
}