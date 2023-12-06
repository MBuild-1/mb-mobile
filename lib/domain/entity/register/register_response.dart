class RegisterResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  RegisterResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}