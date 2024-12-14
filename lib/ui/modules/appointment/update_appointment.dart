import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_bloc.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/user_profile_cubit.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../core/enum/days.dart';
import '../calender/calender_screen.dart';
import '../profile/bloc/profile_state.dart';
import 'bloc/appointment_event.dart';
import 'bloc/appointment_state.dart';

class UpdateAppointmentDto {
  final String name;
  final String userId;
  final String avatar;
  final String appointmentId;
  final String note;
  final DateTime appointmentTime;
  final AppointmentStatus status;
  final String bookedTime;
  final int bookedDay;

  const UpdateAppointmentDto(
      {required this.userId,
      required this.name,
        required this.appointmentTime,
        required this.status,
      required this.avatar,
      required this.bookedDay,
      required this.bookedTime,
      required this.note,
      required this.appointmentId});
}

class UpdateAppointmentScreen extends HookWidget {
  final UpdateAppointmentDto appointmentEntity;

  const UpdateAppointmentScreen({super.key, required this.appointmentEntity});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: appointmentEntity.note);
    final date = useState<DateTime?>(null);
    final time = useState<TimeOfDay?>(null);
    return BlocProvider(
      create: (context) => UserProfileCubit()..loadFromCloud(appointmentEntity.userId),
      child: BlocProvider(
        create: (context) => AppointmentBloc(),
        child: BlocConsumer<AppointmentBloc, AppointmentState>(
            builder: (context, state) {
          return BaseScaffold(
              appBar: const CustomAppbar(
                title: 'Appointments',
              ),
              child: BlocBuilder<UserProfileCubit, ProfileState>(
                  builder: (context, state) {
                if (state is ProfileLoading) {
                  return const LoadingComponent();
                }
                if (state is ProfileError) {
                  return ErrorComponent(
                    title: "Something went wrong",
                    description: state.message,
                    actionButtonText: "Go Back",
                    onActionButtonClick: () {
                      context.popRoute();
                    },
                  );
                }
                if (state is ProfileDataSuccess) {
                  return _pageView(
                      state.data, context, date, time, controller, state);
                }
                return const SizedBox();
              }));
        }, listener: (_, state) {
          if (state is AppointmentSuccess) {
            context.pushReplace(SuccessScreen(
              callback: () {},
              title: 'Appointment updated successfully',
              description: 'You appointment have been updated successfully.',
            ));
            return;
          }
          if (state is AppointmentError) {
            context.showSnackbarError(state.message);
          }
        }),
      ),
    );
  }

  Widget _pageView(
      UserDto user,
      BuildContext context,
      ValueNotifier<DateTime?> date,
      ValueNotifier<TimeOfDay?> time,
      TextEditingController controller,
      ProfileState state) {
    return BlocBuilder<AppointmentBloc, AppointmentState>(
        builder: (context, appointmentState) {
      return HookBuilder(builder: (context) {
        final days = user.availability?.days.map((e) => Days.values[e]) ?? [];
        final time = user.availability?.time.map((e) => e) ?? [];
        final selectedDay = useState<Days?>(Days.values[appointmentEntity.bookedDay]);
        final selectedTime = useState<String?>(appointmentEntity.bookedTime);
        final status = useState<AppointmentStatus>(AppointmentStatus.upcoming);
        final isPassed = appointmentEntity.appointmentTime.isBefore(DateTime.now());

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              UserInfoComponent(
                name: user.name,
                size: 40,
              ),
              20.height,
              if (time.isNotEmpty && days.isNotEmpty && !isPassed) ...[
                Text(
                  "Select day",
                  style: context.textTheme.bodyLarge,
                ),
                10.height,
                Wrap(
                  runSpacing: 5,
                  spacing: 8,
                  children: days
                      .map((e) =>
                          dayComponent(e, selected: selectedDay.value == e,
                              onClick: (result) {
                            selectedDay.value = result;
                          }))
                      .toList(),
                ),
                20.height,
                Text(
                  "Select available time",
                  style: context.textTheme.bodyLarge,
                ),
                10.height,
                Wrap(
                  runSpacing: 10,
                  spacing: 15,
                  children: getOrderedTime(time.toList()).map((index) {
                    final split = index.split(':');
                    int hour = int.parse(split[0]);
                    final one = split[1].split(" ");
                    int mins = int.tryParse(one[0]) ?? 0;
                    return timeComponent(
                        hour: hour,
                        mins: mins,
                        selected: {
                          if (selectedTime.value != null) selectedTime.value!
                        },
                        onClick: (result) {

                          selectedTime.value = result;
                        });
                  }).toList(),
                ),

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
                  loading: appointmentState is AppointmentLoading,
                  enable:
                      selectedDay.value != null && selectedTime.value != null,
                  onPress: () {
                    final daysOfWeek = getCurrentWeekDays();
                    final weekDay = selectedDay.value!.index;
                    final time = selectedTime.value!;
                    final actualSelectedWeekDay = daysOfWeek[weekDay];
                    final hour = time.split(':')[0];
                    final split = time.split(':');
                    final one = split[1].split(" ");
                    int mins = int.tryParse(one[0]) ?? 0;
                    final actualDate = DateTime.parse(actualSelectedWeekDay)
                        .copyWith(hour: int.tryParse(hour), minute: mins);
                    final timeResult = actualDate;
                    // context.read<AppointmentBloc>().add(CreateAppointmentEvent(
                    //     timestamp: timeResult.millisecondsSinceEpoch,
                    //     bookedDay: weekDay,
                    //     status: status.value,
                    //     id: appointmentEntity.appointmentId,
                    //     bookedTime: time,
                    //     userId: appointmentEntity.userId,
                    //     notes: controller.text));
                  },
                ),
              ],

            if(!isPassed && appointmentEntity.status == AppointmentStatus.upcoming)
            ...[
              Text(
                "Update status",
                style: context.textTheme.bodyLarge,
              ),
              10.height,
              Wrap(
                runSpacing: 10,
                spacing: 15,
                children: AppointmentStatus.values.where((e)=>e!=AppointmentStatus.canceled)
                    .map((element){
                  return selectableComponent(text: element.name.capitalizeFirst(), selected: status.value == element, onClick: (){
                    status.value = element;
                  });
                }).toList(),
              )],
              if (time.isEmpty && days.isEmpty)
                ErrorComponent(
                  title: "No availability",
                  description: "${user.name} has no availability at the moment",
                  actionButtonText: "Go back",
                  onActionButtonClick: () {
                    context.popRoute();
                  },
                )
            ],
          ),
        );
      });
    });
  }
}
