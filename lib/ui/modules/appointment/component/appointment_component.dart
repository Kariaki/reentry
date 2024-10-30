import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
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
                  appointments =
                      result.where((e) => e.time.isAfter(now)).toList();
                }

                if (selectedTab.value == 1) {
                  appointments =
                      result.where((e) => e.time.isBefore(now)).toList();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: appointments.length,
                        separatorBuilder: (context, index) => 0.height,
                        itemBuilder: (context, index) {
                          return appointmentComponent(appointments[index]);
                        },
                      )
                    ]
                  ],
                );
              }
              return const ErrorComponent();
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
  return Builder(builder: (context) {
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
  });
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
      leading: SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundImage: NetworkImage(entity.avatar),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
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