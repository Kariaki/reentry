import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/modules/messaging/components/chat_list_component.dart';

import '../../../components/scaffold/base_scaffold.dart';

class MessagesNavigationScreen extends StatelessWidget {
  const MessagesNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Text('Messages', style: context.textTheme.titleSmall),
        20.height,
        ListView.builder(
          itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ChatListComponent(
                  entity: ConversationComponent(
                      name: 'James',
                      userId: 'userId',
                      conversationId: 'conversationId',
                      lastMessage: 'New to this place and I will like to know where the market is so I can get food',
                      avatar: 'avatar',
                      lastMessageTime: 'yesterday'));
            })
      ],
    ));
  }
}
