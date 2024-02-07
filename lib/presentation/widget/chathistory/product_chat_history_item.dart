import 'package:flutter/material.dart';

import '../../../domain/entity/chat/product/get_product_message_by_user_response.dart';
import '../../../misc/constant.dart';

class ProductChatHistoryItem extends StatelessWidget {
  final GetProductMessageByUserResponseMember getProductMessageByUserResponseMember;
  final void Function(GetProductMessageByUserResponseMember)? onTap;

  const ProductChatHistoryItem({
    super.key,
    required this.getProductMessageByUserResponseMember,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap != null ? () => onTap!(getProductMessageByUserResponseMember) : null,
        child: Padding(
          padding: EdgeInsets.all(Constant.paddingListItem),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getProductMessageByUserResponseMember.productFromMessage.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                )
              ),
              if (getProductMessageByUserResponseMember.productMessageList.isNotEmpty) ...[
                const SizedBox(height: 5),
                Text(getProductMessageByUserResponseMember.productMessageList.last.message)
              ]
            ],
          ),
        )
      )
    );
  }
}