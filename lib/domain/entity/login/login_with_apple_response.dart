class LoginWithAppleResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  LoginWithAppleResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}