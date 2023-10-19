class RegisterParameter {
  String name;
  String email;
  String password;
  String passwordConfirmation;
  String pushNotificationSubscriptionId;

  RegisterParameter({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.pushNotificationSubscriptionId
  });
}