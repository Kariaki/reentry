import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/appointment/appointment_calender_screen.dart';

class SelectReportUserScreen extends HookWidget {
  const SelectReportUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedUser = useState(-1);
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: 'Report user',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text('Select client',style: AppStyles.textTheme(context).bodyLarge,),
            20.height,
            //show list Item
            ListView.builder(
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return selectableUserContainer(
                    name: 'Cameron Williamson',
                    url: '',
                    selected: selectedUser.value == index,
                    onTap: () {
                      selectedUser.value = index;
                    });
              },
            ),
            50.height,
            PrimaryButton(
              text: 'Continue',
              onPress: () {
                context.push(AppointmentCalenderScreen());
              },
            ),
            20.height,
          ],
        ));
  }

  Widget selectableUserContainer(
      {required String name,
        String? url,
        bool selected = false,
        required Function() onTap}) {
    return InkWell(
      radius: 50,
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(
                    color: selected ? AppColors.white : Colors.transparent))),
        child: UserInfoComponent(
          name: name,
          url: url,
          size: 40,
        ),
      ),
    );
  }
}
