import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/conversation_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';
import 'package:reentry/ui/modules/messaging/components/chat_list_component.dart';
import 'package:reentry/ui/modules/messaging/start_conversation_screen.dart';

import '../../../components/scaffold/base_scaffold.dart';

class ConversationNavigation extends StatelessWidget {
  const ConversationNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AccountCubit>().state;
    if (user == null) {
      return const SizedBox();
    }
    return BaseScaffold(child: BlocBuilder<ConversationCubit, MessagingState>(
        builder: (context, state) {
      if (state is ConversationLoading) {
        return LoadingComponent();
      }
      if (state is ConversationError) {
        return ErrorComponent(
          title: "No conversations available",
          actionButtonText: "Start messaging",
          description: "Your conversations will appear here",
          showButton: user.accountType != AccountType.citizen,
          onActionButtonClick: () {

            context.push(StartConversationScreen());
          },
        );
      }
      if (state is ConversationSuccessState) {
        final data = state.data;
        if (data.isEmpty) {
          return ErrorComponent(
            title: "No conversations available",
            description: "Your conversations will appear here",
            actionButtonText: "Start messaging",
            showButton: user.accountType != AccountType.citizen,
            onActionButtonClick: () {
              context.push(StartConversationScreen());
            },
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            Text('Messages', style: context.textTheme.titleSmall),
            20.height,
            ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = data[index];
                  final date =
                      DateTime.fromMicrosecondsSinceEpoch(item.timestamp);
                  return ChatListComponent(
                      entity: ConversationComponent(
                          name: 'James',
                          userId: item.members
                                  .where((e) => e != user.userId)
                                  .firstOrNull ??
                              '',
                          conversationId: item.id,
                          lastMessage: item.lastMessage,
                          avatar: 'avatar',
                          lastMessageTime: date.beautify()));
                })
          ],
        );
      }
      return const SizedBox();
    }));
  }
}
