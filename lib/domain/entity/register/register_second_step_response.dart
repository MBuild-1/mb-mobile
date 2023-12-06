class RegisterSecondStepResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  RegisterSecondStepResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}