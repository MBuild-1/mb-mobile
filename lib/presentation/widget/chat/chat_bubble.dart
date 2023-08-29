import 'package:flutter/material.dart';

import '../../../domain/entity/chat/help/help_message.dart';
import '../../../domain/entity/chat/user_message.dart';
import '../../../domain/entity/user/user.dart';
import '../../../misc/constant.dart';
import '../../../misc/date_util.dart';
import '../modified_loading_indicator.dart';

class ChatBubble extends StatelessWidget {
  final UserMessage userMessage;
  final User loggedUser;

  const ChatBubble({
    super.key,
    required this.userMessage,
    required this.loggedUser
  });

  @override
  Widget build(BuildContext context) {
    bool isLoggedUser = userMessage.userId == loggedUser.id;
    return Column(
      crossAxisAlignment: isLoggedUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isLoggedUser) ...[
          Text(userMessage.userChat.name, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 5),
        ],
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Builder(
              builder: (context) {
                List<Widget> rowWidget = [];
                if (isLoggedUser && userMessage.isLoading) {
                  rowWidget.addAll(<Widget>[
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3.0),
                      child: SizedBox(
                        width: 14.0,
                        height: 14.0,
                        child: ModifiedLoadingIndicator()
                      ),
                    ),
                    const SizedBox(width: 10),
                  ]);
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: rowWidget
                );
              }
            ),
            Container(
              decoration: BoxDecoration(
                color: isLoggedUser ? Constant.colorMain : Constant.colorGrey6,
                borderRadius: BorderRadius.circular(8)
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: isLoggedUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userMessage.message,
                    style: TextStyle(
                      color: isLoggedUser ? Colors.white : null
                    )
                  ),
                  if (userMessage.createdAt != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      DateUtil.standardDateFormat10.format(userMessage.createdAt!),
                      style: TextStyle(
                        color: isLoggedUser ? Colors.white : null,
                        fontSize: 11
                      )
                    ),
                  ]
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}