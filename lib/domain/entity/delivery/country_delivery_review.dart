import 'countrydeliveryreviewmedia/country_delivery_review_media.dart';

class CountryDeliveryReview {
  String id;
  String? userProfilePicture;
  String userName;
  int userReviewCount;
  double rating;
  String review;
  DateTime reviewDate;
  List<CountryDeliveryReviewMedia> countryDeliveryReviewMedia;

  CountryDeliveryReview({
    required this.id,
    required this.userProfilePicture,
    required this.userName,
    required this.userReviewCount,
    required this.rating,
    required this.review,
    required this.reviewDate,
    required this.countryDeliveryReviewMedia
  });
}