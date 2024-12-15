import 'package:chat_bubbles/date_chips/date_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/messaging/message_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/event.dart';
import 'package:reentry/ui/modules/messaging/bloc/message_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';
import 'package:reentry/ui/modules/messaging/modal/chat_option_modal.dart';
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
    // useEffect(() {
    //   context.read<MessageCubit>()
    //     ..readConversation(
    //         entity.conversationId, entity.lastMessageSenderId == user.userId)
    //     ..streamMessage(entity.conversationId);
    //   return null;
    // }, []);
    return BlocProvider(
      create: (context) => MessageCubit()
        ..readConversation(
            entity.conversationId, entity.lastMessageSenderId == user.userId)
        ..streamMessage(entity.conversationId),
      child: BaseScaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => context.popRoute(),
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
            actions: [
              InkWell(
                onTap: () {
                  context.showModal(ChatOptionModal(entity: entity,onBlock: (){
                 //todo perform block operation to update channel.
                    context.popRoute();
                  },));
                },
                child: const Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                ),
              )
            ],
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
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: state.data.length,
                          reverse: true,
                          separatorBuilder: (context, index) {
                            if (index == state.data.length) {
                              return 0.height;
                            }
                            final messages = state.data;
                            if (index == 0 || index == messages.length - 1) {
                              return const SizedBox(
                                height: 0,
                              );
                            }
                            final previous = messages[index];
                            final current = messages[index + 1];
                            DateTime previousDateTime =
                                DateTime.fromMillisecondsSinceEpoch(
                                    previous.timestamp ??
                                        DateTime.now().millisecondsSinceEpoch);
                            DateTime currentMessageDate =
                                DateTime.fromMillisecondsSinceEpoch(
                                    current.timestamp ??
                                        DateTime.now().millisecondsSinceEpoch);

                            // Use the DateFormat class to format the DateTime as a string
                            bool equals = previousDateTime.formatDate() ==
                                currentMessageDate.formatDate();
                            if (equals) {
                              return SizedBox.shrink();
                            }
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: DateChip(
                                  date: previousDateTime,
                                  color: AppColors.gray1,
                                ),
                              ),
                            );
                          },
                          itemBuilder: (context, index) {
                            final message = state.data[index];

                            return _messageBubble(
                                message.text,
                                message.timestamp ??
                                    DateTime.now().millisecondsSinceEpoch,
                                message.senderId == user.userId);
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
                  BlocBuilder<MessageCubit, MessagingState>(
                      builder: (messageContext, state) {
                    return _sendButton(() {
                      messageContext.read<MessageCubit>().sendMessage(
                          SendMessageEvent(
                              receiverId: entity.userId,
                              text: controller.text,
                              receiverInfo: ReceiverInfo(
                                  accountType: AccountType.citizen,
                                  //todo change
                                  name: entity.name,
                                  avatar: entity.avatar),
                              conversationId: conversationIdState.value),
                          (conversationId) {
                        //when there is a new conversation
                        conversationIdState.value = conversationId;
                      });
                      controller.clear();
                    });
                  }),
                  10.width,
                ],
              ),
              10.height
            ],
          )),
    );
  }

  Widget _messageBubble(String message, int timestamp, bool sent) {
    return Row(
      mainAxisAlignment: sent ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            constraints: BoxConstraints(maxWidth: 200),
            decoration: ShapeDecoration(
                color: sent ? AppColors.primary : AppColors.gray1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            padding: const EdgeInsets.all(8),
            child: Wrap(
              alignment: WrapAlignment.end,
              runAlignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: [
                Text(
                  message,
                  style: TextStyle(
                      color: sent ? AppColors.black : AppColors.white),
                ),
                Text(
                    '\t\t\t\t\t${DateTime.fromMillisecondsSinceEpoch(timestamp).beautify(withDate: false)}',
                    style: TextStyle(
                        color: sent
                            ? AppColors.gray1.withOpacity(.85)
                            : AppColors.gray2,
                        fontSize: 10)),
              ],
            ))
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
