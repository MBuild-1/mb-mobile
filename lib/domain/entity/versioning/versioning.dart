class Versioning {
  String id;
  String version;
  String? buildNumber;
  int appleLogin;
  int mustBeUpdatedToNewerVersion;

  Versioning({
    required this.id,
    required this.version,
    required this.buildNumber,
    required this.appleLogin,
    required this.mustBeUpdatedToNewerVersion
  });
}