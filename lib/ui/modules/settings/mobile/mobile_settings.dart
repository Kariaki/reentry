import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/messaging/entity/conversation_user_entity.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_cubit.dart';
import 'package:reentry/ui/modules/profile/bloc/profile_state.dart';

import '../../../../data/model/user_dto.dart';
import '../../authentication/bloc/account_cubit.dart';

class NotificationSettings extends HookWidget {
  const NotificationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit,UserDto?>(builder: (context,state){
      return BaseScaffold(
          appBar: const CustomAppbar(
            title: 'Notification Settings',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Text('Select client',style: AppStyles.textTheme(context).bodyLarge,),
              20.height,
              //show list Item

              selectableUserContainer(
                  name: 'Push notification',
                  initialValue: state?.settings.pushNotification ?? false,
                  onTap: (result) {
                    final output = state?.settings.copyWith(pushNotification: result);
                    if (output == null) {
                      return;
                    }
                    context.read<AccountCubit>().updateSettings(output);
                    //update settings
                  }),
              20.height,
            ],
          ));
    });
  }

  Widget selectableUserContainer(
      {required String name,
      bool initialValue = false,
      required Function(bool) onTap}) {
    return HookBuilder(builder: (context) {
      final value = useState(initialValue);
      final textStyle = context.textTheme.titleSmall;
      return InkWell(
        radius: 50,
        borderRadius: BorderRadius.circular(50),
        onTap: () {

          onTap(!value.value);
          value.value = !value.value;
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                name,
                style: textStyle,
              ),
              Switch(
                  value: value.value,
                  activeColor: AppColors.white,
                  activeTrackColor: AppColors.primary,
                  onChanged: (checked) {
                    value.value = checked;
                    onTap(checked);
                  })
            ],
          ),
        ),
      );
    });
  }
}
