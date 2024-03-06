import '../../misc/load_data_result.dart';
import '../../misc/processing/future_processing.dart';
import '../entity/changepassword/change_password_parameter.dart';
import '../entity/changepassword/change_password_response.dart';
import '../entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_parameter.dart';
import '../entity/deleteaccount/senddeleteaccountotp/send_delete_account_otp_response.dart';
import '../entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_parameter.dart';
import '../entity/deleteaccount/verifydeleteaccountotp/verify_delete_account_otp_response.dart';
import '../entity/forgotpassword/forgot_password_parameter.dart';
import '../entity/forgotpassword/forgot_password_response.dart';
import '../entity/forgotpassword/whatsapp/whatsapp_forgot_password_parameter.dart';
import '../entity/forgotpassword/whatsapp/whatsapp_forgot_password_response.dart';
import '../entity/login/login_parameter.dart';
import '../entity/login/login_response.dart';
import '../entity/login/login_with_apple_parameter.dart';
import '../entity/login/login_with_apple_response.dart';
import '../entity/login/login_with_google_parameter.dart';
import '../entity/login/login_with_google_response.dart';
import '../entity/loginorregister/login_or_register_with_apple_via_callback_parameter.dart';
import '../entity/loginorregister/login_or_register_with_apple_via_callback_response.dart';
import '../entity/logout/logout_parameter.dart';
import '../entity/logout/logout_response.dart';
import '../entity/pin/checkactivepin/check_active_pin_parameter.dart';
import '../entity/pin/checkactivepin/check_active_pin_response.dart';
import '../entity/pin/modifypin/modifypinparameter/modify_pin_parameter.dart';
import '../entity/pin/modifypin/modifypinresponse/modify_pin_response.dart';
import '../entity/register/register_first_step_parameter.dart';
import '../entity/register/register_first_step_response.dart';
import '../entity/register/register_parameter.dart';
import '../entity/register/register_response.dart';
import '../entity/register/register_second_step_parameter.dart';
import '../entity/register/register_second_step_response.dart';
import '../entity/register/register_with_apple_parameter.dart';
import '../entity/register/register_with_apple_response.dart';
import '../entity/register/register_with_google_parameter.dart';
import '../entity/register/register_with_google_response.dart';
import '../entity/register/sendregisterotp/sendregisterotpparameter/send_register_otp_parameter.dart';
import '../entity/register/sendregisterotp/sendregisterotpresponse/send_register_otp_response.dart';
import '../entity/register/verify_register_parameter.dart';
import '../entity/register/verify_register_response.dart';
import '../entity/resetpassword/check/check_reset_password_parameter.dart';
import '../entity/resetpassword/check/check_reset_password_response.dart';
import '../entity/resetpassword/reset_password_parameter.dart';
import '../entity/resetpassword/reset_password_response.dart';
import '../entity/user/edituser/edit_user_parameter.dart';
import '../entity/user/edituser/edit_user_response.dart';
import '../entity/user/getuser/get_user_parameter.dart';
import '../entity/user/getuser/get_user_response.dart';
import '../entity/verifyeditprofile/authidentity/auth_identity_response.dart';
import '../entity/verifyeditprofile/authidentity/parameter/auth_identity_parameter.dart';
import '../entity/verifyeditprofile/authidentitychange/auth_identity_change_parameter.dart';
import '../entity/verifyeditprofile/authidentitychange/auth_identity_change_response.dart';
import '../entity/verifyeditprofile/authidentitychangeinput/auth_identity_change_input_response.dart';
import '../entity/verifyeditprofile/authidentitychangeinput/parameter/auth_identity_change_input_parameter.dart';
import '../entity/verifyeditprofile/authidentitychangeverifyotp/auth_identity_change_verify_otp_response.dart';
import '../entity/verifyeditprofile/authidentitychangeverifyotp/parameter/auth_identity_change_verify_otp_parameter.dart';
import '../entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_parameter.dart';
import '../entity/verifyeditprofile/authidentitysendotp/auth_identity_send_otp_response.dart';
import '../entity/verifyeditprofile/authidentityverifyotp/auth_identity_verify_otp_response.dart';
import '../entity/verifyeditprofile/authidentityverifyotp/parameter/auth_identity_verify_otp_parameter.dart';

