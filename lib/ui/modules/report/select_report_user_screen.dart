import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/main.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/appointment/create_appointment_screen.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';
import 'package:reentry/ui/modules/report/report_user_form_screen.dart';

class SelectReportUserScreen extends HookWidget {
  const SelectReportUserScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final selectedUser = useState<ConversationUserEntity?>(null);
    return BlocProvider(create: (context)=>ConversationUsersCubit()..fetchConversationUsers(showLoader: true),
    child: BaseScaffold(
        appBar: const CustomAppbar(
          title: 'Report user',
        ),
        child: BlocBuilder<ConversationUsersCubit,ClientState>(builder: (ctx,state){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text('Select client',style: AppStyles.textTheme(context).bodyLarge,),
              20.height,
              //show list Item
              Expanded(child: Builder(builder: (context){
                if(state is ClientLoading){
                  return const LoadingComponent();
                }
                if(state is ClientError){
                  return ErrorComponent(title: "Something went wrong!",description: "There is no one here, try refreshing",onActionButtonClick: (){
                    ctx.read<ConversationUsersCubit>().fetchConversationUsers(showLoader: true);
                  },);
                }
                if(state is ConversationUserStateSuccess){
                  final data = state.data.values.toList();
                  if(data.isEmpty){
                    return const ErrorComponent(showButton: false,title: "Ooops! Nothing is here",);
                  }
                  return
                    ListView.builder(
                      itemCount: data.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = data[index];
                        return selectableUserContainer(
                            name:item.name,
                            url: item.avatar??AppConstants.avatar,
                            selected: selectedUser.value?.userId == item.userId,
                            onTap: () {
                              selectedUser.value = item;
                            });
                      },
                    );
                }
                return const ErrorComponent(showButton: false,);
              })),
              50.height,
              if(state is ConversationUserStateSuccess)
              PrimaryButton(
                text: 'Continue',
                enable: selectedUser.value!=null,
                onPress: () {
                  context.pushRoute(ReportUserFormScreen(entity: selectedUser.value!,));
                },
              ),
              20.height,
            ],
          );
        })),);
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
}
