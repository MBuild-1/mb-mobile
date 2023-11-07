class RegisterFirstStepResponse {
  bool emailActive;
  bool phoneActive;
  String credential;

  RegisterFirstStepResponse({
    required this.emailActive,
    required this.phoneActive,
    required this.credential
  });
}