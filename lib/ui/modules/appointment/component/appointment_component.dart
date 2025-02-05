import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/ui/components/add_button.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/appointment/view_appointments_screen.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../../../core/theme/colors.dart';
import '../../../components/container/box_container.dart';
import '../../../components/container/outline_container.dart';
import '../../authentication/bloc/account_cubit.dart';
import '../../root/navigations/home_navigation_screen.dart';
import '../bloc/appointment_state.dart';
import '../create_appointment_screen.dart';
import '../view_single_appointment_screen.dart';

class AppointmentComponent extends HookWidget {
  final bool showAll;
  final bool invitation;
  final bool showCreate;

  const AppointmentComponent(
      {super.key,
      this.showAll = true,
      this.invitation = false,
      this.showCreate = true});

  @override
  Widget build(BuildContext context) {
    final accountCubit = context.watch<AccountCubit>().state;
    final selectedTab = useState(0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BoxContainer(
            verticalPadding: 10,
            horizontalPadding: 10,
            filled: false,
            constraints:
                const BoxConstraints(minHeight: 150, minWidth: double.infinity),
            radius: 10,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    label(invitation ? "Invitations" : 'Appointments'),
                    if (showCreate)
                      AddButton(onTap: () {
                        if (kIsWeb) {
                          context.displayDialog(const CreateAppointmentScreen());
                        } else {
                          context.pushRoute(const CreateAppointmentScreen());
                        }
                      })
                  ],
                ),
                5.height,
                BlocBuilder<AppointmentCubit, AppointmentCubitState>(
                    builder: (context, state) {
                  if (state.state is CubitStateLoading) {
                    return const LoadingComponent();
                  }
                  if (state.state is CubitStateError) {
                    return ErrorComponent(
                      showButton: true,
                      onActionButtonClick: () {
                        context
                            .read<AppointmentCubit>()
                            .fetchAppointments(userId:accountCubit?.userId ?? '');
                      },
                    );
                  }
                  if (state.state is CubitStateSuccess) {
                    final result = invitation ? state.invitations : state.data;
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
                                    appointments[index], createdByMe,
                                    invitation: invitation);
                              },
                            ),
                          if (!showAll && appointments.length > 3)
                            Align(
                              alignment: Alignment.center,
                              child: InkWell(
                                onTap: () {
                                  context.pushRoute(const ViewAppointmentsScreen());
                                },
                                child: const Text(
                                  "View All",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                ),
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
                })
              ],
            )),
      ],
    );
  }
}

Widget tabComponent(AppointmentFilterEntity data, int index, bool selected,
    {required VoidCallback onPress}) {
  return SizedBox();
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

Widget appointmentComponent(NewAppointmentDto entity, bool createdByMe,
    {bool invitation = false}) {
  return Builder(builder: (context) {
    final theme = context.textTheme;

    return InkWell(
      onTap: () {
        context.pushRoute(ViewSingleAppointmentScreen(
          entity: entity,
        ));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entity.title,
                  style: theme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                5.height,
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.white,
                    ),
                    5.width,
                    Text(entity.location ?? '',
                        style: theme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400, fontSize: 14))
                  ],
                ),
                8.height,
                if (!createdByMe && entity.state == EventState.pending)
                  const Text('Pending invitation')
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ...[
                            if (entity.participantId != null)
                              SizedBox(
                                height: 14,
                                width: 14,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      (createdByMe && invitation)
                                          ? entity.creatorAvatar
                                          : createdByMe
                                              ? entity.participantAvatar ??
                                                  AppConstants.avatar
                                              : entity.creatorAvatar),
                                ),
                              )
                            else
                              const Icon(
                                Icons.account_circle_outlined,
                                color: AppColors.white,
                                size: 14,
                              ),
                            5.width
                          ],
                          Text(
                              (invitation && createdByMe)
                                  ? (entity.participantId == null
                                      ? 'No participant'
                                      : 'You')
                                  : createdByMe
                                      ? (entity.participantName ??
                                          'No participant')
                                      : entity.creatorName,
                              style: theme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.gray2))
                        ],
                      ),
                      // if(createdByMe&& invitation)
                      //   Text('Sent',  style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400,fontSize: 12),)
                    ],
                  ),
              ],
            )),
            Text(entity.date.beautify(),
                style: theme.bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
          ],
        ),
      ),
    );
  });
}
