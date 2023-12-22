import 'auth_identity_change_verify_otp_parameter.dart';

class PhoneAuthIdentityChangeVerifyOtpParameter extends AuthIdentityChangeVerifyOtpParameter {
  String phone;

  PhoneAuthIdentityChangeVerifyOtpParameter({
    required this.phone,
    required super.otp
  });
}