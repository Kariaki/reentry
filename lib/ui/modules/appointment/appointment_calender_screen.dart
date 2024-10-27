import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/date_time_picker.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_bloc.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_event.dart';
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';

import 'bloc/appointment_state.dart';

class AppointmentUserDto {
  final String name;
  final String userId;
  final String avatar;

  const AppointmentUserDto(
      {required this.userId, required this.name, required this.avatar});
}

class AppointmentCalenderScreen extends HookWidget {
  final AppointmentUserDto user;

  const AppointmentCalenderScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();
    final date = useState<DateTime?>(null);
    final time = useState<TimeOfDay?>(null);
    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child: BlocConsumer<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
        return BaseScaffold(
            appBar: const CustomAppbar(
              title: 'Appointments',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoComponent(
                  name: user.name,
                  size: 40,
                ),
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
                          onTap: () async {
                            final result = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2050),
                            );
                            date.value = result;
                          },
                          title: date.value?.formatDate(),
                        ),
                        20.height,
                        Text(
                          'Select time',
                          style: context.textTheme.bodyLarge,
                        ),
                        10.height,
                        DateTimePicker(
                          title: time.value != null
                              ? '${time.value?.hour.toString()}:${time.value?.minute}'
                              : 'Select time',
                          icon: Icons.timelapse,
                          onTap: () async {
                            final result = await showTimePicker(
                                context: context,
                                builder: (context, child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                                    child: child ?? Container(),
                                  );
                                },
                                initialTime:
                                    const TimeOfDay(hour: 00, minute: 00),
                                initialEntryMode: TimePickerEntryMode.input);
                            print(result?.toString());
                            time.value = result;
                          },
                        ),
                      ],
                    )),
                20.height,
                Text('Notes', style: context.textTheme.bodyLarge),
                10.height,
                InputField(
                  hint: 'Enter notes here (Optional)',
                  controller: controller,
                  lines: 3,
                  radius: 10,
                  fillColor: AppColors.gray1,
                ),
                30.height,
                PrimaryButton(
                  text: 'Save appointment',
                  loading: state is AppointmentLoading,
                  onPress: () {
                    if (date.value == null || time.value == null) {}
                    final timeResult = DateTime(
                        date.value!.year,
                        date.value!.month,
                        date.value!.day,
                        time.value!.hour,
                        time.value!.minute);
                    context.read<AppointmentBloc>().add(CreateAppointmentEvent(
                        timestamp: timeResult.millisecondsSinceEpoch,
                        userId: user.userId,
                        notes: controller.text));
                  },
                ),
                20.height,
                PrimaryButton.dark(text: 'Cancel appointment'),
              ],
            ));
      }, listener: (_, state) {
        if (state is AppointmentSuccess) {
          context.pushReplace(SuccessScreen(
            callback: () {},
            title: 'Appointment created successfully',
            description: 'You appointment have been created successfully',
          ));
          return;
        }
        if (state is AppointmentError) {
          context.showSnackbarError(state.message);
        }
      }),
    );
  }
}
