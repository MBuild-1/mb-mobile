import 'package:flutter/material.dart';

import '../../../domain/entity/delivery/delivery_review.dart';
import '../profile_picture_cache_network_image.dart';

abstract class DeliveryReviewItem extends StatelessWidget {
  final DeliveryReview deliveryReview;

  @protected
  double? get itemWidth;

  const DeliveryReviewItem({
    Key? key,
    required this.deliveryReview
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BorderRadius borderRadius = BorderRadius.circular(8.0);
    return SizedBox(
      width: itemWidth,
      child: Padding(
        // Use padding widget for avoiding shadow elevation overlap.
        padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
        child: Material(
          color: Colors.grey.shade100,
          borderRadius: borderRadius,
          elevation: 3,
          child: InkWell(
            borderRadius: borderRadius,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: borderRadius
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfilePictureCacheNetworkImage(
                    profileImageUrl: deliveryReview.userProfilePicture,
                    dimension: 50.0,
                  ),
                  const SizedBox(height: 10),
                  Text(deliveryReview.review),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: borderRadius
                    ),
                    child: Text(
                      "${deliveryReview.userName} - ${deliveryReview.country}",
                      style: const TextStyle(
                        color: Colors.white
                      ),
                    )
                  )
                ],
              )
            )
          )
        ),
      )
    );
  }
}