import 'package:flutter/material.dart';

import '../../../domain/entity/delivery/country_delivery_review.dart';
import '../profile_picture_cache_network_image.dart';

class CountryDeliveryReviewItem extends StatelessWidget {
  final CountryDeliveryReview countryDeliveryReview;

  const CountryDeliveryReviewItem({
    super.key,
    required this.countryDeliveryReview
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfilePictureCacheNetworkImage(
            profileImageUrl: countryDeliveryReview.userProfilePicture,
            dimension: 50.0,
          ),
          const SizedBox(height: 10),
          Text(countryDeliveryReview.review),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(0.0)
            ),
            child: Text(
              "${countryDeliveryReview.userName}",
              style: const TextStyle(
                color: Colors.white
              ),
            )
          )
        ],
      )
    );
  }
}