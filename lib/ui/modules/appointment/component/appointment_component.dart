import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/appointment/view_appointments_screen.dart';
import 'package:reentry/ui/modules/appointment/view_single_appointment_screen.dart';
import '../../../../core/theme/colors.dart';
import '../../../../data/enum/account_type.dart';
import '../../../components/buttons/app_button.dart';
import '../../../components/container/box_container.dart';
import '../../../components/container/outline_container.dart';
import '../../authentication/bloc/account_cubit.dart';
import '../../root/navigations/home_navigation_screen.dart';
import '../bloc/appointment_state.dart';
import '../select_appointment_user.dart';
import '../select_appointment_user_screen_non_client.dart';

class AppointmentComponent extends HookWidget {
  final bool showAll;

  const AppointmentComponent({super.key, this.showAll = true});

  @override
  Widget build(BuildContext context) {
    final accountCubit = context.watch<AccountCubit>().state;
    final selectedTab = useState(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        label('Appointments'),
        15.height,
        BoxContainer(
            verticalPadding: 10,
            horizontalPadding: 5,
            constraints:
                const BoxConstraints(minHeight: 150, minWidth: double.infinity),
            radius: 10,
            child: BlocBuilder<AppointmentCubit, AppointmentState>(
                builder: (context, state) {
              if (state is AppointmentLoading) {
                return const LoadingComponent();
              }
              if (state is AppointmentError) {
                return ErrorComponent(
                  showButton: true,
                  onActionButtonClick: () {
                    context.read<AppointmentCubit>().fetchAppointments();
                  },
                );
              }
              if (state is AppointmentDataSuccess) {
                final result = state.data;
                final now = DateTime.now();
                List<AppointmentEntityDto> appointments = [];
                if (selectedTab.value == 0) {
                  appointments = result
                      .where((e) =>
                          e.status == AppointmentStatus.upcoming &&
                          e.time.isAfter(now))
                      .toList();
                }

                if (selectedTab.value == 1) {
                  appointments = result
                      .where((e) => e.status == AppointmentStatus.missed)
                      .toList();
                }
                if(selectedTab.value ==2){
                  appointments = result.where((e)=>e.status == AppointmentStatus.done).toList();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      Container(
                        height:30,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(items.length, (index) {
                            final item = items[index];
                            return tabComponent(
                                item, index, selectedTab.value == index,
                                onPress: () {
                              selectedTab.value = index;
                            });
                          }),
                        ),
                      ),
                      if (appointments.isEmpty)
                        const Padding(padding: EdgeInsets.symmetric(vertical: 20),
                        child: ErrorComponent(
                          showButton: false,
                          title: "There is nothing here",
                          description: "You don't have an appointment to view",
                        ),)
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: showAll
                              ? appointments.length
                              : (appointments.length > 3
                                  ? 3
                                  : appointments.length),
                          separatorBuilder: (context, index) => 0.height,
                          itemBuilder: (context, index) {
                            return appointmentComponent(appointments[index]);
                          },
                        ),
                      if (!showAll && appointments.length > 3)
                        Align(
                          alignment: Alignment.center,
                          child: InkWell(
                            onTap: () {
                              context.push(ViewAppointmentsScreen());
                            },
                            child: Text("View All"),
                          ),
                        )
                    ]
                  ],
                );
              }
              return const ErrorComponent(
                showButton: false,
                title: "There is nothing here",
                description: "You don't have an appointment to view",
              );
            })),
        if (showAll) ...[
          10.height,
          Align(
            alignment: Alignment.centerRight,
            child: AppOutlineButton(
                title: 'Create new',
                onPress: () {
                  if (accountCubit?.accountType != AccountType.citizen) {
                    context.push(const SelectAppointmentUserScreenNonClient());
                    return;
                  }
                  context.push(const SelectAppointmentUserScreenClient());
                }),
          )
        ]
      ],
    );
  }
}

Widget tabComponent(AppointmentFilterEntity data, int index, bool selected,
    {required VoidCallback onPress}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    child: Builder(builder: (context) {
      final textTheme = context.textTheme;
      final textStyle = textTheme.displaySmall?.copyWith(
        color: selected ? AppColors.black : null,
        fontWeight: FontWeight.bold,
      );
      final child = Row(
        children: [
          if (!selected && index == 0)
            const Icon(
              Icons.access_time_rounded,
              color: AppColors.white,
              size: 18,
            )
          else
            if(!selected && index==items.length-1)
              const Icon(
                Icons.content_paste_off,
                color: AppColors.white,
                size: 18,
              )
              else
            data.asset,
          5.width,
          Text(
            data.title,
            style: textStyle,
          )
        ],
      );
      if (selected) {
        return BoxContainer(
          onPress: onPress,
          horizontalPadding: 10,
          color: AppColors.white,
          verticalPadding: 5,
          child: child,
        );
      }
      return OutlineContainer(
          onPress: onPress,
          verticalPadding: 5,
          horizontalPadding: 10,
          child: child);
    }),
  );
}

Widget label(String text) {
  return Builder(builder: (context) {
    final textTheme = context.textTheme;
    return Text(
      text,
      style: textTheme.titleSmall,
    );
  });
}

Widget appointmentComponent(AppointmentEntityDto entity) {
  return Builder(builder: (context) {
    final theme = context.textTheme;
    return ListTile(
      onTap: () {
        // open view single appointment screen
        context.push(ViewSingleAppointmentScreen(entity: entity));
      },
      leading: SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundImage: NetworkImage(entity.avatar),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        entity.name,
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        entity.accountType,
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
      trailing: Text(entity.time.beautify(),
          style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
    );
  });
}