abstract class UserRepository {
  FutureProcessing<LoadDataResult<LoginResponse>> login(LoginParameter loginParameter);
  FutureProcessing<LoadDataResult<LoginWithGoogleResponse>> loginWithGoogle(LoginWithGoogleParameter loginWithGoogleParameter);
  FutureProcessing<LoadDataResult<LoginWithAppleResponse>> loginWithApple(LoginWithAppleParameter loginWithAppleParameter);
  FutureProcessing<LoadDataResult<RegisterResponse>> register(RegisterParameter registerParameter);
  FutureProcessing<LoadDataResult<RegisterWithGoogleResponse>> registerWithGoogle(RegisterWithGoogleParameter registerWithGoogleParameter);
  FutureProcessing<LoadDataResult<RegisterWithAppleResponse>> registerWithApple(RegisterWithAppleParameter registerWithAppleParameter);
  FutureProcessing<LoadDataResult<LogoutResponse>> logout(LogoutParameter logoutParameter);
  FutureProcessing<LoadDataResult<GetUserResponse>> getUser(GetUserParameter getUserParameter);
  FutureProcessing<LoadDataResult<EditUserResponse>> editUser(EditUserParameter editUserParameter);
  FutureProcessing<LoadDataResult<ChangePasswordResponse>> changePassword(ChangePasswordParameter changePasswordParameter);
  FutureProcessing<LoadDataResult<CheckActivePinResponse>> checkActivePin(CheckActivePinParameter checkActivePinParameter);
  FutureProcessing<LoadDataResult<ModifyPinResponse>> modifyPin(ModifyPinParameter modifyPinParameter);
  FutureProcessing<LoadDataResult<ForgotPasswordResponse>> forgotPassword(ForgotPasswordParameter forgotPasswordParameter);
  FutureProcessing<LoadDataResult<WhatsappForgotPasswordResponse>> whatsappForgotPassword(WhatsappForgotPasswordParameter whatsappForgotPasswordParameter);
  FutureProcessing<LoadDataResult<CheckResetPasswordResponse>> checkResetPassword(CheckResetPasswordParameter checkResetPasswordParameter);
  FutureProcessing<LoadDataResult<ResetPasswordResponse>> resetPassword(ResetPasswordParameter resetPasswordParameter);
  FutureProcessing<LoadDataResult<RegisterFirstStepResponse>> registerFirstStep(RegisterFirstStepParameter registerFirstStepParameter);
  FutureProcessing<LoadDataResult<SendRegisterOtpResponse>> sendRegisterOtp(SendRegisterOtpParameter sendRegisterOtpParameter);
  FutureProcessing<LoadDataResult<VerifyRegisterResponse>> verifyRegister(VerifyRegisterParameter verifyRegisterParameter);
  FutureProcessing<LoadDataResult<RegisterSecondStepResponse>> registerSecondStep(RegisterSecondStepParameter registerSecondStepParameter);
  FutureProcessing<LoadDataResult<SendDeleteAccountOtpResponse>> sendDeleteAccountOtp(SendDeleteAccountOtpParameter sendDeleteAccountOtpParameter);
  FutureProcessing<LoadDataResult<VerifyDeleteAccountOtpResponse>> verifyDeleteAccountOtp(VerifyDeleteAccountOtpParameter verifyDeleteAccountOtpParameter);
  FutureProcessing<LoadDataResult<AuthIdentityResponse>> authIdentity(AuthIdentityParameter authIdentityParameter);
  FutureProcessing<LoadDataResult<AuthIdentitySendVerifyOtpResponse>> authIdentitySendVerifyOtp(AuthIdentitySendVerifyOtpParameter authIdentitySendVerifyOtpParameter);
  FutureProcessing<LoadDataResult<AuthIdentityVerifyOtpResponse>> authIdentityVerifyOtp(AuthIdentityVerifyOtpParameter authIdentityVerifyOtpParameter);
  FutureProcessing<LoadDataResult<AuthIdentityChangeInputResponse>> authIdentityChangeInput(AuthIdentityChangeInputParameter authIdentityChangeInputParameter);
  FutureProcessing<LoadDataResult<AuthIdentityChangeVerifyOtpResponse>> authIdentityChangeVerifyOtp(AuthIdentityChangeVerifyOtpParameter authIdentityChangeVerifyOtpParameter);
  FutureProcessing<LoadDataResult<AuthIdentityChangeResponse>> authIdentityChange(AuthIdentityChangeParameter authIdentityChangeParameter);
  FutureProcessing<LoadDataResult<LoginOrRegisterWithAppleViaCallbackResponse>> loginOrRegisterWithAppleViaCallback(LoginOrRegisterWithAppleViaCallbackParameter loginOrRegisterWithAppleViaCallbackParameter);
}