class Coupon {
  String id;
  String title;
  String code;
  String type;
  double discount;
  int minOrder;
  DateTime activePeriodStart;
  DateTime activePeriodEnd;
  int minPerUser;
  String? image;
  String? banner;
  String notes;

  Coupon({
    required this.id,
    required this.title,
    required this.code,
    required this.type,
    required this.discount,
    required this.minOrder,
    required this.activePeriodStart,
    required this.activePeriodEnd,
    required this.minPerUser,
    required this.image,
    required this.banner,
    required this.notes
  });
}