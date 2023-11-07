class RegisterSecondStepResponse {
  String token;
  String tokenType;
  int expiresIn;

  RegisterSecondStepResponse({
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}