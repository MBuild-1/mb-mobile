import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/delivery/countrydeliveryreviewmedia/country_delivery_review_media.dart';
import '../../../misc/constant.dart';
import '../modifiedcachednetworkimage/country_delivery_review_modified_cached_network_image.dart';

class CountryDeliveryReviewMediaShortContentDetailItem extends StatelessWidget {
  final List<CountryDeliveryReviewMedia> countryDeliveryReviewMediaList;
  final bool showAll;

  const CountryDeliveryReviewMediaShortContentDetailItem({
    super.key,
    required this.countryDeliveryReviewMediaList,
    this.showAll = false
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        int length = 5;
        return Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            ...(showAll ? countryDeliveryReviewMediaList : countryDeliveryReviewMediaList.take(5)).map<Widget>(
              (value) {
                double totalGapWidth = 8 * (length - 1) + Constant.paddingListItem * 2;
                double size = (MediaQuery.of(context).size.width - totalGapWidth) / length;
                return Container(
                  width: size,
                  height: size,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0)
                  ),
                  child: CountryDeliveryReviewModifiedCachedNetworkImage(
                    imageUrl: value.thumbnailUrl.toEmptyStringNonNull,
                  ),
                );
              }
            )
          ],
        );
      }
    );
  }
}