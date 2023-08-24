import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../tap_area.dart';

class GiveDeliveryReviewAttachmentItem extends StatelessWidget {
  final PlatformFile platformFile;
  final void Function(PlatformFile) onRemoveAttachmentItem;

  const GiveDeliveryReviewAttachmentItem({
    super.key,
    required this.platformFile,
    required this.onRemoveAttachmentItem
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all()
      ),
      child: Column(
        children: [
          const Icon(Icons.file_present),
          const SizedBox(height: 5),
          Text(platformFile.name),
          const SizedBox(height: 5),
          TapArea(
            onTap: () => onRemoveAttachmentItem(platformFile),
            child: Text(
              "Remove".tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold
              )
            )
          ),
        ],
      )
    );
  }
}