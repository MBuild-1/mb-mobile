import 'package:flutter/material.dart';

import '../../../domain/entity/chat/help/help_message.dart';
import '../../../domain/entity/user/user.dart';
import '../../../misc/constant.dart';

class ChatBubble extends StatelessWidget {
  final HelpMessage helpMessage;
  final User loggedUser;

  const ChatBubble({
    super.key,
    required this.helpMessage,
    required this.loggedUser
  });

  @override
  Widget build(BuildContext context) {
    bool isLoggedUser = helpMessage.userId == loggedUser.id;
    return Column(
      crossAxisAlignment: isLoggedUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        if (!isLoggedUser) ... [
          Text(helpMessage.userChat.name, style: const TextStyle(fontSize: 11)),
          const SizedBox(height: 5),
        ],
        Container(
          decoration: BoxDecoration(
            color: isLoggedUser ? Constant.colorMain : Constant.colorGrey6,
            borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.all(8),
          child: Text(
            helpMessage.message,
            style: TextStyle(
              color: isLoggedUser ? Colors.white : null
            )
          ),
        )
      ],
    );
  }
}