import 'package:flutter/material.dart';

import '../../../../domain/entity/product/productdiscussion/product_discussion_dialog.dart';
import '../../../../misc/date_util.dart';
import '../../modified_loading_indicator.dart';
import '../../modified_vertical_divider.dart';
import '../../profile_picture_cache_network_image.dart';
import '../../tap_area.dart';

abstract class ProductDiscussionDialogItem extends StatelessWidget {
  final ProductDiscussionDialog productDiscussionDialog;
  final bool isExpanded;
  final bool isMainProductDiscussion;
  final bool isLoading;
  final void Function(ProductDiscussionDialog)? onTapProductDiscussionDialog;

  const ProductDiscussionDialogItem({
    Key? key,
    required this.productDiscussionDialog,
    required this.isExpanded,
    required this.isMainProductDiscussion,
    required this.isLoading,
    this.onTapProductDiscussionDialog
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TapArea(
      onTap: onTapProductDiscussionDialog != null ? () => onTapProductDiscussionDialog!(productDiscussionDialog) : null,
      child: Container(
        decoration: isMainProductDiscussion ? null : const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.grey)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Builder(
          builder: (_) {
            return _defaultProductDiscussionDialogContent(context);
          }
        )
      ),
    );
  }

  Widget _defaultProductDiscussionDialogContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLoading) ...[
              const SizedBox(
                width: 30.0,
                height: 30.0,
                child: ModifiedLoadingIndicator()
              ),
            ] else ...[
              ProfilePictureCacheNetworkImage(
                profileImageUrl: "",
                dimension: 30.0,
              ),
            ],
            const SizedBox(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        productDiscussionDialog.productDiscussionUser.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold
                        )
                      ),
                      const SizedBox(width: 10),
                      const ModifiedVerticalDivider(
                        lineWidth: 1,
                        lineHeight: 10,
                        lineColor: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Text(DateUtil.standardDateFormat6.format(productDiscussionDialog.discussionDate))
                    ]
                  ),
                ]
              ),
            )
          ],
        ),
        const SizedBox(height: 12.0),
        Text(
          productDiscussionDialog.discussion,
        )
      ],
    );
  }
}