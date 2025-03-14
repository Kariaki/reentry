import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/appointment/component/appointment_component.dart';

class ViewAppointmentsScreen extends StatelessWidget {

  const ViewAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      appBar: const CustomAppbar(
        title: "Sainte",
      ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          30.height,
          // const AppointmentComponent(invitation: true),
          // 20.height,
          const AppointmentComponent(showCreate: false,)
                ],
              ),
        ));
  }

}
