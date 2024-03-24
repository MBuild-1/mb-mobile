class RegisterSecondStepParameter {
  String credential;
  String username;
  String name;
  String password;
  String passwordConfirmation;
  String pushNotificationSubscriptionId;
  String gender;

  RegisterSecondStepParameter({
    required this.credential,
    required this.username,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
    required this.pushNotificationSubscriptionId,
    required this.gender
  });
}