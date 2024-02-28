class VersioningBasedFilterParameter {
  String? version;
  int? buildNumber;

  VersioningBasedFilterParameter({
    required this.version,
    this.buildNumber
  });
}