import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';
import 'dart:math' as math;

import '../../../misc/constant.dart';
import '../modified_svg_picture.dart';
import '../tap_area.dart';
import 'profile_menu_in_card_item.dart';

class ProfileMenuInCardGroup extends StatelessWidget {
  final String? title;
  final bool isExpand;
  final void Function()? onExpand;
  final List<ProfileMenuInCardItem> profileMenuInCardItemList;

  const ProfileMenuInCardGroup({
    super.key,
    this.title,
    required this.isExpand,
    required this.onExpand,
    required this.profileMenuInCardItemList
  });

  @override
  Widget build(BuildContext context) {
    bool isNotEmptyStringTitleAndCanExpand = title.isNotEmptyString && onExpand != null;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          if (isNotEmptyStringTitleAndCanExpand) ...[
            const SizedBox(height: 12.0),
          ],
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 22.0),
            child: Builder(
              builder: (context) {
                Widget result = Row(
                  children: [
                    if (title.isNotEmptyString) ...[
                      Expanded(
                        child: Text(
                          title!,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        )
                      )
                    ],
                    if (isNotEmptyStringTitleAndCanExpand) ...[
                      Transform.rotate(
                        angle: !isExpand ? math.pi / 2 : -math.pi / 2,
                        child: ModifiedSvgPicture.asset(
                          Constant.vectorArrow,
                          color: Constant.colorGrey3,
                          height: 12,
                        )
                      ),
                    ]
                  ]
                );
                return onExpand != null ? TapArea(
                  onTap: onExpand,
                  child: result,
                ) : result;
              }
            ),
          ),
          if (isNotEmptyStringTitleAndCanExpand) ...[
            SizedBox(height: isExpand ? 8.0 : 12.0),
          ],
          if (isExpand) ...[
            ...profileMenuInCardItemList
          ]
        ]
      )
    );
  }
}