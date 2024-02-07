import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/notification/short_notification.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../colorful_chip.dart';
import '../modified_svg_picture.dart';

class NotificationItem extends StatelessWidget {
  final ShortNotification shortNotification;
  final void Function(ShortNotification)? onTap;

  const NotificationItem({
    super.key,
    required this.shortNotification,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8.0),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap!(shortNotification) : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey.shade400)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ModifiedSvgPicture.asset(Constant.vectorOrderBag, overrideDefaultColorWithSingleColor: false),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "${shortNotification.subtype}${shortNotification.createdDate != null ? " - ${DateUtil.standardDateFormat4.format(shortNotification.createdDate!)}" : ""}",
                            style: const TextStyle(
                              color: Colors.grey
                            )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      shortNotification.title.toEmptyStringNonNull,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold
                      )
                    ),
                    if (shortNotification.orderCode.isNotEmptyString) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Constant.colorLightBlue,
                        ),
                        child: Text(
                          shortNotification.orderCode.toEmptyStringNonNull,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Constant.colorDarkBlue2
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 6),
                    Text(shortNotification.message)
                  ],
                ),
              ),
              if (shortNotification.isRead == 0) ...[
                const SizedBox(width: 10),
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Constant.colorRedDanger,
                    shape: BoxShape.circle
                  ),
                )
              ]
            ],
          ),
        )
      )
    );
  }
}