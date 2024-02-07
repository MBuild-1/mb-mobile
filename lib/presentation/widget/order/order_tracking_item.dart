import 'package:flutter/material.dart';
import 'package:masterbagasi/misc/ext/string_ext.dart';

import '../../../domain/entity/order/ordertracking/order_tracking.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../checklist_icon.dart';

class OrderTrackingItem extends StatelessWidget {
  final OrderTracking orderTracking;
  final bool isActive;

  const OrderTrackingItem({
    super.key,
    required this.orderTracking,
    required this.isActive
  });

  @override
  Widget build(BuildContext context) {
    Widget result = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          orderTracking.description.toStringNonNull,
          style: TextStyle(
            color: isActive ? Theme.of(context).colorScheme.primary : null,
            fontWeight: FontWeight.bold
          ),
        ),
        Text(
          orderTracking.orderTrackingLocation.orderTrackingLocationAddress.addressLocality.toStringNonNull,
          style: const TextStyle(
            fontSize: 13.0
          ),
        ),
        Builder(
          builder: (context) {
            String pieceIdString = "";
            int i = 0;
            while (i < orderTracking.pieceIdList.length) {
              String pieceId = orderTracking.pieceIdList[i];
              pieceIdString += "${i > 0 ? ", " : ""}$pieceId";
              i++;
            }
            return Text(
              pieceIdString,
              style: const TextStyle(
                fontSize: 13.0
              ),
            );
          }
        ),
        const SizedBox(height: 12.0),
        Text(
          DateUtil.standardDateFormat6.format(
            DateUtil.convertUtcOffset(
              orderTracking.timeStamp,
              DateTime.now().timeZoneOffset.inHours,
              oldUtcOffset: 0
            ),
          ),
          style: const TextStyle(
            fontSize: 13.0
          ),
        ),
        const SizedBox(height: 16.0)
      ],
    );
    double checklistIconSize = 16.0;
    double spacing = 20.0;
    double borderWidth = 1.5;
    double paddingLeft = (checklistIconSize / 2) - (borderWidth / 2.0);
    double checklistAreaWidthPlusSpacing = checklistIconSize + spacing;
    return Stack(
      children: [
        Row(
          children: [
            SizedBox(width: paddingLeft),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 1.5,
                      color: Constant.colorGrey,
                      strokeAlign: BorderSide.strokeAlignInside
                    )
                  )
                ),
                child: Row(
                  children: [
                    SizedBox(width: checklistAreaWidthPlusSpacing - borderWidth - paddingLeft),
                    Expanded(
                      child: Visibility(
                        visible: false,
                        maintainSize: true,
                        maintainAnimation: true,
                        maintainState: true,
                        child: result
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ChecklistIcon(
              size: checklistIconSize,
              color: isActive ? null : Constant.colorGrey,
              activeValue: true
            ),
            SizedBox(width: spacing),
            Expanded(
              child: Visibility(
                visible: false,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: result
              ),
            )
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(width: checklistAreaWidthPlusSpacing),
            Expanded(
              child: result
            )
          ],
        )
      ]
    );
  }
}