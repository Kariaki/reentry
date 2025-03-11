import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/resources/data_state.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/appointment/create_appointment_screen.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';

class SelectAppointmentUserScreenClient extends HookWidget {
  const SelectAppointmentUserScreenClient({super.key,this.onselect});

  final void Function (AppointmentUserDto)? onselect;
  @override
  Widget build(BuildContext context) {
    final selectedUser = useState<AppointmentUserDto?>(null);
    return BlocProvider(
      create: (context) => UserAssigneeCubit()..fetchAssignee(),
      child: BaseScaffold(
          appBar:  CustomAppbar(
            title: 'Select participant',
            onBackPress: (){
              context.popBack();
            },
          ),
          child: BlocBuilder<UserAssigneeCubit, ClientState>(
              builder: (context, state) {
            if (state is ClientLoading) {
              return const LoadingComponent();
            }
            if (state is UserDataSuccess) {
              if (state.data.isEmpty) {
                return const ErrorComponent(
                  showButton: false,
                  title: "Ooops!! Nothing here",
                  description: "Try sending a mentor request",
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
                            selected: selectedUser.value?.userId == item.userId,
                            onTap: () {
                              selectedUser.value = item.toAppointmentUserDto();
                            });
                      },
                    )),

                    PrimaryButton(
                      text: 'Continue',
                      onPress: () {
                        if (selectedUser.value == null) {
                          return;
                        }
                        onselect?.call(selectedUser.value!);
                        context.popRoute(result: selectedUser.value);
                      },
                    ),
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
          })),
    );
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
