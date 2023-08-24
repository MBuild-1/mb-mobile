import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../misc/constant.dart';
import 'give_delivery_review_attachment_item.dart';

class GiveDeliveryReviewAttachmentCarousel extends StatelessWidget {
  final List<PlatformFile> giveDeliveryReviewAttachmentFileList;
  final void Function(PlatformFile) onRemoveAttachmentItem;

  const GiveDeliveryReviewAttachmentCarousel({
    super.key,
    required this.giveDeliveryReviewAttachmentFileList,
    required this.onRemoveAttachmentItem
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Builder(
        builder: (context) {
          List<Widget> itemMap = [];
          int i = 0;
          while (i < giveDeliveryReviewAttachmentFileList.length) {
            if (i > 0) {
              itemMap.add(SizedBox(width: 3.w));
            }
            itemMap.add(
              GiveDeliveryReviewAttachmentItem(
                onRemoveAttachmentItem: onRemoveAttachmentItem,
                platformFile: giveDeliveryReviewAttachmentFileList[i]
              )
            );
            i++;
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: itemMap,
          );
        },
      )
    );
  }
}