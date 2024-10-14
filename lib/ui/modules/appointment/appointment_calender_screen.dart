import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';

class AppointmentCalenderScreen extends StatelessWidget {
  const AppointmentCalenderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: CustomAppbar(
        title: 'Appointments',
      ),
        child: Column(children: [
      
          UserInfoComponent(name: 'Cameron Williamson',size: 40,),
          20.height,
          Text('Select date and time',style: Theme.of(context).textTheme.bodyLarge,),
          5.height,
          PrimaryButton(text: 'Save appointment',onPress: (){},),
          10.height,
          PrimaryButton.dark(text: 'Cancel appointment'),
    ],));
  }
}
