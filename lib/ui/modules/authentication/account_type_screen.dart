import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/app_check_box.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/pill_selector_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/scaffold/onboarding_scaffold.dart';
import 'package:reentry/ui/modules/authentication/basic_info_screen.dart';

import 'bloc/authentication_state.dart';

class AccountTypeScreen extends HookWidget {
  final OnboardingEntity data;

  const AccountTypeScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    print(data.name);
    final selection = useState(-1);
    final medicalCheckState = useState(false);
    final nonMedicalCheckState = useState(false);
    return OnboardingScaffold(
      description: 'Please select your identity to begin your journey',
      children: [
        50.height,
        PillSelector(
            options: AppConstants.accountType,
            onChange: (index) {
              selection.value = index;
            }),
        if (selection.value == AppConstants.accountType.length - 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              appCheckBox(medicalCheckState.value, (val) {
                medicalCheckState.value = val ?? false;
                if (val == true) {
                  nonMedicalCheckState.value = false;
                }
              }, title: "Medical"),
              appCheckBox(nonMedicalCheckState.value, (val) {
                nonMedicalCheckState.value = val ?? false;
                if (val == true) {
                  medicalCheckState.value = false;
                }
              }, title: "Non-Medical"),
            ],
          ),
        30.height,
        PrimaryButton(
            text: 'Continue',
            enable: selection.value != -1,
            onPress: () {
              if (selection.value == -1) {
                return;
              }
              final result = data.copyWith(
                  accountType: AccountType.values[selection.value]);
              context.push(BasicInfoScreen(
                data: result,
              ));
            })
      ],
    );
  }
}
