class VersioningBasedFilterParameter {
  String? version;
  int? buildNumber;
  String? deviceName;

  VersioningBasedFilterParameter({
    required this.version,
    this.buildNumber,
    this.deviceName
  });
}