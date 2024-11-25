import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/ui/components/add_button.dart';
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
import '../create_appointment_screen.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            label('Appointments'),
            AddButton(onTap: () {
              context.push(CreateAppointmentScreen());
            })
          ],
        ),
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
                    context
                        .read<AppointmentCubit>()
                        .fetchAppointments(accountCubit?.userId ?? '');
                  },
                );
              }
              if (state is AppointmentDataSuccess) {
                final result = state.data;
                final now = DateTime.now();
                final appointments = result;
                // if (selectedTab.value == 0) {
                //   appointments = result
                //       .where((e) =>
                //           e.status == AppointmentStatus.upcoming &&
                //           e.time.isAfter(now))
                //       .toList();
                // }
                //
                // if (selectedTab.value == 1) {
                //   appointments = result
                //       .where((e) => e.status == AppointmentStatus.missed)
                //       .toList();
                // }
                // if(selectedTab.value ==2){
                //   appointments = result.where((e)=>e.status == AppointmentStatus.done).toList();
                // }
                // if(selectedTab.value ==3){
                //   appointments = result.where((e)=>e.status == AppointmentStatus.done||e.status == AppointmentStatus.canceled).toList();
                // }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      if (appointments.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: ErrorComponent(
                            showButton: false,
                            title: "There is nothing here",
                            description:
                                "You don't have an appointment to view",
                          ),
                        )
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
                            final createdByMe = accountCubit?.userId ==
                                appointments[index].creatorId;
                            return appointmentComponent(
                                appointments[index], createdByMe);
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
          else if (!selected && index == items.length - 1)
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

Widget appointmentComponent(NewAppointmentDto entity, bool createdByMe) {
  return Builder(builder: (context) {
    final theme = context.textTheme;

    return ListTile(
      onTap: () {
        // open view single appointment screen
        // if (createdByMe) {
        //   context.push(CreateAppointmentScreen(
        //     appointment: entity,
        //   ));
        // }
          context.push(ViewSingleAppointmentScreen(entity: entity));
      },
      leading: SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundImage: NetworkImage(''),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        entity.title,
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      // subtitle: Text(
      //   entity.accountType,
      //   style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      // ),
      trailing: Text(entity.date.beautify(),
          style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400)),
    );
  });
}
