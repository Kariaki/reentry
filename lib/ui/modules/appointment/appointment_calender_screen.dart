import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:reentry/ui/modules/root/navigations/home_navigation_screen.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';

import 'bloc/appointment_state.dart';

class AppointmentCalenderScreen extends StatelessWidget {
  const AppointmentCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child: BlocConsumer<AppointmentBloc, AppointmentState>(
          builder: (context, state) {
        return BaseScaffold(
            appBar: CustomAppbar(
              title: 'Appointments',
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserInfoComponent(
                  name: 'Cameron Williamson',
                  size: 40,
                ),

                20.height,
                BoxContainer(
                    radius: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.height,Text(
                          'Date and time',
                          style: context.textTheme.bodyLarge,
                        ),
                        10.height,
                        DateTimePicker(),
                        20.height,
                        Text(
                          'Select time',
                          style: context.textTheme.bodyLarge,
                        ),
                        10.height,
                        const DateTimePicker(
                          title: 'Select time',
                          icon: Icons.timelapse,
                        ),
                      ],
                    )),
                20.height,
                Text('Notes', style: context.textTheme.bodyLarge),
                10.height,
                InputField(
                  hint: 'Enter notes here',
                  lines: 3,
                  radius: 10,
                  fillColor: AppColors.gray1,
                ),
                30.height,
                PrimaryButton(
                  text: 'Save appointment',
                  onPress: () {
                    context.pushReplace(SuccessScreen(
                      callback: () {
                        context.pushRemoveUntil(const HomeNavigationScreen());
                      },
                      title: 'Appointment saved',
                      description:
                          "Your appointment has been scheduled successfully",
                    ));
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
