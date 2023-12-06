class RegisterWithGoogleResponse {
  String userId;
  String token;
  String tokenType;
  int expiresIn;

  RegisterWithGoogleResponse({
    required this.userId,
    required this.token,
    required this.tokenType,
    required this.expiresIn
  });
}