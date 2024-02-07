import 'auth_identity_verify_otp_parameter.dart';

class PhoneAuthIdentityVerifyOtpParameter extends AuthIdentityVerifyOtpParameter {
  String phone;

  PhoneAuthIdentityVerifyOtpParameter({
    required this.phone,
    required super.otp
  });
}