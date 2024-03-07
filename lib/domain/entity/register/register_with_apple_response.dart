class RegisterWithAppleResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  RegisterWithAppleResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}