import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/messaging/bloc/conversation_cubit.dart';
import 'package:reentry/ui/modules/messaging/bloc/state.dart';
import 'package:reentry/ui/modules/messaging/components/chat_list_component.dart';
import 'package:reentry/ui/modules/messaging/messaging_screen.dart';

class StartConversationScreen extends HookWidget {
  final bool showBack;
  const StartConversationScreen({super.key,this.showBack=true});

  @override
  Widget build(BuildContext context) {
    final conversations = context.read<ConversationCubit>().state;

    useEffect((){
      print('******************* kariaki');
      context.read<ClientCubit>().fetchClients();
    },[]);
    return BaseScaffold(
        appBar:  CustomAppbar(
          title: 'Your clients',
          showBack: showBack,
        ),
        child:
            BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
          // if (conversations is! ConversationSuccessState) {
          //   return const ErrorComponent(
          //     showButton: false,
          //     title: "Ooops!! Nothing here",
          //     description:
          //         "Unfortunately you can not start a conversation with anyone at this time.",
          //   );
          // }
          if (state is ClientLoading) {
            return const LoadingComponent();
          }
          if (state is ClientDataSuccess) {
            if (state.data.isEmpty) {
              return const ErrorComponent(
                showButton: false,
                title: "Ooops! Nothing here",
                description:
                    "Unfortunately you can not start a conversation with anyone at this time.",
              );
            }
            return HookBuilder(builder: (context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Select client',style: AppStyles.textTheme(context).bodyLarge,),
                  20.height,
                  //show list Item
                  Expanded(
                      child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      final item = state.data[index];

                      return selectableUserContainer(
                          name: item.name,
                          url: item.avatar,
                          selected: false,
                          onTap: () {
                            if(conversations is ConversationSuccessState){

                              final conversation = conversations.data
                                  .where((e) => e.members.contains(item.id))
                                  .firstOrNull;
                              context.pushRoute(MessagingScreen(
                                  entity: ConversationComponent(
                                      name: item.name,
                                      userId: item.id,
                                      lastMessageSenderId: null,
                                      conversationId: conversation?.id,
                                      accountType: AccountType.citizen,
                                      lastMessage: '',
                                      avatar: item.avatar,
                                      lastMessageTime: '')));
                            }
                          });
                    },
                  )),

                  20.height,
                ],
              );
            });
          }
          return ErrorComponent(
            title: "Something went wrong!",
            description: "Unable to fetch data please retry",
            onActionButtonClick: () {
              context.read<UserAssigneeCubit>().fetchAssignee();
            },
          );
        }));
  }
}

Widget selectableUserContainer(
    {required String name,
    String? url,
    bool selected = false,
    required Function() onTap}) {
  return InkWell(
    radius: 50,
    borderRadius: BorderRadius.circular(50),
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: BorderSide(
                  color: selected ? AppColors.white : Colors.transparent))),
      child: UserInfoComponent(
        name: name,
        url: url,
        size: 40,
      ),
    ),
  );
}
