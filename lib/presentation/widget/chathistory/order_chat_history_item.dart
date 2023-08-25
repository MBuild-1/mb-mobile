import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entity/chat/order/get_order_message_by_user_response.dart';
import '../../../misc/constant.dart';

class OrderChatHistoryItem extends StatelessWidget {
  final GetOrderMessageByUserResponseMember getOrderMessageByUserResponseMember;
  final void Function(GetOrderMessageByUserResponseMember)? onTap;

  const OrderChatHistoryItem({
    super.key,
    required this.getOrderMessageByUserResponseMember,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap!(getOrderMessageByUserResponseMember) : null,
        child: Padding(
          padding: EdgeInsets.all(Constant.paddingListItem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getOrderMessageByUserResponseMember.order.orderCode,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              if (getOrderMessageByUserResponseMember.orderMessageList.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(getOrderMessageByUserResponseMember.orderMessageList.last.message)
              ] else ...[
                const SizedBox(height: 5),
                Text("Please Start Conversation".tr)
              ]
            ],
          ),
        )
      )
    );
  }
}