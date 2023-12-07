class Coupon {
  String id;
  String? userProfessionId;
  int active;
  int needVerify;
  String title;
  String code;
  DateTime startPeriod;
  DateTime endPeriod;
  int quota;
  String? imageMobile;
  String? imageDesktop;
  String? bannerDesktop;
  String? bannerMobile;

  Coupon({
    required this.id,
    required this.userProfessionId,
    required this.active,
    required this.needVerify,
    required this.title,
    required this.code,
    required this.startPeriod,
    required this.endPeriod,
    required this.quota,
    required this.imageMobile,
    required this.imageDesktop,
    required this.bannerDesktop,
    required this.bannerMobile,
  });
}