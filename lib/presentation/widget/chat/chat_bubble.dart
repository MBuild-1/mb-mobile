import 'package:flutter/material.dart';

import '../../../domain/entity/chat/help/help_message.dart';
import '../../../misc/constant.dart';

class ChatBubble extends StatelessWidget {
  final HelpMessage helpMessage;

  const ChatBubble({super.key, required this.helpMessage});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(helpMessage.userChat.name, style: const TextStyle(fontSize: 11)),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Constant.colorGrey6,
            borderRadius: BorderRadius.circular(8)
          ),
          padding: const EdgeInsets.all(8),
          child: Text(helpMessage.message),
        )
      ],
    );
  }
}