import '../reset_password_parameter.dart';

class WhatsappResetPasswordParameter extends ResetPasswordParameter {
  WhatsappResetPasswordParameter({
    required super.code,
    required super.newPassword,
    required super.confirmNewPassword
  });
}