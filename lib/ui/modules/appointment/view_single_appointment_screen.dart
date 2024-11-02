import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/main.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/select_appointment_user.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';

import '../../../core/theme/colors.dart';
import '../../../data/model/appointment_dto.dart';
import '../../components/container/box_container.dart';
import '../../components/date_time_picker.dart';
import '../../components/input/input_field.dart';

class ViewSingleAppointmentScreen extends HookWidget {
  final AppointmentEntityDto entity;
  const ViewSingleAppointmentScreen({super.key,required this.entity});
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
    final controller = useTextEditingController(text:entity.note??'');
    final user = context.read<AccountCubit>().state;
    if(user==null){
      return const SizedBox();
    }
    final createdByMe = entity.userId!=user.userId;
    return BaseScaffold(
        appBar: const CustomAppbar(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              label('Appointments'),
              10.height,
              selectableUserContainer(name: entity.name, onTap: (){},url: entity.avatar),
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
                          if(!createdByMe){
                            return;
                          }
                          final result = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2050),
                          );
                          if(result==null){
                            return;
                          }
                          time.value = result;
                        },
                        title: time.value.formatDate(),
                      ),
                      20.height,
                      Text(
                        'Select time',
                        style: context.textTheme.bodyLarge,
                      ),
                      10.height,
                      DateTimePicker(
                        title:'${time.value.hour.toString()}:${time.value.minute}',
                        icon: Icons.timelapse,
                        onTap: () async {
                          if(!createdByMe){
                            return;
                          }
                          // final result = await showTimePicker(
                          //     context: context,
                          //     builder: (context, child) {
                          //       return MediaQuery(
                          //         data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          //         child: child ?? Container(),
                          //       );
                          //     },
                          //     initialTime:
                          //     const TimeOfDay(hour: 00, minute: 00),
                          //     initialEntryMode: TimePickerEntryMode.input);
                          // print(result?.toString());
                          // time.value = result;
                        },
                      ),
                    ],
                  )),
              20.height,

              InputField(
                hint: 'Enter notes here (Optional)',
                controller: controller,enable: createdByMe,
                lines: 3,
                radius: 10,
                fillColor: AppColors.gray1,
              ),
              20.height,
              if(createdByMe)
                ...[ PrimaryButton(text: "Save appointment",onPress: (){
                  //update appointment
                },),
                  15.height,
                  PrimaryButton.dark(text: "Cancel appointment",onPress: (){
                    //show cancel modal
                  })]
            ],
          ),
        ));
  }
}
