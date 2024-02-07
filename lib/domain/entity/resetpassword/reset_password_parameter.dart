class ResetPasswordParameter {
  String code;
  String newPassword;
  String confirmNewPassword;

  ResetPasswordParameter({
    required this.code,
    required this.newPassword,
    required this.confirmNewPassword
  });
}