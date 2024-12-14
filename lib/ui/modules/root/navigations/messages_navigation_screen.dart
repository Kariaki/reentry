import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/messaging/bloc/conversation_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';
import 'package:reentry/ui/modules/messaging/components/chat_list_component.dart';
import 'package:reentry/ui/modules/messaging/start_conversation_screen.dart';
import '../../../components/scaffold/base_scaffold.dart';
import '../../clients/bloc/client_cubit.dart';

class ConversationNavigation extends HookWidget {
  const ConversationNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<AccountCubit>().readFromLocalStorage();
      context.read<ConversationUsersCubit>().fetchConversationUsers();
      return null;
    }, []);
    final user = context.watch<AccountCubit>().state;
    if (user == null) {
      print('****************** account is null');
      return const SizedBox();
    }
    return BaseScaffold(child: BlocBuilder<ConversationCubit, MessagingState>(
        builder: (context, state) {
      if (state is ConversationLoading) {
        //clients loading
        return const LoadingComponent();
      }
      if (state is ConversationError) {
        return ErrorComponent(
          title: "No conversations available",
          actionButtonText: "Start messaging",
          description: "Your conversations will appear here",
          showButton: user.accountType != AccountType.citizen,
          onActionButtonClick: () {
            context.pushRoute(const StartConversationScreen());
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
              context.pushRoute(const StartConversationScreen());
            },
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Messages', style: context.textTheme.titleSmall),
                if (user.accountType != AccountType.citizen)
                  InkWell(
                    onTap: () {
                      context.pushRoute(const StartConversationScreen());
                    },
                    child: const Icon(
                      Icons.add_circle_sharp,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  )
              ],
            ),
            20.height,
            ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final item = data[index];
                  final date =
                      DateTime.fromMillisecondsSinceEpoch(item.timestamp);
                  final currentUser = item.conversationUser;
                  return ChatListComponent(
                      entity: ConversationComponent(
                          name: currentUser?.name ?? '',
                          seen: item.seen == true &&
                              user.userId != item.lastMessageSenderId,
                          //I did not send it and the message is not seen
                          lastMessageSenderId: item.lastMessageSenderId,
                          accountType: item.conversationUser?.accountType??AccountType.citizen,
                          userId: item.members
                                  .where((e) => e != user.userId)
                                  .firstOrNull ??
                              '',
                          conversationId: item.id,
                          lastMessage: item.lastMessage,
                          avatar: (currentUser?.avatar.isEmpty ?? true)
                              ? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541'
                              : currentUser!.avatar,
                          lastMessageTime:
                              date.millisecondsSinceEpoch.toTimeString()));
                })
          ],
        );
      }
      return const SizedBox();
    }));
  }
}
