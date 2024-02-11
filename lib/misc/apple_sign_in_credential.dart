class AppleSignInCredential {
  String? identityToken;
  String authorizationCode;

  AppleSignInCredential({
    required this.identityToken,
    required this.authorizationCode
  });
}