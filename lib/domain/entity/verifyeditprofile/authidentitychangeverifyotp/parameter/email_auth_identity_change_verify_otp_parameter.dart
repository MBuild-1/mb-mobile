import 'auth_identity_change_verify_otp_parameter.dart';

class EmailAuthIdentityChangeVerifyOtpParameter extends AuthIdentityChangeVerifyOtpParameter {
  String email;

  EmailAuthIdentityChangeVerifyOtpParameter({
    required this.email,
    required super.otp
  });
}