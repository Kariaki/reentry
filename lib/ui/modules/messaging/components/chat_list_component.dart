import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

import '../messaging_screen.dart';

class ConversationComponent {
  final String name;
  final String userId;
  final String? conversationId;
  final String lastMessage;
  final String lastMessageTime;
  final String avatar;

  const ConversationComponent(
      {required this.name,
      required this.userId,
       this.conversationId,
      required this.lastMessage,
      required this.avatar,
      required this.lastMessageTime});
}

class ChatListComponent extends HookWidget {
  final ConversationComponent entity;

  const ChatListComponent({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push(MessagingScreen(
          entity: entity,
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _avatar(),
            8.width,
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [_name(context), 8.height, _lastMessage(context)],
            )),
            _time(context)
          ],
        ),
      ),
    );
  }

  Text _time(BuildContext context) {
    return Text(
      entity.lastMessageTime,
      style: context.textTheme.bodyMedium
          ?.copyWith(color: AppColors.gray2, fontSize: 12),
    );
  }

  Text _lastMessage(BuildContext context) {
    return Text(
      entity.lastMessage,
      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.gray2),
      softWrap: true,
    );
  }

  Text _name(BuildContext context) =>
      Text(entity.name, style: context.textTheme.bodyLarge);

  SizedBox _avatar() {
    return SizedBox(
      width: 50,
      height: 50,
      child: CircleAvatar(
        backgroundImage: NetworkImage(entity.avatar),
      ),
    );
  }
}
