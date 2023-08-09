import 'package:masterbagasi/data/entitymappingext/address_entity_mapping_ext.dart';
import 'package:masterbagasi/data/entitymappingext/user_entity_mapping_ext.dart';
import 'package:masterbagasi/misc/ext/response_wrapper_ext.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../domain/entity/address/country.dart';
import '../../domain/entity/delivery/delivery_review.dart';
import '../../domain/entity/user/user.dart';
import '../../misc/response_wrapper.dart';

extension DeliveryReviewEntityMappingExt on ResponseWrapper {
  List<DeliveryReview> mapFromResponseToDeliveryReviewList() {
    return response.map<DeliveryReview>((deliveryReviewResponse) => ResponseWrapper(deliveryReviewResponse).mapFromResponseToDeliveryReview()).toList();
  }
}

extension DeliveryReviewDetailEntityMappingExt on ResponseWrapper {
  DeliveryReview mapFromResponseToDeliveryReview() {
    String name = "";
    String avatar = "";
    String countryId = "";
    String countryCode = "";
    String countryName = "";
    if (response["user"] != null) {
      User user = ResponseWrapper(response["user"]).mapFromResponseToUser();
      name = user.name;
      avatar = user.userProfile.avatar.toEmptyStringNonNull;
    } else {
      name = response["name"];
      avatar = response["avatar"];
    }
    if (response["country"] != null) {
      dynamic countryResponse = response["country"];
      countryId = countryResponse["id"];
      countryCode = countryResponse["code"];
      countryName = countryResponse["name"];
    } else {
      countryId = response["country_id"];
      countryCode = response["country_code"];
      countryName = response["country_name"];
    }
    return DeliveryReview(
      id: "1",
      userName: name,
      userProfilePicture: avatar,
      productImageUrl: "",
      productName: "",
      rating: ResponseWrapper(response["rating"]).mapFromResponseToDouble()!,
      country: countryName,
      countryCode: countryCode,
      review: response["message"],
      reviewDate: ResponseWrapper(response["created_at"]).mapFromResponseToDateTime()!,
    );
  }
}