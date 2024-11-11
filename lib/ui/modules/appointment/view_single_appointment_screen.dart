import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_bloc.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_event.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_state.dart';
import 'package:reentry/ui/modules/appointment/select_appointment_user.dart';
import 'package:reentry/ui/modules/appointment/update_appointment.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/theme/colors.dart';
import '../../../data/model/appointment_dto.dart';
import '../../components/container/box_container.dart';
import '../../components/date_time_picker.dart';
import '../../components/input/input_field.dart';

class ViewSingleAppointmentScreen extends HookWidget {
  final AppointmentEntityDto entity;

  const ViewSingleAppointmentScreen({super.key, required this.entity});

  Widget label(String text) {
    return Builder(builder: (context) {
      final textTheme = context.textTheme;
      return Text(
        text,
        style: textTheme.titleSmall,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final time = useState<DateTime>(entity.time);
    final user = context.read<AccountCubit>().state;
    if (user == null) {
      return const SizedBox();
    }
    final createdByMe = entity.userId != user.userId;
    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child:
          BlocConsumer<AppointmentBloc, AppointmentState>(listener: (_, state) {
        if (state is CancelAppointmentSuccess) {
          context.read<AppointmentCubit>().fetchAppointments();
          context.pushReplace(SuccessScreen(
            callback: () {},
            title: 'Appointment cancel',
            description: 'You appointment have been canceled',
          ));
        }
        if (state is AppointmentError) {
          context.showSnackbarError(state.message);
        }
      }, builder: (context, state) {
        return BaseScaffold(
            isLoading: state is AppointmentLoading,
            appBar: const CustomAppbar(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      label('Appointments'),
                      RichText(
                          text: TextSpan(text: 'Status:\t', children: [
                        TextSpan(
                            text: entity.status.name.capitalizeFirst(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color:
                                    getAppointmentStatusColor(entity.status)))
                      ]))
                    ],
                  ),
                  10.height,
                  selectableUserContainer(
                      name: entity.name, onTap: () {}, url: entity.avatar),
                  20.height,
                  BoxContainer(
                      radius: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          10.height,
                          Text(
                            'Date and time',
                            style: context.textTheme.bodyLarge,
                          ),
                          10.height,
                          DateTimePicker(
                            onTap: () async {},
                            title: time.value.formatDate(),
                          ),
                          20.height,
                          Text(
                            'Select time',
                            style: context.textTheme.bodyLarge,
                          ),
                          10.height,
                          DateTimePicker(
                            title: entity.bookedTime,
                            icon: Icons.timelapse,
                            onTap: () async {
                              if (!createdByMe) {
                                return;
                              }
                            },
                          ),
                        ],
                      )),
                  if (entity.note != null) ...[
                    20.height,
                    Text(
                      'Notes',
                      style: context.textTheme.bodyLarge,
                    ),
                    10.height,
                    Text(
                      entity.note ?? '',
                      style:
                          const TextStyle(fontSize: 16, color: AppColors.white),
                    ),
                  ],
                  20.height,
                  if (createdByMe &&
                      entity.status != AppointmentStatus.canceled)
                    PrimaryButton(
                        text: "Edit appointment",
                        onPress: () {
                          context.pushReplace(UpdateAppointmentScreen(
                              appointmentEntity: UpdateAppointmentDto(
                                  userId: entity.userId,
                                  name: entity.name,
                                  avatar: entity.avatar,
                                  status: entity.status,
                                  appointmentTime: entity.time,
                                  bookedDay: entity.bookedDay,
                                  bookedTime: entity.bookedTime,
                                  note: entity.note ?? '',
                                  appointmentId: entity.id)));
                        }),
                  15.height,
                  if (entity.status == AppointmentStatus.upcoming)
                    PrimaryButton.dark(
                        text: "Cancel appointment",
                        onPress: () {
                          showPlatformDialog(
                            context: context,
                            builder: (ctx) => BasicDialogAlert(
                              title: const Text("Cancel appointment?"),
                              content: const Text(
                                "Are you sure you want to cancel this appointment",
                                style: TextStyle(color: AppColors.black),
                              ),
                              actions: <Widget>[
                                BasicDialogAction(
                                  title: const Text("Confirm"),
                                  onPressed: () {
                                    context
                                        .read<AppointmentBloc>()
                                        .add(CancelAppointmentEvent(entity.id));
                                    ctx.pop();
                                  },
                                ),
                                BasicDialogAction(
                                  title: const Text("Close"),
                                  onPressed: () {
                                    context.pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        })
                ],
              ),
            ));
      }),
    );
  }

  Color getAppointmentStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.canceled:
        return Colors.red;
      case AppointmentStatus.upcoming:
        return Colors.grey;
      case AppointmentStatus.missed:
        return Colors.red;
      case AppointmentStatus.done:
        return Colors.green;
    }
  }
}
