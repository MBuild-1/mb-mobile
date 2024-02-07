class RegisterSecondStepParameter {
  String credential;
  String name;
  String password;
  String passwordConfirmation;
  String pushNotificationSubscriptionId;
  String gender;

  RegisterSecondStepParameter({
    required this.credential,
    required this.name,
    required this.password,
    required this.passwordConfirmation,
    required this.pushNotificationSubscriptionId,
    required this.gender
  });
}