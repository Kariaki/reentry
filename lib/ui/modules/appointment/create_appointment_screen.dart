import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/appointment_dto.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/app_button.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/container/box_container.dart';
import 'package:reentry/ui/components/date_dialog.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/appointment/bloc/appointment_bloc.dart';
import 'package:reentry/ui/modules/appointment/modal/rejection_reason_modal.dart';
import 'package:reentry/ui/modules/appointment/select_appointment_user.dart';
import 'package:reentry/ui/modules/appointment/select_appointment_user_screen_non_client.dart';
import 'package:reentry/ui/modules/shared/success_screen.dart';
import '../../../data/enum/account_type.dart';
import '../authentication/bloc/account_cubit.dart';
import 'bloc/appointment_event.dart';
import 'bloc/appointment_state.dart';

class AppointmentUserDto {
  final String name;
  final String userId;
  final String avatar;

  const AppointmentUserDto(
      {required this.userId, required this.name, required this.avatar});
}

class CreateAppointmentScreen extends HookWidget {
  final NewAppointmentDto? appointment;
  final bool cancel;
  final bool reschedule;

  const CreateAppointmentScreen(
      {super.key, this.appointment, this.cancel = false,this.reschedule=false});

  @override
  Widget build(BuildContext context) {
    print(cancel);
    final titleController = useTextEditingController(text: appointment?.title);
    final descriptionController =
        useTextEditingController(text: appointment?.description);
    final locationController =
        useTextEditingController(text: appointment?.location);
    final date = useState<DateTime?>(appointment?.date);
    final selectedTime = useState<TimeOfDay?>(
        TimeOfDay.fromDateTime(appointment?.date ?? DateTime.now()));
    final participant =
        useState<AppointmentUserDto?>(appointment?.getParticipant());
    final currentKey = GlobalKey<FormState>();
    final addToCalender = useState<bool>(false);
    final creator = context.watch<AccountCubit>().state;
    if (creator == null) {
      return SizedBox();
    }
    return BlocProvider(
      create: (context) => AppointmentBloc(),
      child: BlocConsumer<AppointmentBloc, AppointmentState>(builder: (
        context,
        state,
      ) {
        return  Container(
          constraints: BoxConstraints(
            maxHeight: reschedule?500:double.infinity
          ),
          child: BaseScaffold(
              appBar: CustomAppbar(
                title: 'Appointments',
                onBackPress: () {
                  context.popBack();
                },
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(!reschedule)
                      ...[   InputField(
                        hint: 'Lose 10 pounds',
                        label: "Appointment title",
                        controller: titleController,
                        radius: 5,
                      ),
                        15.height,
                        InputField(
                          hint: 'Enter a description of your appointment',
                          radius: 5,
                          controller: descriptionController,
                          lines: 3,
                          label: 'Appointment descriptions',
                        ),
                        30.height,],
                    BoxContainer(
                      width: double.infinity,
                      horizontalPadding: 15,
                      radius: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              titleItem(
                                  icon: Icons.calendar_today_outlined,
                                  onClick: () async {
                                    context.displayDialog(
                                        DateTimeDialog(onSelect: (result) {
                                          date.value = result;
                                        }));
                                  },
                                  title: 'Date & Time',
                                  description:
                                  date.value?.formatDate() ?? 'Select date'),
                              AppFilledButton(
                                title: selectedTime.value == null
                                    ? "Select time"
                                    : selectedTime.value!.format(context),
                                onPress: () async {
                                  final result = await context
                                      .displayDialog(AppTimePicker());
                                  final data = result as TimeOfDay?;
                                  if (data != null) {
                                    selectedTime.value = data;
                                  }
                                },
                                textColor: AppColors.white,
                                backgroundColor: Colors.grey.shade900,
                                useBorder: false,
                              )
                            ],
                          ),
                          15.height,
                          titleItem(
                              icon: Icons.add_location_alt_outlined,
                              title: 'Location',
                              editable: true,
                              onClick: () {},
                              controller: locationController,
                              description: 'Enter appointment location'),
                        if(!reschedule)
                        ...[  15.height,
                          titleItem(
                              icon: Icons.person_add_alt_outlined,
                              title: 'Participants',
                              onClick: () async {
                                Widget? route;
                                if (creator.accountType != AccountType.citizen) {
                                  route =
                                  const SelectAppointmentUserScreenNonClient();
                                } else {
                                  route =
                                  const SelectAppointmentUserScreenClient();
                                }
                                dynamic result;
                                if (kIsWeb) {
                                  context.displayDialog(route);
                                } else {
                                  result = await context.push(route);
                                }
                                final data = result as AppointmentUserDto?;
                                participant.value = data;
                              },
                              description:
                              participant.value?.name ?? 'Add participants')],
                        ],
                      ),
                    ),
                    15.height,
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Add event to your calender',
                            style: context.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                          SizedBox(
                            child: Switch(
                                value: addToCalender.value,
                                activeColor: AppColors.white,
                                activeTrackColor: AppColors.primary,
                                onChanged: (checked) {
                                  addToCalender.value = checked;
                                }),
                          )
                        ],
                      ),
                    ),
                    10.height,
                    const Divider(
                      height: .5,
                      thickness: .2,
                    ),
                    10.height,
                    const Text(
                      'Participants will be informed of your appointment',
                      style: TextStyle(color: AppColors.gray2),
                    ),
                    50.height,
                    PrimaryButton(
                        text: appointment != null ? 'Save' : 'Create appointment',
                        loading: state is AppointmentLoading,
                        enable: date.value != null && selectedTime.value != null,
                        onPress: () async {
                          // if(!currentKey.currentState!.validate()){
                          //   return;
                          // }
                          if (date.value == null || selectedTime.value == null) {
                            return;
                          }
                          final resultDate = date.value?.copyWith(
                              hour: selectedTime.value!.hour,
                              minute: selectedTime.value!.minute);
                          if (resultDate == null) {
                            return;
                          }
                          if (addToCalender.value) {
                            await createGoogleCalendarEvent(
                                titleController.text,
                                descriptionController.text,
                                locationController.text,
                                resultDate);
                          }
                          final data = NewAppointmentDto(
                              title: titleController.text,
                              id: appointment?.id,
                              description: descriptionController.text,
                              date: resultDate,
                              creatorAvatar:
                              creator.avatar ?? AppConstants.avatar,
                              creatorName: creator.name,
                              participantAvatar: participant.value?.avatar,
                              participantId: participant.value?.userId,
                              participantName: participant.value?.name,
                              status: AppointmentStatus.upcoming,
                              location: locationController.text.isEmpty
                                  ? null
                                  : locationController.text,
                              creatorId: creator.userId ?? '',
                              state: participant.value == null
                                  ? EventState.accepted
                                  : EventState.pending);
                          if (appointment != null) {
                            context
                                .read<AppointmentBloc>()
                                .add(UpdateAppointmentEvent(data));
                            return;
                          }
                          context
                              .read<AppointmentBloc>()
                              .add(CreateAppointmentEvent(data));
                        }),
                    if (
                        (appointment?.date.isAfter(DateTime.now()) ?? false)) ...[
                      10.height,
                      PrimaryButton.dark(
                          text: 'Cancel',
                          onPress: () async {
                            AppAlertDialog.show(context,
                                title: 'Cancel appointment?',
                                description:
                                'Are you sure you want to cancel this appointment?',
                                action: 'Confirm', onClickAction: () {
                                  if (appointment == null) {
                                    return;
                                  }
                                  context.read<AppointmentBloc>().add(
                                      CancelAppointmentEvent(appointment!.copyWith(
                                          status: AppointmentStatus.canceled)));
                                });
                          })
                    ],
                    if (cancel) ...[
                      10.height,
                      PrimaryButton.dark(
                          text: 'Cancel',
                          onPress: () async {
                            AppAlertDialog.show(context,
                                title: 'Cancel appointment?',
                                description:
                                'Are you sure you want to cancel this appointment?',
                                action: 'Confirm', onClickAction: () {
                                  if (appointment == null) {
                                    return;
                                  }
                                  context.read<AppointmentBloc>().add(
                                      CancelAppointmentEvent(appointment!.copyWith(
                                          status: AppointmentStatus.canceled)));
                                });
                          })
                    ],
                    50.height,
                  ],
                ),
              )),
        );
      }, listener: (_, state) {
        if (state is AppointmentSuccess) {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Appointment created successfully"),
                backgroundColor: AppColors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            context.pushReplace(SuccessScreen(
              callback: () {},
              title: 'Appointment created successfully',
              description: 'Your appointment have been created successfully',
            ));
          }
          return;
        }
        if (state is UpdateAppointmentSuccess) {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Appointment updated successfully"),
                backgroundColor: AppColors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            context.pushReplace(SuccessScreen(
              callback: () {},
              title: 'Appointment updated successfully',
              description: 'Your appointment have been updated successfully',
            ));
          }
          return;
        }
        if (state is CancelAppointmentSuccess) {
          if (kIsWeb) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Appointment canceled successfully"),
                backgroundColor: AppColors.green,
              ),
            );
            Navigator.pop(context);
          } else {
            context.pushReplace(SuccessScreen(
              callback: () {},
              title: 'Appointment canceled successfully',
              description: 'Your appointment have been canceled',
            ));
          }

          return;
        }
        if (state is AppointmentError) {
          context.showSnackbarError(state.message);
        }
      }),
    );
  }

  Future<void> createGoogleCalendarEvent(String title, String description,
      String location, DateTime startDate) async {
    final event = Event(
      title: title,
      description: description,
      location: location,
      startDate: startDate,
      // Local time
      endDate: startDate,
      allDay: false,
    );
    await Add2Calendar.addEvent2Cal(event);
  }
}

Widget titleItem(
    {required IconData icon,
    required String title,
    bool editable = false,
    TextEditingController? controller,
    required Function() onClick,
    required String description}) {
  return Builder(builder: (context) {
    final textStyle = context.textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onClick,
              child: Icon(
                icon,
                color: AppColors.greyWhite,
              ),
            ),
            5.width,
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textStyle.bodyLarge,
                ),
                5.height,
                if (editable)
                  SizedBox(
                    height: 15,
                    width: 200,
                    child: TextField(
                      controller: controller,
                      onTap: () {},
                      cursorColor: AppColors.primary,
                      style:
                          textStyle.bodySmall?.copyWith(color: AppColors.gray2),
                      cursorHeight: 18,
                      decoration: InputDecoration(
                          hintText: description,
                          border: InputBorder.none,
                          hintStyle: textStyle.bodySmall
                              ?.copyWith(color: AppColors.gray2)),
                    ),
                  )
                else
                  InkWell(
                    onTap: onClick,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text(
                        description,
                        style: textStyle.bodySmall
                            ?.copyWith(color: AppColors.gray2),
                      ),
                    ),
                  )
              ],
            )
          ],
        ),
      ],
    );
  });
}
