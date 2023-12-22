import 'auth_identity_verify_otp_parameter.dart';

class EmailAuthIdentityVerifyOtpParameter extends AuthIdentityVerifyOtpParameter {
  String email;

  EmailAuthIdentityVerifyOtpParameter({
    required this.email,
    required super.otp
  });
}