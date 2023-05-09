import '../../entity/delivery/delivery_review.dart';

class DeliveryReviewDummy {
  DeliveryReviewDummy();

  DeliveryReview generateShimmerDummy() {
    return DeliveryReview(
      id: "1",
      review: "",
      country: "",
      rating: 5.0,
      userName: "",
      userProfilePicture: ""
    );
  }

  DeliveryReview generateDefaultDummy() {
    return DeliveryReview(
      id: "1",
      review: "",
      country: "",
      rating: 5.0,
      userName: "",
      userProfilePicture: ""
    );
  }
}