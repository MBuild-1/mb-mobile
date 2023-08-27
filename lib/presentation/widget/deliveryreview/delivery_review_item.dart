import 'package:flag/flag_widget.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/delivery/delivery_review.dart';
import '../../../misc/constant.dart';
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
      height: 240,
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 100,
                    child: Stack(
                      children: [
                        Center(
                          child: ProfilePictureCacheNetworkImage(
                            profileImageUrl: deliveryReview.userProfilePicture,
                            dimension: 100.0,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            width: 50,
                            height: 50,
                            clipBehavior: Clip.antiAlias,
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle
                            ),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                child: Flag.fromString(
                                  deliveryReview.countryCode
                                )
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 18,
                                height: 18,
                                child: FittedBox(
                                  child: Image.asset(Constant.imageStar),
                                )
                              ),
                              const SizedBox(width: 5),
                              Text(
                                "${deliveryReview.rating}",
                                style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    deliveryReview.review,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: borderRadius
                    ),
                    child: Text(
                      "${deliveryReview.userName} - ${deliveryReview.country}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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