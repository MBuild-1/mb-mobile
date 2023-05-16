class DeliveryReview {
  String id;
  String? userProfilePicture;
  String userName;
  String? productImageUrl;
  String productName;
  double rating;
  String country;
  String review;
  DateTime reviewDate;

  DeliveryReview({
    required this.id,
    required this.userProfilePicture,
    required this.userName,
    required this.productImageUrl,
    required this.productName,
    required this.rating,
    required this.country,
    required this.review,
    required this.reviewDate
  });
}