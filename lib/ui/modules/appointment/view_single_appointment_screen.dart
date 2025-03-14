import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_bloc.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_event.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import 'package:reentry/ui/modules/appointment/create_appointment_screen.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/theme/colors.dart';
import '../../../data/model/appointment_dto.dart';
import '../admin/admin_stat_cubit.dart';
import 'modal/rejection_reason_modal.dart';

class ViewSingleAppointmentScreen extends HookWidget {
  final NewAppointmentDto entity;

  const ViewSingleAppointmentScreen({super.key, required this.entity});

  Widget label(String text) {
    return Builder(builder: (context) {
      final textTheme = context.textTheme;
      return Text(
        text,
        style: textTheme.titleSmall?.copyWith(color: AppColors.gray2),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AccountCubit>().state;
    if (user == null) {
      return const SizedBox();
    }
    final textTheme = context.textTheme;
    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child:
          BlocConsumer<AppointmentBloc, AppointmentState>(listener: (_, state) {
        if (state is UpdateAppointmentSuccess) {
          // context.read<AppointmentCubit>().fetchAppointments();
          if(kIsWeb){
            context.showSnackbarSuccess('Invitation accepted');
            Navigator.pop(context);
            return;
          }
          context.pushReplace(SuccessScreen(
            callback: () {},
            title:
                'Appointment ${state.data.state == EventState.accepted ? 'Accepted' : 'Rejected'}',
            description:
                'You appointment have been ${state.data.state == EventState.accepted ? 'Accepted' : 'Rejected'}',
          ));
        }
        if (state is AppointmentError) {
          context.showSnackbarError(state.message);
        }
      }, builder: (context, state) {
        final createdByMe = user.userId == entity.creatorId;
        print(entity.status.name);
        return BaseScaffold(
            isLoading: state is AppointmentLoading,
            appBar: const CustomAppbar(
              title: "Appointment",
              backIcon: Icons.close,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Text(
                    entity.title,
                    style: textTheme.titleSmall?.copyWith(fontSize: 20),
                  ),
                  10.height,
                  Text(
                    entity.description,
                    style: textTheme.bodySmall?.copyWith(fontSize: 16),
                  ),
                  20.height,
                  titleItem(
                      icon: Icons.calendar_month,
                      title: entity.date.formatDate(),
                      onClick: () {},
                      description: 'Appointment date'),
                  15.height,
                  titleItem(
                      icon: Icons.timelapse_outlined,
                      title:
                          TimeOfDay.fromDateTime(entity.date).format(context),
                      onClick: () {},
                      description: 'Time'),
                  15.height,
                  if (entity.location != null)
                    titleItem(
                        icon: Icons.location_on_outlined,
                        title: entity.location!,
                        onClick: () {},
                        description: 'Address'),
                  20.height,
                  label('Attendees'),
                  10.height,
                  membersComponent(
                      entity.creatorName, entity.creatorAvatar, true),
                  5.height,
                  if (entity.participantId != null)
                    membersComponent(entity.participantName ?? '',
                        entity.participantAvatar, false,
                        status: entity.state.name.capitalizeFirst()),
                  if (createdByMe &&
                      entity.date.isAfter(DateTime.now()) &&
                      entity.status != AppointmentStatus.canceled) ...[
                    20.height,
                    PrimaryButton(
                      text: 'Edit appointment',
                      onPress: () async {
                        final result =
                            await context.pushRoute(CreateAppointmentScreen(
                          appointment: entity,
                              cancel: entity.status !=AppointmentStatus.canceled,
                        ));
                        final data = result as NewAppointmentDto?;
                      },
                    ),
                    20.height,
                  ],
                  // if (entity.state == EventState.pending && !createdByMe) ...[
                  //   20.height,
                  //   PrimaryButton(
                  //     text: 'Accept',
                  //     onPress: () {
                  //       final data =
                  //           entity.copyWith(state: EventState.accepted);
                  //
                  //       context.read<AdminStatCubit>().updateAppointment();
                  //       context
                  //           .read<AppointmentBloc>()
                  //           .add(UpdateAppointmentEvent(data));
                  //     },
                  //   ),
                  //   10.height,
                  //   PrimaryButton.dark(
                  //       text: 'Reject',
                  //       onPress: () async {
                  //         final reason = await context
                  //             .showModal(const RejectionReasonModal());
                  //         final data = entity.copyWith(
                  //             reasonForRejection: reason,
                  //             state: EventState.declined);
                  //         context
                  //             .read<AppointmentBloc>()
                  //             .add(UpdateAppointmentEvent(data));
                  //       })
                  // ]
                ],
              ),
            ));
      }),
    );
  }

  Widget membersComponent(String name, String? avatar, bool createdByMe,
      {String? status}) {
    return Builder(builder: (context) {
      final theme = context.textTheme;

      return ListTile(
        minVerticalPadding: 5,
        leading: SizedBox(
          height: 30,
          width: 30,
          child: CircleAvatar(
            backgroundImage: NetworkImage(avatar ?? AppConstants.avatar),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        title: Text(
          name,
          style: theme.bodyMedium
              ?.copyWith(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        trailing: status != null
            ? Text(status,
                style: theme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.gray2))
            : null,
        subtitle: Text(createdByMe ? "Creator" : "Participant",
            style: theme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: AppColors.gray2)),
      );
    });
  }
}
