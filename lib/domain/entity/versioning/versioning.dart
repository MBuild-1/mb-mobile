class Versioning {
  String id;
  String version;
  String? buildNumber;
  int appleLogin;
  int googleLogin;
  int mustBeUpdatedToNewerVersion;
  int isLatest;

  Versioning({
    required this.id,
    required this.version,
    required this.buildNumber,
    required this.appleLogin,
    required this.googleLogin,
    required this.mustBeUpdatedToNewerVersion,
    required this.isLatest
  });
}