class ProvinceMapMetadata {
  String id;
  String provinceId;
  String svg;

  ProvinceMapMetadata({
    required this.id,
    required this.provinceId,
    required this.svg
  });
}

class NotIncludedProvinceMapMetadata extends ProvinceMapMetadata {
  NotIncludedProvinceMapMetadata() : super(
    id: "",
    provinceId: "",
    svg: ""
  );
}