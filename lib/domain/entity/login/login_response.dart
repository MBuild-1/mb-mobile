class LoginResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  LoginResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}