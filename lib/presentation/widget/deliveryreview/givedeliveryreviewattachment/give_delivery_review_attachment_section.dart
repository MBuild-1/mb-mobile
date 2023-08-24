import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'give_delivery_review_attachment_carousel.dart';

class GiveDeliveryReviewAttachmentSection extends StatelessWidget {
  final List<PlatformFile> Function() onGetPlatformFileList;
  final void Function() onSetState;

  const GiveDeliveryReviewAttachmentSection({
    super.key,
    required this.onGetPlatformFileList,
    required this.onSetState
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        List<PlatformFile> platformFileList = onGetPlatformFileList();
        if (platformFileList.isNotEmpty) {
          return Column(
            children: [
              const SizedBox(height: 10),
              GiveDeliveryReviewAttachmentCarousel(
                giveDeliveryReviewAttachmentFileList: platformFileList,
                onRemoveAttachmentItem: (platformFile) {
                  platformFileList.remove(platformFile);
                  onSetState();
                }
              )
            ]
          );
        } else {
          return Container();
        }
      }
    );
  }
}