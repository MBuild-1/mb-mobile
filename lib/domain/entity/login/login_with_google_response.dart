class LoginWithGoogleResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  LoginWithGoogleResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}