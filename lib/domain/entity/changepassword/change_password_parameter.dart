class ChangePasswordParameter {
  String currentPassword;
  String newPassword;
  String confirmNewPassword;

  ChangePasswordParameter({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword
  });
}