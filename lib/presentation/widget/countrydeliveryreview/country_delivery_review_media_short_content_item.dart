import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../misc/constant.dart';
import '../modified_shimmer.dart';

class ShimmerCountryDeliveryReviewMediaShortContentItem extends StatelessWidget {
  const ShimmerCountryDeliveryReviewMediaShortContentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ModifiedShimmer.fromColors(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Constant.paddingListItem, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    "Sample Photo & Video",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.black
                    )
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "More".tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    backgroundColor: Colors.black
                  )
                ),
              ],
            ),
            const SizedBox(height: 10),
            Builder(
              builder: (context) {
                int length = 5;
                return Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  children: [
                    ...List.generate(length, (index) => 1).map<Widget>(
                      (value) {
                        double totalGapWidth = 8 * (length - 1) + Constant.paddingListItem * 2;
                        double size = (MediaQuery.of(context).size.width - totalGapWidth) / length;
                        return Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                        );
                      }
                    )
                  ],
                );
              }
            )
          ]
        ),
      )
    );
  }
}

class CountryDeliveryReviewMediaShortContentItem extends StatelessWidget {
  const CountryDeliveryReviewMediaShortContentItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}