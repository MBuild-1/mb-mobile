import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/notification/short_notification.dart';
import '../../../misc/constant.dart';
import '../colorful_chip.dart';
import '../modified_svg_picture.dart';

class NotificationItem extends StatelessWidget {
  final ShortNotification shortNotification;

  const NotificationItem({
    super.key,
    required this.shortNotification
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ModifiedSvgPicture.asset(Constant.vectorOrderBag, overrideDefaultColorWithSingleColor: false),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                shortNotification.orderCode.toEmptyStringNonNull,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 5),
              Text(shortNotification.message)
            ],
          ),
        ),
        const SizedBox(width: 10),
        ColorfulChip(
          text: shortNotification.subtype,
          color: Colors.grey.shade300
        ),
      ],
    );
  }
}