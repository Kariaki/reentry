import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/event.dart';
import 'package:reentry/ui/modules/messaging/bloc/message_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';

import 'components/chat_list_component.dart';

class MessagingScreen extends HookWidget {
  final ConversationComponent entity;

  const MessagingScreen({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    final user = context.read<AccountCubit>().state;
    final conversationIdState = useState<String?>(entity.conversationId);
    if (user == null) {
      return const Center(
        child: Text("Messaging not available"),
      );
    }
    useEffect(() {
      context.read<MessageCubit>()
        ..readConversation(
            entity.conversationId, entity.lastMessageSenderId == user.userId)
        ..streamMessage(entity.conversationId);
      return null;
    }, []);
    return BaseScaffold(
        appBar: AppBar(
          leading: InkWell(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.white,
            ),
          ),
          title: Row(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(entity.avatar),
                ),
              ),
              10.width,
              Text(
                entity.name,
                style: context.textTheme.bodyLarge,
              )
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                child: Align(
              alignment: Alignment.topCenter,
              child: BlocBuilder<MessageCubit, MessagingState>(
                  builder: (context, state) {
                if (state is MessagingLoading) {
                  return const LoadingComponent();
                }
                if (state is MessagesSuccessState) {
                  if (state.data.isEmpty) {
                    return const ErrorComponent(
                      title: "Your messages will appear here",
                      showButton: false,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.data.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          final message = state.data[index];

                          return _messageBubble(
                              message.text, message.senderId == user.userId);
                        }),
                  );
                }
                return const ErrorComponent(
                  title: "Your messages will appear here",
                  showButton: false,
                );
              }),
            )),
            5.height,
            Row(
              children: [
                10.width,
                Expanded(
                    child: TextField(
                  style: context.textTheme.bodyLarge?.copyWith(),
                  cursorColor: AppColors.primary,
                  maxLines: 3,
                  minLines: 1,
                  controller: controller,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      hintText: 'Type a message',
                      enabledBorder: buildOutlineInputBorder(),
                      focusedBorder: buildOutlineInputBorder()),
                )),
                10.width,
                _sendButton(() {
                  context.read<MessageCubit>().sendMessage(
                      SendMessageEvent(
                          receiverId: entity.userId,
                          text: controller.text,
                          conversationId: conversationIdState.value),
                      (conversationId) {
                    //when there is a new conversation
                    conversationIdState.value = conversationId;
                  });
                  controller.clear();
                }),
                10.width,
              ],
            ),
            10.height
          ],
        ));
  }

  Widget _messageBubble(String message, bool sent) {
    return Row(
      mainAxisAlignment: sent ? MainAxisAlignment.end : MainAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: ShapeDecoration(
              color: sent ? AppColors.primary : AppColors.gray1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50))),
          padding: const EdgeInsets.all(15),
          child: Text(
            message,
            textAlign: sent ? TextAlign.start : TextAlign.end,
            style: TextStyle(color: sent ? AppColors.black : AppColors.white),
          ),
        )
      ],
    );
  }

  Widget _sendButton(Function() onTap) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        radius: 100,
        child: Container(
          width: 40,
          height: 40,
          decoration: const ShapeDecoration(
              shape: CircleBorder(), color: AppColors.white),
          child: const Icon(
            Icons.send_rounded,
            color: AppColors.black,
          ),
        ),
      );

  OutlineInputBorder buildOutlineInputBorder() {
    return OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.gray2),
        borderRadius: BorderRadius.circular(10));
  }
}
